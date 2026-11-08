import 'package:flutter/foundation.dart';

import '../../../core/models/activity_level.dart';
import '../../../core/models/nutrition_goal.dart';
import '../../../core/models/physiological_input.dart';
import '../../../core/models/reproductive_context.dart';
import '../../../core/models/user_profile.dart';

/// How much trust to place in an energy estimate.
enum EstimateConfidence { standard, reduced }

/// Guardrail notices surfaced alongside a target. These never block the user
/// from tracking; they explain why a target was adjusted and when to seek
/// professional guidance.
enum TargetWarning {
  /// Requested weight-change rate exceeded the safe cap and was reduced.
  rateCapped,

  /// The deficit would have pushed intake below a safe floor.
  floorApplied,

  /// No deficit during pregnancy; consult a midwife/clinician.
  pregnancyNoDeficit,

  /// No aggressive deficit while breastfeeding; extra energy is added.
  breastfeedingNoDeficit,

  /// BMI under 18.5 — weight loss is not supported; seek guidance.
  underweightNoDeficit,

  /// Under 18 — adult equations and deficits don't apply; seek guidance.
  minorNoDeficit,

  /// Physiological input unspecified — a neutral equation was used.
  neutralEquation,

  /// A user-entered custom target is unusually low.
  customTargetVeryLow,
}

/// Result of an energy requirement estimate.
@immutable
class EnergyEstimate {
  const EnergyEstimate({
    required this.bmrKcal,
    required this.tdeeKcal,
    required this.targetKcal,
    required this.confidence,
    this.warnings = const <TargetWarning>{},
  });

  /// Estimated basal metabolic rate (Mifflin-St Jeor).
  final double bmrKcal;

  /// Estimated total daily energy expenditure (maintenance).
  final double tdeeKcal;

  /// Suggested daily intake for the user's goal.
  final double targetKcal;

  final EstimateConfidence confidence;
  final Set<TargetWarning> warnings;
}

/// Centralized, tested energy-requirement logic.
///
/// Never scatter calorie formulas through UI code: everything lives here.
/// Values are estimates — the UI always communicates that actual needs vary.
class EnergyRequirementService {
  const EnergyRequirementService();

  /// Energy per kg of body-weight change used for rate conversions.
  static const double kcalPerKg = 7700;

  /// Maximum weekly loss as a fraction of body weight.
  static const double maxWeeklyLossFraction = 0.01;

  /// Maximum deficit as a fraction of TDEE.
  static const double maxDeficitFraction = 0.25;

  /// Absolute minimum suggested intake for adults.
  static const double absoluteFloorKcal = 1200;

  /// Default rate when the user hasn't chosen one.
  static const double defaultLossRateKgPerWeek = 0.5;
  static const double defaultGainRateKgPerWeek = 0.25;

  /// Extra energy during lactation (first 6 months, IOM/NASEM estimate).
  static const double lactationExtraKcal = 330;

  static double activityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.active:
        return 1.725;
      case ActivityLevel.extra:
        return 1.9;
    }
  }

  /// Mifflin-St Jeor BMR. For an unspecified physiological input the midpoint
  /// of the two sex constants is used and confidence is reduced.
  double bmr({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required PhysiologicalInput input,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
    switch (input) {
      case PhysiologicalInput.male:
        return base + 5;
      case PhysiologicalInput.female:
        return base - 161;
      case PhysiologicalInput.unspecified:
        return base - 78;
    }
  }

  EnergyEstimate estimate(UserProfile profile) {
    final warnings = <TargetWarning>{};
    final bmrKcal = bmr(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      ageYears: profile.ageYears,
      input: profile.physiologicalInput,
    );
    final tdee = bmrKcal * activityMultiplier(profile.activityLevel);
    final confidence =
        profile.physiologicalInput == PhysiologicalInput.unspecified
            ? EstimateConfidence.reduced
            : EstimateConfidence.standard;
    if (confidence == EstimateConfidence.reduced) {
      warnings.add(TargetWarning.neutralEquation);
    }

    var target = tdee;
    final repro = profile.reproductiveContext;
    final wantsDeficit = profile.goal == NutritionGoal.loseWeight;
    final wantsSurplus = profile.goal == NutritionGoal.gainWeight ||
        profile.goal == NutritionGoal.buildMuscle;

    if (repro == ReproductiveContext.breastfeeding) {
      target += lactationExtraKcal;
    }

    if (wantsDeficit) {
      if (profile.ageYears < 18) {
        warnings.add(TargetWarning.minorNoDeficit);
      } else if (repro == ReproductiveContext.pregnant) {
        warnings.add(TargetWarning.pregnancyNoDeficit);
      } else if (repro == ReproductiveContext.breastfeeding) {
        warnings.add(TargetWarning.breastfeedingNoDeficit);
      } else if (profile.bmi < 18.5) {
        warnings.add(TargetWarning.underweightNoDeficit);
      } else {
        target = _deficitTarget(profile, bmrKcal, tdee, warnings);
      }
    } else if (wantsSurplus) {
      target += _surplus(profile, tdee, warnings);
    } else if (repro == ReproductiveContext.pregnant) {
      warnings.add(TargetWarning.pregnancyNoDeficit);
    }

    return EnergyEstimate(
      bmrKcal: bmrKcal,
      tdeeKcal: tdee,
      targetKcal: target,
      confidence: confidence,
      warnings: warnings,
    );
  }

  double _deficitTarget(
    UserProfile profile,
    double bmrKcal,
    double tdee,
    Set<TargetWarning> warnings,
  ) {
    var rate = profile.targetRateKgPerWeek ?? defaultLossRateKgPerWeek;
    final maxRate = profile.weightKg * maxWeeklyLossFraction;
    if (rate > maxRate) {
      rate = maxRate;
      warnings.add(TargetWarning.rateCapped);
    }
    var deficit = rate * kcalPerKg / 7;
    final maxDeficit = tdee * maxDeficitFraction;
    if (deficit > maxDeficit) {
      deficit = maxDeficit;
      warnings.add(TargetWarning.rateCapped);
    }
    final floor = bmrKcal > absoluteFloorKcal ? bmrKcal : absoluteFloorKcal;
    final target = tdee - deficit;
    if (target < floor) {
      warnings.add(TargetWarning.floorApplied);
      return floor < tdee ? floor : tdee;
    }
    return target;
  }

  double _surplus(
    UserProfile profile,
    double tdee,
    Set<TargetWarning> warnings,
  ) {
    if (profile.goal == NutritionGoal.buildMuscle) {
      final s = tdee * 0.10;
      return s > 350 ? 350 : s;
    }
    var rate = profile.targetRateKgPerWeek ?? defaultGainRateKgPerWeek;
    if (rate > 0.5) {
      rate = 0.5;
      warnings.add(TargetWarning.rateCapped);
    }
    return rate * kcalPerKg / 7;
  }

  /// Checks a user-entered custom calorie target against guardrails.
  Set<TargetWarning> checkCustomTarget(double kcal, EnergyEstimate estimate) {
    final floor = estimate.bmrKcal > absoluteFloorKcal
        ? estimate.bmrKcal
        : absoluteFloorKcal;
    return {if (kcal < floor) TargetWarning.customTargetVeryLow};
  }
}
