import '../models/food.dart';
import '../models/food_portion.dart';
import '../models/nutrient.dart';

/// Calculates nutrition for a given grams amount from per-100g data.
///
/// All food nutrient data is stored per 100 g edible portion; this helper
/// scales it to the actual consumed grams. It never fabricates missing
/// values — unknown nutrients stay `null`.
class NutritionCalculator {
  const NutritionCalculator._();

  /// Scale a per-100g amount to [grams].
  static double? scale(double? amountPer100g, double grams) {
    if (amountPer100g == null) return null;
    return (amountPer100g / 100) * grams;
  }

  /// Compute all nutrients for [grams] of [food].
  static Map<NutrientCode, NutrientAmount> forGrams(Food food, double grams) {
    return {
      for (final entry in food.nutrientsPer100g.entries)
        entry.key: NutrientAmount(
          code: entry.key,
          amountPer100g: scale(entry.value.amountPer100g, grams),
          unit: entry.value.effectiveUnit,
        ),
    };
  }

  /// Resolve a portion to grams. Falls back to [Food.defaultServingGrams]
  /// then to 100 g.
  static double portionToGrams(Food food, FoodPortion? portion, double quantity) {
    final base = portion?.grams ?? food.defaultServingGrams ?? 100;
    return base * quantity;
  }

  /// Round to a sensible display precision. Nutrivoya avoids fake precision:
  /// calories round to the nearest whole; macros to one decimal.
  static int roundKcal(double? kcal) {
    if (kcal == null) return 0;
    return kcal.round();
  }

  static double roundMacro(double? grams) {
    if (grams == null) return 0;
    return (grams * 10).roundToDouble() / 10;
  }
}
