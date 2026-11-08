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
    this.countries = const <String>[],
    this.culturalContexts = const <String>[],
    this.preparationMethod,
    this.ingredients = const <String>[],
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

  /// Additional ISO country codes where the food is commonly eaten — foods
  /// cross borders, so one `countryCode` is not enough.
  final List<String> countries;

  /// Cultural/meal contexts (e.g. "everyday staple", "festive", "street food").
  /// Descriptive only — never a health judgement.
  final List<String> culturalContexts;

  /// Preparation method (e.g. "boiled", "fried", "baked"), which materially
  /// changes nutrition.
  final String? preparationMethod;

  /// Main ingredients for composite dishes, for transparency.
  final List<String> ingredients;

  /// All countries associated with the food.
  Set<String> get allCountries => {?countryCode, ...countries};

  /// Convenience: confidence from the source record.
  NutritionConfidence get confidence => source.confidence;

  /// All searchable names (canonical + multilingual names).
  List<String> get allDisplayNames => [
        canonicalName,
        ...names.map((n) => n.name),
      ];

  /// Primary display name: the first primary name, else canonical.
  /// Name to show for a UI [languageCode]: a primary/translation name in that
  /// language when available, otherwise [displayName].
  String nameFor(String languageCode) {
    for (final type in const [NameType.primary, NameType.translation]) {
      for (final n in names) {
        if (n.nameType == type && n.languageCode == languageCode) return n.name;
      }
    }
    return displayName;
  }

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
    List<String>? countries,
    List<String>? culturalContexts,
    String? preparationMethod,
    List<String>? ingredients,
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
      createdAt: createdAt,
      updatedAt: updatedAt,
      countries: countries ?? this.countries,
      culturalContexts: culturalContexts ?? this.culturalContexts,
      preparationMethod: preparationMethod ?? this.preparationMethod,
      ingredients: ingredients ?? this.ingredients,
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
          source == other.source &&
          listEquals(countries, other.countries) &&
          listEquals(culturalContexts, other.culturalContexts) &&
          preparationMethod == other.preparationMethod &&
          listEquals(ingredients, other.ingredients);

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
        Object.hashAll(countries),
        Object.hashAll(culturalContexts),
        preparationMethod,
        Object.hashAll(ingredients),
      );
}
