import 'package:flutter/foundation.dart';

import 'food.dart';
import 'food_portion.dart';
import 'meal_type.dart';
import 'nutrient.dart';
import 'nutrition_confidence.dart';

/// A logged food entry in the diary.
///
/// Stores a food snapshot at log time so the diary works offline even if the
/// underlying food data changes. Macros and micronutrients are computed at
/// log time from the food's per-100g data — missing values stay null.
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
    this.sodiumMg,
    this.ironMg,
    this.calciumMg,
    this.potassiumMg,
    this.vitaminCMg,
    this.confidence = NutritionConfidence.unknown,
    this.sourceName,
    required this.loggedAt,
    this.syncPending = false,
    this.remoteId,
    this.updatedAt,
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

  // Optional micronutrients — null means unavailable for this food/portion.
  final double? sodiumMg;
  final double? ironMg;
  final double? calciumMg;
  final double? potassiumMg;
  final double? vitaminCMg;

  final NutritionConfidence confidence;
  final String? sourceName;
  final DateTime loggedAt;
  final bool syncPending;

  /// UUID shared with the backend row; null until first persisted.
  final String? remoteId;

  /// Last local modification time.
  final DateTime? updatedAt;

  /// Build a DiaryEntry from a Food + portion/grams selection.
  factory DiaryEntry.fromFood({
    required Food food,
    required MealType mealType,
    required double grams,
    FoodPortion? portion,
    int quantity = 1,
    DateTime? loggedAt,
  }) {
    double? scale(NutrientCode code) {
      final per100g = food.nutrientPer100g(code);
      if (per100g == null) return null;
      return (per100g / 100) * grams;
    }

    return DiaryEntry(
      foodId: food.id,
      foodName: food.displayName,
      foodCanonicalName: food.canonicalName,
      mealType: mealType,
      grams: grams,
      portionName: portion?.name,
      quantity: quantity,
      caloriesKcal: scale(NutrientCode.energyKcal),
      proteinG: scale(NutrientCode.proteinG),
      carbohydrateG: scale(NutrientCode.carbohydrateG),
      fatG: scale(NutrientCode.fatG),
      fibreG: scale(NutrientCode.fibreG),
      sodiumMg: scale(NutrientCode.sodiumMg),
      ironMg: scale(NutrientCode.ironMg),
      calciumMg: scale(NutrientCode.calciumMg),
      potassiumMg: scale(NutrientCode.potassiumMg),
      vitaminCMg: scale(NutrientCode.vitaminCMg),
      confidence: food.confidence,
      sourceName: food.source.name,
      loggedAt: loggedAt ?? DateTime.now(),
    );
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
    double? sodiumMg,
    double? ironMg,
    double? calciumMg,
    double? potassiumMg,
    double? vitaminCMg,
    NutritionConfidence? confidence,
    String? sourceName,
    DateTime? loggedAt,
    bool? syncPending,
    String? remoteId,
    DateTime? updatedAt,
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
      sodiumMg: sodiumMg ?? this.sodiumMg,
      ironMg: ironMg ?? this.ironMg,
      calciumMg: calciumMg ?? this.calciumMg,
      potassiumMg: potassiumMg ?? this.potassiumMg,
      vitaminCMg: vitaminCMg ?? this.vitaminCMg,
      confidence: confidence ?? this.confidence,
      sourceName: sourceName ?? this.sourceName,
      loggedAt: loggedAt ?? this.loggedAt,
      syncPending: syncPending ?? this.syncPending,
      remoteId: remoteId ?? this.remoteId,
      updatedAt: updatedAt ?? this.updatedAt,
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
          sodiumMg == other.sodiumMg &&
          ironMg == other.ironMg &&
          calciumMg == other.calciumMg &&
          potassiumMg == other.potassiumMg &&
          vitaminCMg == other.vitaminCMg &&
          confidence == other.confidence &&
          sourceName == other.sourceName &&
          loggedAt == other.loggedAt &&
          syncPending == other.syncPending &&
          remoteId == other.remoteId &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hashAll([
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
        sodiumMg,
        ironMg,
        calciumMg,
        potassiumMg,
        vitaminCMg,
        confidence,
        sourceName,
        loggedAt,
        syncPending,
        remoteId,
        updatedAt,
      ]);
}

/// Daily nutrition totals computed from diary entries.
///
/// Micronutrient fields are nullable: `null` means no logged food today
/// contributed that nutrient (unavailable — never invented as zero).
@immutable
class DailyTotals {
  const DailyTotals({
    this.caloriesKcal = 0,
    this.proteinG = 0,
    this.carbohydrateG = 0,
    this.fatG = 0,
    this.fibreG = 0,
    this.sodiumMg,
    this.ironMg,
    this.calciumMg,
    this.potassiumMg,
    this.vitaminCMg,
    this.entryCount = 0,
  });

  final double caloriesKcal;
  final double proteinG;
  final double carbohydrateG;
  final double fatG;
  final double fibreG;
  final double? sodiumMg;
  final double? ironMg;
  final double? calciumMg;
  final double? potassiumMg;
  final double? vitaminCMg;
  final int entryCount;

  static double? _sumNullable(double? a, double? b) {
    if (a == null && b == null) return null;
    return (a ?? 0) + (b ?? 0);
  }

  DailyTotals operator +(DailyTotals other) {
    return DailyTotals(
      caloriesKcal: caloriesKcal + other.caloriesKcal,
      proteinG: proteinG + other.proteinG,
      carbohydrateG: carbohydrateG + other.carbohydrateG,
      fatG: fatG + other.fatG,
      fibreG: fibreG + other.fibreG,
      sodiumMg: _sumNullable(sodiumMg, other.sodiumMg),
      ironMg: _sumNullable(ironMg, other.ironMg),
      calciumMg: _sumNullable(calciumMg, other.calciumMg),
      potassiumMg: _sumNullable(potassiumMg, other.potassiumMg),
      vitaminCMg: _sumNullable(vitaminCMg, other.vitaminCMg),
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
      sodiumMg: e.sodiumMg,
      ironMg: e.ironMg,
      calciumMg: e.calciumMg,
      potassiumMg: e.potassiumMg,
      vitaminCMg: e.vitaminCMg,
      entryCount: 1,
    );
  }

  static DailyTotals fromEntries(Iterable<DiaryEntry> entries) {
    return entries.fold(
      const DailyTotals(),
      (sum, e) => sum + DailyTotals.fromEntry(e),
    );
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
          sodiumMg == other.sodiumMg &&
          ironMg == other.ironMg &&
          calciumMg == other.calciumMg &&
          potassiumMg == other.potassiumMg &&
          vitaminCMg == other.vitaminCMg &&
          entryCount == other.entryCount;

  @override
  int get hashCode => Object.hash(
        caloriesKcal,
        proteinG,
        carbohydrateG,
        fatG,
        fibreG,
        sodiumMg,
        ironMg,
        calciumMg,
        potassiumMg,
        vitaminCMg,
        entryCount,
      );
}
