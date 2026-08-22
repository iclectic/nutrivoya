import 'package:flutter/foundation.dart';

/// A culturally meaningful portion that maps to an estimated weight in grams.
///
/// Users should not always have to enter grams. Nutrivoya supports portions
/// like "1 roti", "1 katori", "1 bowl", "1 ball of fufu", "1 injera". Each
/// maps internally to estimated grams. Grams are always available for precise
/// users.
@immutable
class FoodPortion {
  const FoodPortion({
    required this.name,
    required this.grams,
    this.region,
    this.source,
    this.sizeClass,
  });

  /// Display name, e.g. "1 medium roti".
  final String name;

  /// Estimated weight in grams for this portion.
  final double grams;

  /// Optional region/cuisine this portion is typical of.
  final String? region;

  /// Where the gram estimate came from.
  final String? source;

  /// Optional calibration bucket.
  final PortionSizeClass? sizeClass;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodPortion &&
          name == other.name &&
          grams == other.grams &&
          region == other.region &&
          source == other.source &&
          sizeClass == other.sizeClass;

  @override
  int get hashCode => Object.hash(name, grams, region, source, sizeClass);
}

/// Small / Medium / Large calibration for portions.
enum PortionSizeClass { small, medium, large }

extension PortionSizeClassX on PortionSizeClass {
  String get id => name;

  String get l10nKey {
    switch (this) {
      case PortionSizeClass.small:
        return 'portionSmall';
      case PortionSizeClass.medium:
        return 'portionMedium';
      case PortionSizeClass.large:
        return 'portionLarge';
    }
  }
}
