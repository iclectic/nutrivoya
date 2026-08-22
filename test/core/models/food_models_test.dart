import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/food_name.dart';
import 'package:nutrivoya/core/models/food_portion.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';

void main() {
  group('NutrientCode', () {
    test('each nutrient has a unit', () {
      for (final c in NutrientCode.values) {
        expect(c.unit, isNotEmpty);
      }
    });

    test('energy unit is kcal', () {
      expect(NutrientCode.energyKcal.unit, 'kcal');
    });

    test('protein/carb/fat/fibre units are g', () {
      expect(NutrientCode.proteinG.unit, 'g');
      expect(NutrientCode.carbohydrateG.unit, 'g');
      expect(NutrientCode.fatG.unit, 'g');
      expect(NutrientCode.fibreG.unit, 'g');
    });
  });

  group('NutrientAmount', () {
    test('effectiveUnit falls back to code unit', () {
      const a = NutrientAmount(code: NutrientCode.energyKcal, amountPer100g: 100);
      expect(a.effectiveUnit, 'kcal');
    });

    test('copyWith preserves code and updates amount', () {
      const a = NutrientAmount(code: NutrientCode.proteinG, amountPer100g: 10);
      final b = a.copyWith(amountPer100g: 20);
      expect(b.code, NutrientCode.proteinG);
      expect(b.amountPer100g, 20);
    });

    test('amountPer100g can be null for unknown nutrients', () {
      const a = NutrientAmount(code: NutrientCode.zincMg, amountPer100g: null);
      expect(a.amountPer100g, isNull);
    });
  });

  group('NutritionConfidence', () {
    test('id round-trips', () {
      for (final c in NutritionConfidence.values) {
        expect(NutritionConfidenceX.fromId(c.id), c);
      }
    });

    test('unknown id falls back to unknown', () {
      expect(NutritionConfidenceX.fromId('x'),
          NutritionConfidence.unknown);
    });
  });

  group('FoodName.normalize', () {
    test('lowercases and collapses whitespace', () {
      expect(FoodName.normalize('  Jollof   Rice '), 'jollof rice');
    });

    test('folds common diacritics', () {
      expect(FoodName.normalize('café'), 'cafe');
      expect(FoodName.normalize('Crème brûlée'), 'creme brulee');
    });

    test('empty query normalizes to empty', () {
      expect(FoodName.normalize('   '), '');
    });
  });

  group('FoodPortion', () {
    test('stores grams and size class', () {
      const p = FoodPortion(
        name: '1 medium roti',
        grams: 40,
        sizeClass: PortionSizeClass.medium,
        region: 'South Asia',
      );
      expect(p.grams, 40);
      expect(p.sizeClass, PortionSizeClass.medium);
    });
  });

  group('Food', () {
    final food = Food(
      id: 'roti',
      canonicalName: 'Whole wheat flatbread',
      foodType: FoodType.composite,
      cuisine: 'Punjabi',
      defaultServingGrams: 40,
      names: [
        FoodName(name: 'Roti', nameType: NameType.primary),
        FoodName(name: 'chapati', nameType: NameType.alias),
      ],
      portions: const [FoodPortion(name: '1 medium roti', grams: 40)],
      nutrientsPer100g: const {
        NutrientCode.energyKcal: NutrientAmount(code: NutrientCode.energyKcal, amountPer100g: 297),
        NutrientCode.proteinG: NutrientAmount(code: NutrientCode.proteinG, amountPer100g: 9),
      },
      source: const FoodSource(
        type: FoodSourceType.nutrivoyaCurated,
        name: 'Nutrivoya curated',
        confidence: NutritionConfidence.medium,
      ),
    );

    test('displayName is the primary name', () {
      expect(food.displayName, 'Roti');
    });

    test('nutrientPer100g returns amount or null', () {
      expect(food.nutrientPer100g(NutrientCode.energyKcal), 297);
      expect(food.nutrientPer100g(NutrientCode.fatG), isNull);
    });

    test('confidence comes from source', () {
      expect(food.confidence, NutritionConfidence.medium);
    });

    test('allDisplayNames includes canonical and aliases', () {
      expect(food.allDisplayNames, contains('Whole wheat flatbread'));
      expect(food.allDisplayNames, contains('Roti'));
      expect(food.allDisplayNames, contains('chapati'));
    });
  });
}
