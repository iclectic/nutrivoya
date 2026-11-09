import 'package:flutter/foundation.dart';

import 'nutrition_targets.dart';

/// Confidence of an energy-requirement estimate.
///
/// Distinct from food-nutrition confidence: this describes how complete the
/// physiological inputs were for BMR/TDEE equations.
enum EnergyEstimateConfidence {
  /// Sex-specific Mifflin–St Jeor with plausible anthropometrics.
  standard,

  /// Physiological input was unspecified; averaged male/female equations.
  reduced,

  /// Inputs are outside typical adult ranges or otherwise constrained.
  limited,
}

/// Result of [EnergyRequirementService.estimate].
///
/// Always treated as an estimate. Values are rounded to avoid fake precision.
@immutable
class EnergyRequirementResult {
  const EnergyRequirementResult({
    required this.bmrKcal,
    required this.tdeeKcal,
    required this.targets,
    required this.confidence,
    required this.notes,
    this.warningCodes = const <EnergyWarningCode>[],
    this.appliedDeficitKcal,
    this.appliedSurplusKcal,
  });

  /// Estimated basal metabolic rate (kcal/day).
  final double bmrKcal;

  /// Estimated total daily energy expenditure at maintenance (kcal/day).
  final double tdeeKcal;

  /// Goal-adjusted daily nutrition targets.
  final NutritionTargets targets;

  final EnergyEstimateConfidence confidence;

  /// Human-readable context notes for UI (English keys resolved via l10n).
  final List<String> notes;

  /// Structured warnings (extreme deficit blocked, underweight + loss, etc.).
  final List<EnergyWarningCode> warningCodes;

  /// Absolute deficit applied for loss goals (kcal), if any.
  final double? appliedDeficitKcal;

  /// Absolute surplus applied for gain/muscle goals (kcal), if any.
  final double? appliedSurplusKcal;

  double? get calorieTargetKcal => targets.calorieTargetKcal;
}

/// Safety / context signals surfaced alongside an energy estimate.
enum EnergyWarningCode {
  /// Requested deficit was capped to a safer maximum.
  deficitCapped,

  /// Floor applied so target does not fall below a minimum energy intake.
  floorApplied,

  /// Lose-weight selected while BMI suggests underweight / low weight.
  loseWhileLowWeight,

  /// Age outside the adult range the equations were designed for.
  ageOutsideAdultRange,

  /// Physiological sex input was unspecified.
  physiologicalUnspecified,

  /// Goal is track-only; targets are informational maintenance estimates.
  trackOnlyInformational,
}
