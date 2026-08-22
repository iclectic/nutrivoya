import 'package:flutter/foundation.dart';

import 'food_name.dart';
import 'food_portion.dart';
import 'food_source.dart';
import 'nutrient.dart';
import 'nutrition_confidence.dart';

/// Whether a food is a single ingredient or a composite dish/recipe.
enum FoodType { single, composite }

extension FoodTypeX on FoodType {
  String get id => name;
}

/// A canonical food record — the heart of Nutrivoya.
///
/// Nutrition is stored per 100 g edible portion. Portions map culturally
/// meaningful servings to grams. Names carry the multilingual alias ontology.
/// `source` carries full provenance and confidence.
@immutable
class Food {
  const Food({
    required this.id,
    required this.canonicalName,
    required this.foodType,
    required this.nutrientsPer100g,
    required this.source,
    this.countryCode,
    this.region,
    this.cuisine,
    this.defaultServingGrams,
    this.names = const <FoodName>[],
    this.portions = const <FoodPortion>[],
    this.createdAt,
    this.updatedAt,
  });

  final String id;

  /// Canonical English/reference name (e.g. "Whole wheat flatbread").
  final String canonicalName;

  final FoodType foodType;

  /// ISO country code, optional.
  final String? countryCode;

  /// Region (e.g. "Punjab", "West Africa").
  final String? region;

  /// Cuisine (e.g. "Punjabi", "Nigerian").
  final String? cuisine;

  /// Default serving in grams when no portion is selected.
  final double? defaultServingGrams;

  /// All names (primary, translations, aliases, transliterations).
  final List<FoodName> names;

  /// Culturally meaningful portions.
  final List<FoodPortion> portions;

  /// Nutrient amounts per 100 g edible portion.
  final Map<NutrientCode, NutrientAmount> nutrientsPer100g;

  /// Provenance + confidence.
  final FoodSource source;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Convenience: confidence from the source record.
  NutritionConfidence get confidence => source.confidence;

  /// All searchable names (canonical + multilingual names).
  List<String> get allDisplayNames => [
        canonicalName,
        ...names.map((n) => n.name),
      ];

  /// Primary display name: the first primary name, else canonical.
  String get displayName =>
      names.firstWhere(
        (n) => n.nameType == NameType.primary,
        orElse: () => names.isNotEmpty
            ? names.first
            : FoodName(name: canonicalName),
      ).name;

  /// Amount for a nutrient per 100 g, or `null` if unknown.
  double? nutrientPer100g(NutrientCode code) =>
      nutrientsPer100g[code]?.amountPer100g;

  Food copyWith({
    String? id,
    String? canonicalName,
    FoodType? foodType,
    String? countryCode,
    String? region,
    String? cuisine,
    double? defaultServingGrams,
    List<FoodName>? names,
    List<FoodPortion>? portions,
    Map<NutrientCode, NutrientAmount>? nutrientsPer100g,
    FoodSource? source,
  }) {
    return Food(
      id: id ?? this.id,
      canonicalName: canonicalName ?? this.canonicalName,
      foodType: foodType ?? this.foodType,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      cuisine: cuisine ?? this.cuisine,
      defaultServingGrams: defaultServingGrams ?? this.defaultServingGrams,
      names: names ?? this.names,
      portions: portions ?? this.portions,
      nutrientsPer100g: nutrientsPer100g ?? this.nutrientsPer100g,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Food &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          canonicalName == other.canonicalName &&
          foodType == other.foodType &&
          countryCode == other.countryCode &&
          region == other.region &&
          cuisine == other.cuisine &&
          defaultServingGrams == other.defaultServingGrams &&
          listEquals(names, other.names) &&
          listEquals(portions, other.portions) &&
          mapEquals(nutrientsPer100g, other.nutrientsPer100g) &&
          source == other.source;

  @override
  int get hashCode => Object.hash(
        id,
        canonicalName,
        foodType,
        countryCode,
        region,
        cuisine,
        defaultServingGrams,
        Object.hashAll(names),
        Object.hashAll(portions),
        Object.hashAll(nutrientsPer100g.values),
        source,
      );
}
