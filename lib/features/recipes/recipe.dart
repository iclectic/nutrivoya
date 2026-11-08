import 'package:flutter/foundation.dart';

import '../../core/models/food.dart';
import '../../core/models/food_name.dart';
import '../../core/models/food_portion.dart';
import '../../core/models/food_source.dart';
import '../../core/models/nutrient.dart';
import '../../core/models/nutrition_confidence.dart';
import '../../core/utils/confidence_scorer.dart';
import '../../core/utils/recipe_nutrition_calculator.dart';

/// An ingredient line with a snapshot of its per-100 g nutrition, so personal
/// recipes stay calculable offline even if the source food changes.
@immutable
class RecipeIngredientLine {
  const RecipeIngredientLine({
    required this.foodId,
    required this.name,
    required this.grams,
    required this.nutrientsPer100g,
  });

  factory RecipeIngredientLine.fromFood(Food food, double grams) =>
      RecipeIngredientLine(
        foodId: food.id,
        name: food.canonicalName,
        grams: grams,
        nutrientsPer100g: {
          for (final e in food.nutrientsPer100g.entries)
            e.key: e.value.amountPer100g,
        },
      );

  factory RecipeIngredientLine.fromJson(Map<String, dynamic> json) =>
      RecipeIngredientLine(
        foodId: json['foodId'] as String,
        name: json['name'] as String,
        grams: (json['grams'] as num).toDouble(),
        nutrientsPer100g: {
          for (final e in (json['nutrients'] as Map<String, dynamic>).entries)
            if (NutrientCode.values.any((c) => c.name == e.key))
              NutrientCode.values.byName(e.key): (e.value as num?)?.toDouble(),
        },
      );

  final String foodId;
  final String name;
  final double grams;
  final Map<NutrientCode, double?> nutrientsPer100g;

  RecipeIngredientLine copyWith({double? grams}) => RecipeIngredientLine(
        foodId: foodId,
        name: name,
        grams: grams ?? this.grams,
        nutrientsPer100g: nutrientsPer100g,
      );

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'name': name,
        'grams': grams,
        'nutrients': {
          for (final e in nutrientsPer100g.entries) e.key.name: e.value,
        },
      };

  RecipeIngredient toCalculatorInput() => RecipeIngredient(
        Food(
          id: foodId,
          canonicalName: name,
          foodType: FoodType.single,
          names: const [],
          portions: const [],
          nutrientsPer100g: {
            for (final e in nutrientsPer100g.entries)
              e.key: NutrientAmount(code: e.key, amountPer100g: e.value),
          },
          source: const FoodSource(
            type: FoodSourceType.userSubmitted,
            name: 'Recipe ingredient snapshot',
            confidence: NutritionConfidence.medium,
          ),
        ),
        grams,
      );
}

/// A personal recipe: ingredients + yield + servings → calculated nutrition.
@immutable
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    this.servings = 1,
    this.cookedYieldGrams,
    this.cuisine,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        name: json['name'] as String,
        servings: (json['servings'] as num?)?.toInt() ?? 1,
        cookedYieldGrams: (json['cookedYieldGrams'] as num?)?.toDouble(),
        cuisine: json['cuisine'] as String?,
        ingredients: [
          for (final i in (json['ingredients'] as List))
            RecipeIngredientLine.fromJson(i as Map<String, dynamic>),
        ],
      );

  static const idPrefix = 'recipe:';

  final String id;
  final String name;
  final List<RecipeIngredientLine> ingredients;
  final int servings;
  final double? cookedYieldGrams;
  final String? cuisine;

  String get foodId => '$idPrefix$id';

  double get rawWeightGrams => ingredients.fold(0, (s, i) => s + i.grams);
  double get yieldGrams => cookedYieldGrams ?? rawWeightGrams;
  double get servingGrams => servings > 0 ? yieldGrams / servings : yieldGrams;

  Map<NutrientCode, NutrientAmount> get nutrientsPer100g =>
      RecipeNutritionCalculator.per100g(
        [for (final i in ingredients) i.toCalculatorInput()],
        cookedYieldGrams: yieldGrams,
      );

  /// Nutrient amount in one serving, or null when unavailable.
  double? perServing(NutrientCode code) {
    final per100 = nutrientsPer100g[code]?.amountPer100g;
    return per100 == null ? null : per100 * servingGrams / 100;
  }

  /// Exposes the recipe as a loggable [Food].
  Food toFood() {
    final nutrients = nutrientsPer100g;
    return Food(
      id: foodId,
      canonicalName: name,
      foodType: FoodType.composite,
      cuisine: cuisine,
      defaultServingGrams: servingGrams,
      names: [FoodName(name: name, languageCode: 'und', nameType: NameType.primary)],
      portions: [FoodPortion(name: '1 serving', grams: servingGrams)],
      nutrientsPer100g: nutrients,
      ingredients: [for (final i in ingredients) '${i.name} ${i.grams.round()} g'],
      source: FoodSource(
        type: FoodSourceType.recipeEstimated,
        name: 'My recipe',
        reference: '$servings servings, yield ${yieldGrams.round()} g',
        reviewStatus: ReviewStatus.unverified,
        confidence: ConfidenceScorer.score(
          type: FoodSourceType.recipeEstimated,
          review: ReviewStatus.unverified,
          nutrients: nutrients,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'servings': servings,
        'cookedYieldGrams': cookedYieldGrams,
        'cuisine': cuisine,
        'ingredients': [for (final i in ingredients) i.toJson()],
      };
}
