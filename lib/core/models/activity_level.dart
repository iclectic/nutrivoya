/// Daily activity level used in energy-requirement equations.
///
/// Maps to a multiplier applied to BMR to estimate TDEE. The exact multipliers
/// live in `EnergyRequirementService`; this enum only captures the
/// user-facing category.
enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  extra,
}

extension ActivityLevelX on ActivityLevel {
  String get id => name;

  String get l10nKey {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'onboardingActivitySedentary';
      case ActivityLevel.light:
        return 'onboardingActivityLight';
      case ActivityLevel.moderate:
        return 'onboardingActivityModerate';
      case ActivityLevel.active:
        return 'onboardingActivityActive';
      case ActivityLevel.extra:
        return 'onboardingActivityExtra';
    }
  }

  static ActivityLevel fromId(String id) {
    return ActivityLevel.values.firstWhere(
      (e) => e.id == id,
      orElse: () => ActivityLevel.sedentary,
    );
  }
}
