import 'package:flutter/foundation.dart';

import 'food.dart';
import 'food_portion.dart';

/// How a photo-assisted suggestion was produced.
///
/// Computer-vision style matches are never treated as certain. Nutrition
/// always comes from a later structured food lookup, not from the image.
enum PhotoSuggestionSource {
  /// User typed a description; results came from the food repository search.
  userDescriptionSearch,

  /// A plugged-in recognizer proposed a query that was then looked up.
  recognizerQuery,

  /// Manual pick from search with the photo as reference only.
  manualPick,
}

/// Confidence for photo-assisted matching — always below "certain".
enum PhotoMatchConfidence {
  /// Recognizer/search returned a plausible match; user must still confirm.
  uncertain,

  /// Weak / ambiguous match — strongly encourage another choice.
  low,
}

/// A candidate food for a meal photo. Calories are never attached here.
@immutable
class PhotoFoodSuggestion {
  const PhotoFoodSuggestion({
    required this.food,
    required this.source,
    required this.matchConfidence,
    this.matchedQuery,
    this.reasonKey = 'photoReasonSearchMatch',
  });

  final Food food;
  final PhotoSuggestionSource source;
  final PhotoMatchConfidence matchConfidence;

  /// Query string that produced this match (hint or recognizer token).
  final String? matchedQuery;

  /// Localization key explaining why this was suggested.
  final String reasonKey;

  bool get isCertain => false;
}

/// Estimated portion for a confirmed food — still requires user confirmation.
@immutable
class PortionEstimate {
  const PortionEstimate({
    required this.food,
    required this.grams,
    this.portion,
    this.label,
    this.isEstimate = true,
  });

  final Food food;
  final double grams;
  final FoodPortion? portion;
  final String? label;

  /// Always true for photo-assisted estimates.
  final bool isEstimate;
}
