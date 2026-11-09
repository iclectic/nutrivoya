import 'package:flutter/foundation.dart';

import 'nutrient.dart';
import 'nutrition_confidence.dart';
import 'recipe_ingredient.dart';

/// A user-created recipe with calculated nutrition.
///
/// Nutrition is derived from structured ingredient quantities — never from an
/// LLM inventing calorie values. Per-serving nutrients are stored per 100 g
/// of the prepared recipe so they can be logged like any other food.
@immutable
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.servings,
    required this.totalWeightGrams,
    required this.nutrientsPer100g,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.cuisine,
    this.confidence = NutritionConfidence.medium,
  });

  final String id;
  final String name;
  final List<RecipeIngredient> ingredients;

  /// Number of servings the whole recipe yields.
  final int servings;

  /// Estimated edible yield weight of the whole prepared recipe (grams).
  final double totalWeightGrams;

  /// Nutrient density of the prepared recipe per 100 g.
  final Map<NutrientCode, double?> nutrientsPer100g;

  final String? notes;
  final String? cuisine;
  final NutritionConfidence confidence;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get gramsPerServing =>
      servings <= 0 ? totalWeightGrams : totalWeightGrams / servings;

  double? nutrientPerServing(NutrientCode code) {
    final per100 = nutrientsPer100g[code];
    if (per100 == null) return null;
    return (per100 / 100.0) * gramsPerServing;
  }

  double? get caloriesPerServing =>
      nutrientPerServing(NutrientCode.energyKcal);

  Recipe copyWith({
    String? id,
    String? name,
    List<RecipeIngredient>? ingredients,
    int? servings,
    double? totalWeightGrams,
    Map<NutrientCode, double?>? nutrientsPer100g,
    String? notes,
    String? cuisine,
    NutritionConfidence? confidence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      servings: servings ?? this.servings,
      totalWeightGrams: totalWeightGrams ?? this.totalWeightGrams,
      nutrientsPer100g: nutrientsPer100g ?? this.nutrientsPer100g,
      notes: notes ?? this.notes,
      cuisine: cuisine ?? this.cuisine,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'servings': servings,
        'totalWeightGrams': totalWeightGrams,
        'nutrientsPer100g': {
          for (final e in nutrientsPer100g.entries) e.key.id: e.value,
        },
        'notes': notes,
        'cuisine': cuisine,
        'confidence': confidence.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final nutrientsRaw =
        (json['nutrientsPer100g'] as Map?)?.cast<String, dynamic>() ?? {};
    final nutrients = <NutrientCode, double?>{};
    for (final e in nutrientsRaw.entries) {
      final code = NutrientCodeX.fromId(e.key);
      if (code != null) {
        nutrients[code] = (e.value as num?)?.toDouble();
      }
    }

    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      ingredients: ((json['ingredients'] as List?) ?? [])
          .map((e) => RecipeIngredient.fromJson(
                (e as Map).cast<String, dynamic>(),
              ))
          .toList(),
      servings: json['servings'] as int? ?? 1,
      totalWeightGrams: (json['totalWeightGrams'] as num?)?.toDouble() ?? 0,
      nutrientsPer100g: nutrients,
      notes: json['notes'] as String?,
      cuisine: json['cuisine'] as String?,
      confidence: NutritionConfidence.values.firstWhere(
        (c) => c.name == json['confidence'],
        orElse: () => NutritionConfidence.medium,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          listEquals(ingredients, other.ingredients) &&
          servings == other.servings &&
          totalWeightGrams == other.totalWeightGrams &&
          mapEquals(nutrientsPer100g, other.nutrientsPer100g) &&
          notes == other.notes &&
          cuisine == other.cuisine &&
          confidence == other.confidence;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        Object.hashAll(ingredients),
        servings,
        totalWeightGrams,
        Object.hashAll(nutrientsPer100g.entries),
        notes,
        cuisine,
        confidence,
      );
}
