import 'package:flutter/foundation.dart';

import 'nutrition_confidence.dart';

/// Where a food record comes from. Drives provenance and trust.
enum FoodSourceType {
  /// Authoritative food-composition dataset (USDA, FAO/INFOODS, CoFID, …).
  authoritative,

  /// Packaged-food database (e.g. Open Food Facts).
  packaged,

  /// Nutrivoya's own curated cultural-food dataset.
  nutrivoyaCurated,

  /// Estimated from a recipe (ingredient quantities + yield).
  recipeEstimated,

  /// Submitted by a user; not yet verified.
  userSubmitted,
}

extension FoodSourceTypeX on FoodSourceType {
  String get id => name;

  String get l10nKey {
    switch (this) {
      case FoodSourceType.authoritative:
        return 'sourceAuthoritative';
      case FoodSourceType.packaged:
        return 'sourcePackaged';
      case FoodSourceType.nutrivoyaCurated:
        return 'sourceNutrivoyaCurated';
      case FoodSourceType.recipeEstimated:
        return 'sourceRecipeEstimated';
      case FoodSourceType.userSubmitted:
        return 'sourceUserSubmitted';
    }
  }
}

/// Review status for a food record's nutrition data.
enum ReviewStatus { verified, pending, unverified }

extension ReviewStatusX on ReviewStatus {
  String get id => name;
}

/// Provenance record attached to every food.
///
/// Per the spec, every nutrition record internally tracks source type, source
/// name, source reference, review status, confidence and updated timestamp.
@immutable
class FoodSource {
  const FoodSource({
    required this.type,
    required this.name,
    this.reference,
    this.reviewStatus = ReviewStatus.unverified,
    this.confidence = NutritionConfidence.unknown,
    this.updatedAt,
  });

  final FoodSourceType type;

  /// Human-readable source name, e.g. "USDA FoodData Central".
  final String name;

  /// Source-specific reference (FDC ID, barcode, recipe name, …).
  final String? reference;

  final ReviewStatus reviewStatus;
  final NutritionConfidence confidence;
  final DateTime? updatedAt;

  FoodSource copyWith({
    FoodSourceType? type,
    String? name,
    String? reference,
    ReviewStatus? reviewStatus,
    NutritionConfidence? confidence,
    DateTime? updatedAt,
  }) {
    return FoodSource(
      type: type ?? this.type,
      name: name ?? this.name,
      reference: reference ?? this.reference,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      confidence: confidence ?? this.confidence,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodSource &&
          type == other.type &&
          name == other.name &&
          reference == other.reference &&
          reviewStatus == other.reviewStatus &&
          confidence == other.confidence &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      Object.hash(type, name, reference, reviewStatus, confidence, updatedAt);
}
