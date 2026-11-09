import 'package:flutter/foundation.dart';

import 'nutrition_goal.dart';

/// Daily nutrition targets computed by [EnergyRequirementService].
///
/// Calorie and macro values are estimates, rounded to avoid fake precision.
@immutable
class NutritionTargets {
  const NutritionTargets({
    this.calorieTargetKcal,
    this.proteinTargetG,
    this.carbTargetG,
    this.fatTargetG,
    this.fibreTargetG,
    this.bmrKcal,
    this.tdeeKcal,
    this.goal = NutritionGoal.trackOnly,
    this.isEstimate = true,
  });

  final double? calorieTargetKcal;
  final double? proteinTargetG;
  final double? carbTargetG;
  final double? fatTargetG;
  final double? fibreTargetG;

  /// Estimated basal metabolic rate used to derive the calorie target.
  final double? bmrKcal;

  /// Estimated maintenance expenditure (TDEE) before goal adjustment.
  final double? tdeeKcal;

  final NutritionGoal goal;

  /// Always true for Nutrivoya: calculated targets are estimates, not facts.
  final bool isEstimate;

  bool get isConfigured => calorieTargetKcal != null;

  NutritionTargets copyWith({
    double? calorieTargetKcal,
    double? proteinTargetG,
    double? carbTargetG,
    double? fatTargetG,
    double? fibreTargetG,
    double? bmrKcal,
    double? tdeeKcal,
    NutritionGoal? goal,
    bool? isEstimate,
  }) {
    return NutritionTargets(
      calorieTargetKcal: calorieTargetKcal ?? this.calorieTargetKcal,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      carbTargetG: carbTargetG ?? this.carbTargetG,
      fatTargetG: fatTargetG ?? this.fatTargetG,
      fibreTargetG: fibreTargetG ?? this.fibreTargetG,
      bmrKcal: bmrKcal ?? this.bmrKcal,
      tdeeKcal: tdeeKcal ?? this.tdeeKcal,
      goal: goal ?? this.goal,
      isEstimate: isEstimate ?? this.isEstimate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionTargets &&
          runtimeType == other.runtimeType &&
          calorieTargetKcal == other.calorieTargetKcal &&
          proteinTargetG == other.proteinTargetG &&
          carbTargetG == other.carbTargetG &&
          fatTargetG == other.fatTargetG &&
          fibreTargetG == other.fibreTargetG &&
          bmrKcal == other.bmrKcal &&
          tdeeKcal == other.tdeeKcal &&
          goal == other.goal &&
          isEstimate == other.isEstimate;

  @override
  int get hashCode => Object.hash(
        calorieTargetKcal,
        proteinTargetG,
        carbTargetG,
        fatTargetG,
        fibreTargetG,
        bmrKcal,
        tdeeKcal,
        goal,
        isEstimate,
      );
}
