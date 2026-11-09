import '../models/nutrient.dart';
import '../models/nutrition_confidence.dart';
import '../models/recipe.dart';
import '../models/recipe_ingredient.dart';

/// Calculates recipe nutrition from structured ingredient quantities.
///
/// Flow: ingredients → quantities → total nutrients → yield grams →
/// nutrients per 100 g → per serving. Never invents values; missing
/// ingredient nutrients stay null in the aggregate when no ingredient
/// contributed a known amount for that nutrient.
class RecipeNutritionService {
  const RecipeNutritionService();

  /// Build a completed [Recipe] from draft fields.
  Recipe build({
    required String id,
    required String name,
    required List<RecipeIngredient> ingredients,
    required int servings,
    double? totalWeightGrams,
    String? notes,
    String? cuisine,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final safeServings = servings <= 0 ? 1 : servings;
    final yieldGrams = totalWeightGrams ??
        ingredients.fold<double>(0, (sum, i) => sum + i.grams);
    final safeYield = yieldGrams <= 0 ? 1.0 : yieldGrams;

    final totals = _sumIngredients(ingredients);
    final per100 = <NutrientCode, double?>{
      for (final code in NutrientCode.values)
        code: totals.containsKey(code) && totals[code] != null
            ? (totals[code]! / safeYield) * 100.0
            : null,
    };

    // Round display-facing macros to avoid fake precision.
    for (final code in [
      NutrientCode.energyKcal,
      NutrientCode.proteinG,
      NutrientCode.carbohydrateG,
      NutrientCode.fatG,
      NutrientCode.fibreG,
    ]) {
      final v = per100[code];
      if (v != null) {
        per100[code] = code == NutrientCode.energyKcal
            ? v.roundToDouble()
            : ((v * 10).roundToDouble() / 10);
      }
    }

    final now = DateTime.now().toUtc();
    return Recipe(
      id: id,
      name: name.trim().isEmpty ? 'Untitled recipe' : name.trim(),
      ingredients: List.unmodifiable(ingredients),
      servings: safeServings,
      totalWeightGrams: safeYield,
      nutrientsPer100g: Map.unmodifiable(per100),
      notes: notes,
      cuisine: cuisine,
      confidence: NutritionConfidence.medium,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  /// Whole-recipe nutrient totals (absolute amounts, not per 100 g).
  Map<NutrientCode, double?> totalNutrients(List<RecipeIngredient> ingredients) {
    return _sumIngredients(ingredients);
  }

  Map<NutrientCode, double?> _sumIngredients(
    List<RecipeIngredient> ingredients,
  ) {
    final sums = <NutrientCode, double?>{};
    final seen = <NutrientCode>{};

    for (final ingredient in ingredients) {
      final scaled = ingredient.nutrientsForGrams();
      for (final entry in scaled.entries) {
        seen.add(entry.key);
        if (entry.value == null) continue;
        sums[entry.key] = (sums[entry.key] ?? 0) + entry.value!;
      }
    }

    // Nutrients never contributed stay absent/null rather than 0.
    return {
      for (final code in seen) code: sums[code],
    };
  }
}
