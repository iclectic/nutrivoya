import 'package:flutter/foundation.dart';

import 'nutrition_goal.dart';

/// Daily nutrition targets.
///
/// In Milestone 1 these are placeholders only — actual values are computed by
/// `EnergyRequirementService` in Milestone 4. The model exists so the
/// dashboard/settings can render the structure now.
@immutable
class NutritionTargets {
  const NutritionTargets({
    this.calorieTargetKcal,
    this.proteinTargetG,
    this.carbTargetG,
    this.fatTargetG,
    this.fibreTargetG,
    this.goal = NutritionGoal.trackOnly,
    this.isEstimate = true,
  });

  final double? calorieTargetKcal;
  final double? proteinTargetG;
  final double? carbTargetG;
  final double? fatTargetG;
  final double? fibreTargetG;
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
    NutritionGoal? goal,
    bool? isEstimate,
  }) {
    return NutritionTargets(
      calorieTargetKcal: calorieTargetKcal ?? this.calorieTargetKcal,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      carbTargetG: carbTargetG ?? this.carbTargetG,
      fatTargetG: fatTargetG ?? this.fatTargetG,
      fibreTargetG: fibreTargetG ?? this.fibreTargetG,
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
          goal == other.goal &&
          isEstimate == other.isEstimate;

  @override
  int get hashCode => Object.hash(
        calorieTargetKcal,
        proteinTargetG,
        carbTargetG,
        fatTargetG,
        fibreTargetG,
        goal,
        isEstimate,
      );
}
