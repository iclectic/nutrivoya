import 'package:flutter/foundation.dart';

import 'food.dart';
import 'food_portion.dart';
import 'meal_type.dart';
import 'nutrient.dart';
import 'nutrition_confidence.dart';

/// A logged food entry in the diary.
///
/// Stores a food snapshot at log time so the diary works offline even if the
/// underlying food data changes. Macros are computed at log time from the
/// food's per-100g data and the selected portion/grams.
@immutable
class DiaryEntry {
  const DiaryEntry({
    this.id,
    required this.foodId,
    required this.foodName,
    required this.foodCanonicalName,
    required this.mealType,
    required this.grams,
    this.portionName,
    this.quantity = 1,
    this.caloriesKcal,
    this.proteinG,
    this.carbohydrateG,
    this.fatG,
    this.fibreG,
    this.confidence = NutritionConfidence.unknown,
    this.sourceName,
    required this.loggedAt,
    this.syncPending = false,
  });

  final int? id;
  final String foodId;
  final String foodName;
  final String foodCanonicalName;
  final MealType mealType;

  /// Total grams consumed (portion grams × quantity, or custom grams).
  final double grams;
  final String? portionName;
  final int quantity;

  // Computed macros at log time.
  final double? caloriesKcal;
  final double? proteinG;
  final double? carbohydrateG;
  final double? fatG;
  final double? fibreG;

  final NutritionConfidence confidence;
  final String? sourceName;
  final DateTime loggedAt;
  final bool syncPending;

  /// Build a DiaryEntry from a Food + portion/grams selection.
  factory DiaryEntry.fromFood({
    required Food food,
    required MealType mealType,
    required double grams,
    FoodPortion? portion,
    int quantity = 1,
    DateTime? loggedAt,
  }) {
    final scaled = _scaleMacros(food, grams);
    return DiaryEntry(
      foodId: food.id,
      foodName: food.displayName,
      foodCanonicalName: food.canonicalName,
      mealType: mealType,
      grams: grams,
      portionName: portion?.name,
      quantity: quantity,
      caloriesKcal: scaled[0],
      proteinG: scaled[1],
      carbohydrateG: scaled[2],
      fatG: scaled[3],
      fibreG: scaled[4],
      confidence: food.confidence,
      sourceName: food.source.name,
      loggedAt: loggedAt ?? DateTime.now(),
    );
  }

  static List<double?> _scaleMacros(Food food, double grams) {
    double? scale(double? per100g) {
      if (per100g == null) return null;
      return (per100g / 100) * grams;
    }
    return [
      scale(food.nutrientPer100g(_kcal)),
      scale(food.nutrientPer100g(_protein)),
      scale(food.nutrientPer100g(_carb)),
      scale(food.nutrientPer100g(_fat)),
      scale(food.nutrientPer100g(_fibre)),
    ];
  }

  DiaryEntry copyWith({
    int? id,
    String? foodId,
    String? foodName,
    String? foodCanonicalName,
    MealType? mealType,
    double? grams,
    String? portionName,
    int? quantity,
    double? caloriesKcal,
    double? proteinG,
    double? carbohydrateG,
    double? fatG,
    double? fibreG,
    NutritionConfidence? confidence,
    String? sourceName,
    DateTime? loggedAt,
    bool? syncPending,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      foodCanonicalName: foodCanonicalName ?? this.foodCanonicalName,
      mealType: mealType ?? this.mealType,
      grams: grams ?? this.grams,
      portionName: portionName ?? this.portionName,
      quantity: quantity ?? this.quantity,
      caloriesKcal: caloriesKcal ?? this.caloriesKcal,
      proteinG: proteinG ?? this.proteinG,
      carbohydrateG: carbohydrateG ?? this.carbohydrateG,
      fatG: fatG ?? this.fatG,
      fibreG: fibreG ?? this.fibreG,
      confidence: confidence ?? this.confidence,
      sourceName: sourceName ?? this.sourceName,
      loggedAt: loggedAt ?? this.loggedAt,
      syncPending: syncPending ?? this.syncPending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryEntry &&
          id == other.id &&
          foodId == other.foodId &&
          foodName == other.foodName &&
          foodCanonicalName == other.foodCanonicalName &&
          mealType == other.mealType &&
          grams == other.grams &&
          portionName == other.portionName &&
          quantity == other.quantity &&
          caloriesKcal == other.caloriesKcal &&
          proteinG == other.proteinG &&
          carbohydrateG == other.carbohydrateG &&
          fatG == other.fatG &&
          fibreG == other.fibreG &&
          confidence == other.confidence &&
          sourceName == other.sourceName &&
          loggedAt == other.loggedAt &&
          syncPending == other.syncPending;

  @override
  int get hashCode => Object.hash(
        id,
        foodId,
        foodName,
        foodCanonicalName,
        mealType,
        grams,
        portionName,
        quantity,
        caloriesKcal,
        proteinG,
        carbohydrateG,
        fatG,
        fibreG,
        confidence,
        sourceName,
        loggedAt,
        syncPending,
      );
}

// Nutrient code references for the fromFood factory.
const _kcal = NutrientCode.energyKcal;
const _protein = NutrientCode.proteinG;
const _carb = NutrientCode.carbohydrateG;
const _fat = NutrientCode.fatG;
const _fibre = NutrientCode.fibreG;

/// Daily nutrition totals computed from diary entries.
@immutable
class DailyTotals {
  const DailyTotals({
    this.caloriesKcal = 0,
    this.proteinG = 0,
    this.carbohydrateG = 0,
    this.fatG = 0,
    this.fibreG = 0,
    this.entryCount = 0,
  });

  final double caloriesKcal;
  final double proteinG;
  final double carbohydrateG;
  final double fatG;
  final double fibreG;
  final int entryCount;

  DailyTotals operator +(DailyTotals other) {
    return DailyTotals(
      caloriesKcal: caloriesKcal + other.caloriesKcal,
      proteinG: proteinG + other.proteinG,
      carbohydrateG: carbohydrateG + other.carbohydrateG,
      fatG: fatG + other.fatG,
      fibreG: fibreG + other.fibreG,
      entryCount: entryCount + other.entryCount,
    );
  }

  static DailyTotals fromEntry(DiaryEntry e) {
    return DailyTotals(
      caloriesKcal: e.caloriesKcal ?? 0,
      proteinG: e.proteinG ?? 0,
      carbohydrateG: e.carbohydrateG ?? 0,
      fatG: e.fatG ?? 0,
      fibreG: e.fibreG ?? 0,
      entryCount: 1,
    );
  }

  static DailyTotals fromEntries(Iterable<DiaryEntry> entries) {
    return entries.fold(DailyTotals(), (sum, e) => sum + DailyTotals.fromEntry(e));
  }

  int get caloriesRounded => caloriesKcal.round();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTotals &&
          caloriesKcal == other.caloriesKcal &&
          proteinG == other.proteinG &&
          carbohydrateG == other.carbohydrateG &&
          fatG == other.fatG &&
          fibreG == other.fibreG &&
          entryCount == other.entryCount;

  @override
  int get hashCode =>
      Object.hash(caloriesKcal, proteinG, carbohydrateG, fatG, fibreG, entryCount);
}
