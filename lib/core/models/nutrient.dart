import 'package:flutter/foundation.dart';

/// Core nutrients Nutrivoya tracks.
///
/// Values are stored per 100 g edible portion (see `NutrientAmount`). Units
/// are fixed per nutrient so conversions stay consistent across data sources.
enum NutrientCode {
  energyKcal('kcal'),
  proteinG('g'),
  carbohydrateG('g'),
  fatG('g'),
  fibreG('g'),
  saturatedFatG('g'),
  sugarG('g'),
  sodiumMg('mg'),
  ironMg('mg'),
  calciumMg('mg'),
  potassiumMg('mg'),
  magnesiumMg('mg'),
  zincMg('mg'),
  vitaminAUg('µg'),
  vitaminCMg('mg'),
  vitaminDUg('µg'),
  vitaminB12Ug('µg'),
  folateUg('µg');

  const NutrientCode(this.unit);

  /// Display unit for this nutrient.
  final String unit;

  /// Localization key for the nutrient's display name.
  String get l10nKey => 'nutrient${name[0].toUpperCase()}${name.substring(1)}';
}

/// A single nutrient amount, stored per 100 g edible portion.
///
/// `amount` may be `null` when a data source does not provide a value —
/// Nutrivoya never fabricates missing micronutrients.
@immutable
class NutrientAmount {
  const NutrientAmount({
    required this.code,
    required this.amountPer100g,
    this.unit,
  });

  final NutrientCode code;

  /// Amount per 100 g edible portion, or `null` if unknown.
  final double? amountPer100g;

  /// Unit (defaults to the nutrient's standard unit).
  final String? unit;

  String get effectiveUnit => unit ?? code.unit;

  NutrientAmount copyWith({double? amountPer100g, String? unit}) {
    return NutrientAmount(
      code: code,
      amountPer100g: amountPer100g ?? this.amountPer100g,
      unit: unit ?? this.unit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutrientAmount &&
          code == other.code &&
          amountPer100g == other.amountPer100g &&
          unit == other.unit;

  @override
  int get hashCode => Object.hash(code, amountPer100g, unit);
}
