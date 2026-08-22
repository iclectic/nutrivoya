import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/food_portion.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/core/utils/nutrition_calculator.dart';

Food _food() => Food(
      id: 'test',
      canonicalName: 'Test food',
      foodType: FoodType.single,
      defaultServingGrams: 50,
      portions: const [
        FoodPortion(name: '1 small', grams: 25, sizeClass: PortionSizeClass.small),
        FoodPortion(name: '1 medium', grams: 50, sizeClass: PortionSizeClass.medium),
      ],
      nutrientsPer100g: const {
        NutrientCode.energyKcal: NutrientAmount(code: NutrientCode.energyKcal, amountPer100g: 200),
        NutrientCode.proteinG: NutrientAmount(code: NutrientCode.proteinG, amountPer100g: 10),
        NutrientCode.fatG: NutrientAmount(code: NutrientCode.fatG, amountPer100g: null),
      },
      source: const FoodSource(
        type: FoodSourceType.authoritative,
        name: 'Test',
        confidence: NutritionConfidence.high,
      ),
    );

void main() {
  group('NutritionCalculator.scale', () {
    test('scales per-100g to given grams', () {
      expect(NutritionCalculator.scale(200, 50), 100);
      expect(NutritionCalculator.scale(200, 100), 200);
      expect(NutritionCalculator.scale(200, 200), 400);
    });

    test('returns null for null input', () {
      expect(NutritionCalculator.scale(null, 100), isNull);
    });
  });

  group('NutritionCalculator.forGrams', () {
    test('scales all nutrients to the given grams', () {
      final scaled = NutritionCalculator.forGrams(_food(), 50);
      expect(scaled[NutrientCode.energyKcal]?.amountPer100g, 100);
      expect(scaled[NutrientCode.proteinG]?.amountPer100g, 5);
    });

    test('keeps unknown nutrients null', () {
      final scaled = NutritionCalculator.forGrams(_food(), 50);
      expect(scaled[NutrientCode.fatG]?.amountPer100g, isNull);
    });
  });

  group('NutritionCalculator.portionToGrams', () {
    test('uses portion grams × quantity', () {
      final food = _food();
      expect(
        NutritionCalculator.portionToGrams(
            food, food.portions.first, 2),
        50,
      );
    });

    test('falls back to default serving when portion is null', () {
      expect(NutritionCalculator.portionToGrams(_food(), null, 1), 50);
    });

    test('falls back to 100g when no portion or default', () {
      final food = Food(
        id: 'test',
        canonicalName: 'Test food',
        foodType: FoodType.single,
        portions: const [],
        nutrientsPer100g: const {},
        source: const FoodSource(
          type: FoodSourceType.authoritative,
          name: 'Test',
          confidence: NutritionConfidence.high,
        ),
      );
      expect(NutritionCalculator.portionToGrams(food, null, 1), 100);
    });
  });

  group('NutritionCalculator rounding', () {
    test('roundKcal rounds to nearest whole', () {
      expect(NutritionCalculator.roundKcal(123.6), 124);
      expect(NutritionCalculator.roundKcal(null), 0);
    });

    test('roundMacro rounds to one decimal', () {
      expect(NutritionCalculator.roundMacro(12.34), 12.3);
      expect(NutritionCalculator.roundMacro(null), 0);
    });
  });
}
