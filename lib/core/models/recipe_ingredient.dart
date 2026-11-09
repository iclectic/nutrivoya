import 'package:flutter/foundation.dart';

import 'nutrient.dart';

/// One ingredient line in a user recipe.
///
/// Nutrient amounts are snapshotted per 100 g at add time so the recipe
/// remains reproducible even if the underlying food catalogue changes.
@immutable
class RecipeIngredient {
  const RecipeIngredient({
    required this.foodId,
    required this.foodName,
    required this.grams,
    required this.nutrientsPer100g,
    this.notes,
  });

  final String foodId;
  final String foodName;
  final double grams;

  /// Snapshotted nutrient density of this ingredient (per 100 g).
  final Map<NutrientCode, double?> nutrientsPer100g;

  final String? notes;

  Map<NutrientCode, double?> nutrientsForGrams() {
    return {
      for (final e in nutrientsPer100g.entries)
        e.key: e.value == null ? null : (e.value! / 100.0) * grams,
    };
  }

  RecipeIngredient copyWith({
    String? foodId,
    String? foodName,
    double? grams,
    Map<NutrientCode, double?>? nutrientsPer100g,
    String? notes,
  }) {
    return RecipeIngredient(
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      grams: grams ?? this.grams,
      nutrientsPer100g: nutrientsPer100g ?? this.nutrientsPer100g,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'foodName': foodName,
        'grams': grams,
        'nutrientsPer100g': {
          for (final e in nutrientsPer100g.entries) e.key.id: e.value,
        },
        'notes': notes,
      };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    final nutrientsRaw =
        (json['nutrientsPer100g'] as Map?)?.cast<String, dynamic>() ?? {};
    final nutrients = <NutrientCode, double?>{};
    for (final e in nutrientsRaw.entries) {
      final code = NutrientCodeX.fromId(e.key);
      if (code != null) {
        nutrients[code] = (e.value as num?)?.toDouble();
      }
    }
    return RecipeIngredient(
      foodId: json['foodId'] as String,
      foodName: json['foodName'] as String,
      grams: (json['grams'] as num).toDouble(),
      nutrientsPer100g: nutrients,
      notes: json['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredient &&
          runtimeType == other.runtimeType &&
          foodId == other.foodId &&
          foodName == other.foodName &&
          grams == other.grams &&
          mapEquals(nutrientsPer100g, other.nutrientsPer100g) &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(
        foodId,
        foodName,
        grams,
        Object.hashAll(nutrientsPer100g.entries),
        notes,
      );
}
