import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/core/services/cultural_meal_suggestion_service.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

void main() {
  const service = CulturalMealSuggestionService();

  UserProfile profileWithCuisines(List<String> cuisines) => UserProfile(
        id: 'u1',
        ageYears: 30,
        heightCm: 170,
        weightKg: 70,
        physiologicalInput: PhysiologicalInput.female,
        activityLevel: ActivityLevel.moderate,
        goal: NutritionGoal.maintainWeight,
        familiarCuisines: cuisines,
      );

  test('returns structured foods only and prefers familiar cuisine', () {
    final suggestions = service.suggest(
      catalog: LocalFoodDataset.all(),
      profile: profileWithCuisines(['Punjabi']),
    );
    expect(suggestions, isNotEmpty);
    expect(
      suggestions.any(
        (s) =>
            (s.matchedCuisine ?? '').toLowerCase().contains('punjabi') ||
            s.reasonKey.toLowerCase().contains('familiar'),
      ),
      isTrue,
    );
    // Nutrition comes from catalog foods — never fabricated ids.
    expect(
      suggestions.every(
        (s) => LocalFoodDataset.all().any((f) => f.id == s.food.id),
      ),
      isTrue,
    );
  });

  test('skips foods already logged today', () {
    final roti = LocalFoodDataset.all().firstWhere(
      (f) => f.id.contains('roti') || f.displayName.toLowerCase().contains('roti'),
      orElse: () => LocalFoodDataset.all().first,
    );
    final suggestions = service.suggest(
      catalog: LocalFoodDataset.all(),
      todayEntries: [
        DiaryEntry(
          foodId: roti.id,
          foodName: roti.displayName,
          foodCanonicalName: roti.canonicalName,
          mealType: MealType.breakfast,
          grams: 40,
          loggedAt: DateTime(2024, 6, 1, 8),
        ),
      ],
    );
    expect(suggestions.every((s) => s.food.id != roti.id), isTrue);
  });
}
