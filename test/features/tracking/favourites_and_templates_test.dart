import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/favourite_food.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/tracking/favourites_repository.dart';
import 'package:nutrivoya/features/tracking/meal_template_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = LocalPreferences(await SharedPreferences.getInstance());
  });

  group('FavouritesRepository', () {
    test('toggle add and remove', () async {
      final repo = FavouritesRepository(prefs);
      const food = FavouriteFood(foodId: 'roti', foodName: 'Roti');
      expect(repo.isFavourite('roti'), isFalse);
      await repo.toggle(food);
      expect(repo.isFavourite('roti'), isTrue);
      expect(repo.list().single.foodName, 'Roti');
      await repo.toggle(food);
      expect(repo.isFavourite('roti'), isFalse);
    });
  });

  group('MealTemplateRepository', () {
    test('save apply round-trip from diary entries', () async {
      final repo = MealTemplateRepository(prefs);
      final template = MealTemplateRepository.fromDiaryEntries(
        id: 'tpl1',
        name: 'Usual breakfast',
        entries: [
          DiaryEntry(
            foodId: 'roti',
            foodName: 'Roti',
            foodCanonicalName: 'Whole wheat flatbread',
            mealType: MealType.breakfast,
            grams: 40,
            caloriesKcal: 120,
            proteinG: 4,
            confidence: NutritionConfidence.medium,
            loggedAt: DateTime(2024, 6, 1, 8),
          ),
          DiaryEntry(
            foodId: 'dal',
            foodName: 'Dal',
            foodCanonicalName: 'Lentil dal',
            mealType: MealType.breakfast,
            grams: 200,
            caloriesKcal: 180,
            proteinG: 12,
            confidence: NutritionConfidence.medium,
            loggedAt: DateTime(2024, 6, 1, 8, 5),
          ),
        ],
      );
      await repo.save(template);
      final loaded = repo.getById('tpl1');
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Usual breakfast');
      expect(loaded.itemCount, 2);
      expect(loaded.totalKcal, 300);
      await repo.delete('tpl1');
      expect(repo.list(), isEmpty);
    });
  });
}
