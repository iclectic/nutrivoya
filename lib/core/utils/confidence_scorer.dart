import '../models/food.dart';
import '../models/food_source.dart';
import '../models/nutrient.dart';
import '../models/nutrition_confidence.dart';

/// Derives a nutrition-confidence level from provenance, review status and
/// data completeness, so confidence is earned rather than asserted.
class ConfidenceScorer {
  const ConfidenceScorer._();

  static const coreNutrients = [
    NutrientCode.energyKcal,
    NutrientCode.proteinG,
    NutrientCode.carbohydrateG,
    NutrientCode.fatG,
    NutrientCode.fibreG,
  ];

  /// Fraction of core nutrients with a known value (0–1).
  static double completeness(Map<NutrientCode, NutrientAmount> nutrients) {
    final known =
        coreNutrients.where((c) => nutrients[c]?.amountPer100g != null).length;
    return known / coreNutrients.length;
  }

  static NutritionConfidence score({
    required FoodSourceType type,
    required ReviewStatus review,
    required Map<NutrientCode, NutrientAmount> nutrients,
  }) {
    if (nutrients[NutrientCode.energyKcal]?.amountPer100g == null) {
      return NutritionConfidence.unknown;
    }
    final complete = completeness(nutrients) >= 0.8;
    switch (type) {
      case FoodSourceType.authoritative:
        return review == ReviewStatus.verified && complete
            ? NutritionConfidence.high
            : NutritionConfidence.medium;
      case FoodSourceType.packaged:
        if (review == ReviewStatus.verified && complete) {
          return NutritionConfidence.high;
        }
        return complete ? NutritionConfidence.medium : NutritionConfidence.estimated;
      case FoodSourceType.nutrivoyaCurated:
      case FoodSourceType.recipeEstimated:
        return complete ? NutritionConfidence.medium : NutritionConfidence.estimated;
      case FoodSourceType.userSubmitted:
        return NutritionConfidence.estimated;
    }
  }

  static NutritionConfidence forFood(Food food) => score(
        type: food.source.type,
        review: food.source.reviewStatus,
        nutrients: food.nutrientsPer100g,
      );
}
