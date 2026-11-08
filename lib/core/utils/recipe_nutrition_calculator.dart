import '../models/food.dart';
import '../models/nutrient.dart';

/// One ingredient line in a recipe.
class RecipeIngredient {
  const RecipeIngredient(this.food, this.grams);
  final Food food;
  final double grams;
}

/// Reproducible recipe nutrition: sums ingredient nutrients and divides by the
/// cooked yield. A nutrient is only reported when every ingredient has a known
/// value for it — missing data is never filled in.
class RecipeNutritionCalculator {
  const RecipeNutritionCalculator._();

  static double rawWeight(List<RecipeIngredient> ingredients) =>
      ingredients.fold(0, (sum, i) => sum + i.grams);

  /// Total amount of [code] in the whole recipe, or `null` if any ingredient
  /// lacks it.
  static double? total(List<RecipeIngredient> ingredients, NutrientCode code) {
    if (ingredients.isEmpty) return null;
    var sum = 0.0;
    for (final i in ingredients) {
      final per100 = i.food.nutrientPer100g(code);
      if (per100 == null) return null;
      sum += per100 * i.grams / 100;
    }
    return sum;
  }

  /// Nutrients per 100 g of the finished dish. [cookedYieldGrams] accounts for
  /// water gained/lost in cooking; defaults to the raw ingredient weight.
  static Map<NutrientCode, NutrientAmount> per100g(
    List<RecipeIngredient> ingredients, {
    double? cookedYieldGrams,
  }) {
    final yieldG = cookedYieldGrams ?? rawWeight(ingredients);
    final result = <NutrientCode, NutrientAmount>{};
    if (yieldG <= 0) return result;
    for (final code in NutrientCode.values) {
      final known = ingredients.any((i) => i.food.nutrientsPer100g.containsKey(code));
      if (!known) continue;
      final t = total(ingredients, code);
      result[code] = NutrientAmount(
        code: code,
        amountPer100g: t == null ? null : t / yieldG * 100,
      );
    }
    return result;
  }
}
