import '../models/activity_level.dart';
import '../models/energy_requirement.dart';
import '../models/nutrition_goal.dart';
import '../models/nutrition_targets.dart';
import '../models/physiological_input.dart';
import '../models/user_profile.dart';

/// Calculates estimated BMR, TDEE and daily nutrition targets.
///
/// All calorie formulas live here — never in UI widgets.
///
/// Method:
/// - BMR: Mifflin–St Jeor (1990)
/// - TDEE: BMR × activity multiplier
/// - Goal adjustment: modest deficit/surplus with hard safety floors
/// - Protein: individualized g/kg based on goal (not bodybuilding extremes)
/// - Fat: ~28% of energy
/// - Carbohydrate: remainder of energy
/// - Fibre: ~14 g per 1000 kcal, floored at 25 g for adults
///
/// Results are rounded (calories to nearest 10, macros to whole grams) so the
/// UI never presents fake precision.
class EnergyRequirementService {
  const EnergyRequirementService();

  /// Standard activity multipliers applied to BMR.
  static const Map<ActivityLevel, double> activityMultipliers = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.active: 1.725,
    ActivityLevel.extra: 1.9,
  };

  /// Soft weekly loss equivalent (~0.5 kg/week ≈ 500 kcal/day).
  static const double defaultDeficitKcal = 500;

  /// Soft surplus for weight gain.
  static const double defaultSurplusKcal = 300;

  /// Soft surplus for muscle-building (smaller than pure bulk).
  static const double muscleSurplusKcal = 250;

  /// Maximum deficit as a fraction of TDEE.
  static const double maxDeficitFraction = 0.25;

  /// Absolute maximum deficit (kcal/day).
  static const double maxDeficitKcal = 750;

  /// Minimum calorie floors by physiological input (wellness guardrails).
  static const double minCaloriesFemale = 1200;
  static const double minCaloriesMale = 1500;
  static const double minCaloriesUnspecified = 1350;

  /// Estimate energy needs and targets from a [UserProfile].
  EnergyRequirementResult estimate(UserProfile profile) {
    final warnings = <EnergyWarningCode>[];
    final notes = <String>[];

    var confidence = EnergyEstimateConfidence.standard;

    if (profile.physiologicalInput == PhysiologicalInput.unspecified) {
      confidence = EnergyEstimateConfidence.reduced;
      warnings.add(EnergyWarningCode.physiologicalUnspecified);
      notes.add('energyNotePhysiologicalUnspecified');
    }

    if (profile.ageYears < 18 || profile.ageYears > 80) {
      confidence = EnergyEstimateConfidence.limited;
      warnings.add(EnergyWarningCode.ageOutsideAdultRange);
      notes.add('energyNoteAgeOutsideAdultRange');
    }

    final bmr = _bmr(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      ageYears: profile.ageYears,
      physio: profile.physiologicalInput,
    );

    final multiplier =
        activityMultipliers[profile.activityLevel] ?? 1.2;
    final tdee = bmr * multiplier;

    final bmi = _bmi(profile.weightKg, profile.heightCm);
    if (profile.goal == NutritionGoal.loseWeight && bmi < 18.5) {
      warnings.add(EnergyWarningCode.loseWhileLowWeight);
      notes.add('energyNoteLoseWhileLowWeight');
    }

    final adjustment = _calorieAdjustment(
      goal: profile.goal,
      tdee: tdee,
      physio: profile.physiologicalInput,
      warnings: warnings,
      notes: notes,
    );

    final calorieTarget = _roundCalories(adjustment.targetKcal);
    final proteinG = _proteinTargetG(profile);
    final fatG = _fatTargetG(calorieTarget);
    final carbG = _carbTargetG(calorieTarget, proteinG, fatG);
    final fibreG = _fibreTargetG(calorieTarget);

    if (profile.goal == NutritionGoal.trackOnly) {
      warnings.add(EnergyWarningCode.trackOnlyInformational);
      notes.add('energyNoteTrackOnly');
    } else {
      notes.add('energyNoteEstimateDisclaimer');
    }

    final targets = NutritionTargets(
      calorieTargetKcal: calorieTarget,
      proteinTargetG: proteinG,
      carbTargetG: carbG,
      fatTargetG: fatG,
      fibreTargetG: fibreG,
      goal: profile.goal,
      isEstimate: true,
      bmrKcal: _roundCalories(bmr),
      tdeeKcal: _roundCalories(tdee),
    );

    return EnergyRequirementResult(
      bmrKcal: _roundCalories(bmr),
      tdeeKcal: _roundCalories(tdee),
      targets: targets,
      confidence: confidence,
      notes: List.unmodifiable(notes),
      warningCodes: List.unmodifiable(warnings),
      appliedDeficitKcal: adjustment.deficit,
      appliedSurplusKcal: adjustment.surplus,
    );
  }

  /// Mifflin–St Jeor BMR (kcal/day).
  double _bmr({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required PhysiologicalInput physio,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears);
    switch (physio) {
      case PhysiologicalInput.male:
        return base + 5;
      case PhysiologicalInput.female:
        return base - 161;
      case PhysiologicalInput.unspecified:
        // Average of male/female constants when the user prefers not to say.
        return base - 78;
    }
  }

  double _bmi(double weightKg, double heightCm) {
    final m = heightCm / 100.0;
    if (m <= 0) return 0;
    return weightKg / (m * m);
  }

  _CalorieAdjustment _calorieAdjustment({
    required NutritionGoal goal,
    required double tdee,
    required PhysiologicalInput physio,
    required List<EnergyWarningCode> warnings,
    required List<String> notes,
  }) {
    final floor = _calorieFloor(physio);
    double? deficit;
    double? surplus;
    late double target;

    switch (goal) {
      case NutritionGoal.maintainWeight:
      case NutritionGoal.improveNutrition:
      case NutritionGoal.trackOnly:
        target = tdee;
      case NutritionGoal.loseWeight:
        final rawDeficit = defaultDeficitKcal;
        final cappedByFraction = tdee * maxDeficitFraction;
        final allowedDeficit =
            [rawDeficit, cappedByFraction, maxDeficitKcal]
                .reduce((a, b) => a < b ? a : b);
        if (allowedDeficit + 0.5 < rawDeficit) {
          warnings.add(EnergyWarningCode.deficitCapped);
          notes.add('energyNoteDeficitCapped');
        }
        deficit = allowedDeficit;
        target = tdee - allowedDeficit;
      case NutritionGoal.gainWeight:
        surplus = defaultSurplusKcal;
        target = tdee + defaultSurplusKcal;
      case NutritionGoal.buildMuscle:
        surplus = muscleSurplusKcal;
        target = tdee + muscleSurplusKcal;
    }

    if (target < floor) {
      warnings.add(EnergyWarningCode.floorApplied);
      notes.add('energyNoteFloorApplied');
      target = floor;
    }

    return _CalorieAdjustment(
      targetKcal: target,
      deficit: deficit,
      surplus: surplus,
    );
  }

  double _calorieFloor(PhysiologicalInput physio) {
    switch (physio) {
      case PhysiologicalInput.female:
        return minCaloriesFemale;
      case PhysiologicalInput.male:
        return minCaloriesMale;
      case PhysiologicalInput.unspecified:
        return minCaloriesUnspecified;
    }
  }

  /// Protein g/day from body weight and goal. Moderate, evidence-aligned.
  double _proteinTargetG(UserProfile profile) {
    final kg = profile.weightKg;
    final double gPerKg;
    switch (profile.goal) {
      case NutritionGoal.loseWeight:
        gPerKg = 1.8;
      case NutritionGoal.buildMuscle:
        gPerKg = 1.8;
      case NutritionGoal.gainWeight:
        gPerKg = 1.6;
      case NutritionGoal.maintainWeight:
      case NutritionGoal.improveNutrition:
        gPerKg = 1.4;
      case NutritionGoal.trackOnly:
        gPerKg = 1.2;
    }
    return _roundMacro(kg * gPerKg);
  }

  /// ~28% of energy from fat.
  double _fatTargetG(double calorieTargetKcal) {
    return _roundMacro((calorieTargetKcal * 0.28) / 9.0);
  }

  /// Remaining energy as carbohydrate after protein and fat.
  double _carbTargetG(
    double calorieTargetKcal,
    double proteinG,
    double fatG,
  ) {
    final remaining =
        calorieTargetKcal - (proteinG * 4.0) - (fatG * 9.0);
    final carbs = remaining / 4.0;
    return _roundMacro(carbs < 0 ? 0 : carbs);
  }

  /// ~14 g fibre per 1000 kcal, floored at 25 g for typical adults.
  double _fibreTargetG(double calorieTargetKcal) {
    final raw = (calorieTargetKcal / 1000.0) * 14.0;
    final floored = raw < 25 ? 25.0 : raw;
    return _roundMacro(floored);
  }

  double _roundCalories(double value) => (value / 10).round() * 10.0;

  double _roundMacro(double value) => value.roundToDouble();
}

class _CalorieAdjustment {
  const _CalorieAdjustment({
    required this.targetKcal,
    this.deficit,
    this.surplus,
  });

  final double targetKcal;
  final double? deficit;
  final double? surplus;
}
