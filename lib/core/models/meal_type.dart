/// Meal classification for diary entries.
enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks,
}

extension MealTypeX on MealType {
  String get id => name;

  String get l10nKey {
    switch (this) {
      case MealType.breakfast:
        return 'diaryMealBreakfast';
      case MealType.lunch:
        return 'diaryMealLunch';
      case MealType.dinner:
        return 'diaryMealDinner';
      case MealType.snacks:
        return 'diaryMealSnacks';
    }
  }

  /// Default ordering for display.
  static List<MealType> get displayOrder => mealTypeDisplayOrder;

  static MealType fromId(String id) {
    return MealType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => MealType.snacks,
    );
  }
}

/// Default display ordering of meal types.
const List<MealType> mealTypeDisplayOrder = [
  MealType.breakfast,
  MealType.lunch,
  MealType.dinner,
  MealType.snacks,
];
