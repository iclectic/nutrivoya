import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/food_name.dart';
import 'package:nutrivoya/core/models/food_portion.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';

Food _testFood() => Food(
      id: 'roti-whole-wheat',
      canonicalName: 'Whole wheat flatbread',
      foodType: FoodType.composite,
      defaultServingGrams: 40,
      names: [
        FoodName(name: 'Roti', nameType: NameType.primary),
        FoodName(name: 'chapati', nameType: NameType.alias),
      ],
      portions: const [
        FoodPortion(name: '1 medium roti', grams: 40, sizeClass: PortionSizeClass.medium),
      ],
      nutrientsPer100g: const {
        NutrientCode.energyKcal: NutrientAmount(code: NutrientCode.energyKcal, amountPer100g: 297),
        NutrientCode.proteinG: NutrientAmount(code: NutrientCode.proteinG, amountPer100g: 9),
        NutrientCode.carbohydrateG: NutrientAmount(code: NutrientCode.carbohydrateG, amountPer100g: 55),
        NutrientCode.fatG: NutrientAmount(code: NutrientCode.fatG, amountPer100g: 3),
        NutrientCode.fibreG: NutrientAmount(code: NutrientCode.fibreG, amountPer100g: 4),
      },
      source: const FoodSource(
        type: FoodSourceType.nutrivoyaCurated,
        name: 'Nutrivoya curated',
        confidence: NutritionConfidence.medium,
      ),
    );

void main() {
  group('DiaryEntry.fromFood', () {
    test('computes macros from food per-100g and grams', () {
      final entry = DiaryEntry.fromFood(
        food: _testFood(),
        mealType: MealType.breakfast,
        grams: 80, // 2 rotis
      );
      // 80g = 0.8 × 100g
      expect(entry.caloriesKcal, closeTo(237.6, 0.1));
      expect(entry.proteinG, closeTo(7.2, 0.1));
      expect(entry.carbohydrateG, closeTo(44, 0.1));
      expect(entry.fatG, closeTo(2.4, 0.1));
      expect(entry.fibreG, closeTo(3.2, 0.1));
    });

    test('stores food snapshot', () {
      final entry = DiaryEntry.fromFood(
        food: _testFood(),
        mealType: MealType.lunch,
        grams: 40,
        portion: const FoodPortion(name: '1 medium roti', grams: 40),
        quantity: 2,
      );
      expect(entry.foodId, 'roti-whole-wheat');
      expect(entry.foodName, 'Roti');
      expect(entry.foodCanonicalName, 'Whole wheat flatbread');
      expect(entry.mealType, MealType.lunch);
      expect(entry.grams, 40);
      expect(entry.portionName, '1 medium roti');
      expect(entry.quantity, 2);
      expect(entry.confidence, NutritionConfidence.medium);
      expect(entry.sourceName, 'Nutrivoya curated');
    });

    test('scales iron when present and leaves other micros null', () {
      final food = _testFood().copyWith(
        nutrientsPer100g: {
          ..._testFood().nutrientsPer100g,
          NutrientCode.ironMg: const NutrientAmount(
            code: NutrientCode.ironMg,
            amountPer100g: 2.5,
          ),
        },
      );
      final entry = DiaryEntry.fromFood(
        food: food,
        mealType: MealType.lunch,
        grams: 100,
      );
      expect(entry.ironMg, closeTo(2.5, 0.01));
      expect(entry.calciumMg, isNull);
      expect(entry.sodiumMg, isNull);
    });

    test('DailyTotals keeps unavailable micros as null', () {
      final entry = DiaryEntry.fromFood(
        food: _testFood(),
        mealType: MealType.breakfast,
        grams: 40,
      );
      final totals = DailyTotals.fromEntries([entry]);
      expect(totals.ironMg, isNull);
      expect(totals.caloriesKcal, greaterThan(0));
    });

    test('null nutrients stay null in the entry', () {
      final food = _testFood().copyWith(
        nutrientsPer100g: {
          NutrientCode.energyKcal: const NutrientAmount(code: NutrientCode.energyKcal, amountPer100g: 200),
        },
      );
      final entry = DiaryEntry.fromFood(
        food: food,
        mealType: MealType.dinner,
        grams: 100,
      );
      expect(entry.caloriesKcal, 200);
      expect(entry.proteinG, isNull);
      expect(entry.fatG, isNull);
    });

    test('copyWith updates fields correctly', () {
      final entry = DiaryEntry.fromFood(
        food: _testFood(),
        mealType: MealType.breakfast,
        grams: 40,
      );
      final updated = entry.copyWith(
        id: 1,
        grams: 80,
        quantity: 2,
        caloriesKcal: 237.6,
      );
      expect(updated.id, 1);
      expect(updated.grams, 80);
      expect(updated.quantity, 2);
      expect(updated.caloriesKcal, 237.6);
      expect(updated.foodId, entry.foodId); // unchanged
    });
  });

  group('DailyTotals', () {
    test('fromEntries sums all entries', () {
      final entries = [
        DiaryEntry.fromFood(food: _testFood(), mealType: MealType.breakfast, grams: 40),
        DiaryEntry.fromFood(food: _testFood(), mealType: MealType.lunch, grams: 80),
      ];
      final totals = DailyTotals.fromEntries(entries);
      // 40g = 118.8 kcal, 80g = 237.6 kcal → total ≈ 356.4
      expect(totals.caloriesKcal, closeTo(356.4, 0.1));
      expect(totals.proteinG, closeTo(10.8, 0.1));
      expect(totals.entryCount, 2);
    });

    test('empty entries give zero totals', () {
      final totals = DailyTotals.fromEntries([]);
      expect(totals.caloriesKcal, 0);
      expect(totals.entryCount, 0);
    });

    test('caloriesRounded rounds to nearest whole', () {
      final totals = DailyTotals(caloriesKcal: 356.4);
      expect(totals.caloriesRounded, 356);
    });

    test('operator + combines totals', () {
      final a = DailyTotals(caloriesKcal: 100, proteinG: 10, entryCount: 1);
      final b = DailyTotals(caloriesKcal: 200, proteinG: 20, entryCount: 2);
      final combined = a + b;
      expect(combined.caloriesKcal, 300);
      expect(combined.proteinG, 30);
      expect(combined.entryCount, 3);
    });

    test('null macros are treated as 0', () {
      final entry = DiaryEntry(
        foodId: 'test',
        foodName: 'Test',
        foodCanonicalName: 'Test',
        mealType: MealType.snacks,
        grams: 100,
        caloriesKcal: null,
        proteinG: null,
        loggedAt: DateTime.now(),
      );
      final totals = DailyTotals.fromEntry(entry);
      expect(totals.caloriesKcal, 0);
      expect(totals.proteinG, 0);
      expect(totals.entryCount, 1);
    });
  });
}
