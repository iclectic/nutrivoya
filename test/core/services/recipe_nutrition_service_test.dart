import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/recipe_ingredient.dart';
import 'package:nutrivoya/core/services/recipe_nutrition_service.dart';

void main() {
  const service = RecipeNutritionService();

  group('RecipeNutritionService', () {
    test('calculates per-serving nutrition from ingredients', () {
      final recipe = service.build(
        id: 'r1',
        name: "Mum's Chicken Curry",
        servings: 8,
        ingredients: const [
          RecipeIngredient(
            foodId: 'chicken',
            foodName: 'Chicken',
            grams: 800,
            nutrientsPer100g: {
              NutrientCode.energyKcal: 165,
              NutrientCode.proteinG: 31,
              NutrientCode.carbohydrateG: 0,
              NutrientCode.fatG: 3.6,
              NutrientCode.fibreG: 0,
            },
          ),
          RecipeIngredient(
            foodId: 'oil',
            foodName: 'Oil',
            grams: 30,
            nutrientsPer100g: {
              NutrientCode.energyKcal: 884,
              NutrientCode.proteinG: 0,
              NutrientCode.carbohydrateG: 0,
              NutrientCode.fatG: 100,
              NutrientCode.fibreG: 0,
            },
          ),
        ],
      );

      expect(recipe.name, "Mum's Chicken Curry");
      expect(recipe.servings, 8);
      expect(recipe.totalWeightGrams, 830);
      expect(recipe.caloriesPerServing, isNotNull);
      expect(recipe.caloriesPerServing!, greaterThan(100));
      expect(recipe.caloriesPerServing!, lessThan(400));

      // Whole recipe energy ≈ 800*1.65 + 30*8.84 = 1320 + 265.2 = 1585.2
      final wholeKcal =
          (recipe.nutrientsPer100g[NutrientCode.energyKcal]! / 100) *
              recipe.totalWeightGrams;
      expect(wholeKcal, closeTo(1585, 5));
    });

    test('does not invent micronutrients that ingredients lack', () {
      final recipe = service.build(
        id: 'r2',
        name: 'Simple',
        servings: 1,
        ingredients: const [
          RecipeIngredient(
            foodId: 'rice',
            foodName: 'Rice',
            grams: 100,
            nutrientsPer100g: {
              NutrientCode.energyKcal: 130,
              NutrientCode.proteinG: 2.7,
            },
          ),
        ],
      );
      expect(recipe.nutrientsPer100g[NutrientCode.ironMg], isNull);
      expect(recipe.nutrientsPer100g[NutrientCode.energyKcal], isNotNull);
    });

    test('custom yield changes density', () {
      final ingredients = const [
        RecipeIngredient(
          foodId: 'a',
          foodName: 'A',
          grams: 200,
          nutrientsPer100g: {NutrientCode.energyKcal: 100},
        ),
      ];
      final raw = service.build(
        id: 'r3',
        name: 'Raw',
        servings: 2,
        ingredients: ingredients,
      );
      final cooked = service.build(
        id: 'r4',
        name: 'Cooked down',
        servings: 2,
        totalWeightGrams: 150,
        ingredients: ingredients,
      );
      expect(
        cooked.nutrientsPer100g[NutrientCode.energyKcal]!,
        greaterThan(raw.nutrientsPer100g[NutrientCode.energyKcal]!),
      );
    });
  });
}
