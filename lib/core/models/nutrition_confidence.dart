/// Confidence level for a food's nutrition estimate.
///
/// Nutrivoya never fakes precision. Every food record carries a confidence
/// value so the UI can communicate uncertainty honestly, especially for
/// traditional/home-cooked dishes whose recipes vary.
enum NutritionConfidence {
  /// Official food-composition data (e.g. USDA FoodData Central).
  high,

  /// Calculated from a standardized recipe with documented ingredients.
  medium,

  /// Based on common ingredients and portion size; recipe varies widely.
  estimated,

  /// No reliable data available.
  unknown,
}

extension NutritionConfidenceX on NutritionConfidence {
  String get id => name;

  /// Localization key for user-facing label.
  String get l10nKey {
    switch (this) {
      case NutritionConfidence.high:
        return 'confidenceHigh';
      case NutritionConfidence.medium:
        return 'confidenceMedium';
      case NutritionConfidence.estimated:
        return 'confidenceEstimated';
      case NutritionConfidence.unknown:
        return 'confidenceUnknown';
    }
  }

  static NutritionConfidence fromId(String id) {
    return NutritionConfidence.values.firstWhere(
      (e) => e.id == id,
      orElse: () => NutritionConfidence.unknown,
    );
  }
}
