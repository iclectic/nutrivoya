/// A user's primary nutrition goal.
///
/// Nutrivoya never forces weight loss. Goals drive target calculations later
/// (Milestone 4) and are stored on the profile.
enum NutritionGoal {
  maintainWeight,
  loseWeight,
  gainWeight,
  buildMuscle,
  improveNutrition,
  trackOnly,
}

/// Extension providing a stable storage key and localization key per goal.
extension NutritionGoalX on NutritionGoal {
  /// Stable identifier persisted to storage / backend.
  String get id => name;

  /// Localization key resolved in the UI.
  String get l10nKey {
    switch (this) {
      case NutritionGoal.maintainWeight:
        return 'onboardingGoalMaintain';
      case NutritionGoal.loseWeight:
        return 'onboardingGoalLose';
      case NutritionGoal.gainWeight:
        return 'onboardingGoalGain';
      case NutritionGoal.buildMuscle:
        return 'onboardingGoalBuildMuscle';
      case NutritionGoal.improveNutrition:
        return 'onboardingGoalImprove';
      case NutritionGoal.trackOnly:
        return 'onboardingGoalTrack';
    }
  }

  static NutritionGoal fromId(String id) {
    return NutritionGoal.values.firstWhere(
      (e) => e.id == id,
      orElse: () => NutritionGoal.trackOnly,
    );
  }
}
