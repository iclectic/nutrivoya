import 'package:flutter/foundation.dart';

/// Type of a food name entry in the multilingual name ontology.
enum NameType {
  /// Canonical display name for a language.
  primary,

  /// Translation of the canonical name.
  translation,

  /// Alternate name / synonym (e.g. "eggplant" for "aubergine").
  alias,

  /// Transliteration of a name (e.g. "baingan" for "बैंगन").
  transliteration,

  /// Region-specific name.
  regional,
}

extension NameTypeX on NameType {
  String get id => name;
}

/// A name for a food in a particular language / script.
///
/// A food has many names. This is what makes Nutrivoya culturally
/// intelligent: "aubergine", "eggplant", "brinjal", "baingan" and "बैंगन" can
/// all map to the same canonical food.
@immutable
class FoodName {
  FoodName({
    required this.name,
    this.languageCode,
    this.nameType = NameType.primary,
    String? normalizedName,
  }) : normalizedName = normalizedName ?? normalize(name);

  final String name;

  /// BCP-47 language code, or `null` when unspecified.
  final String? languageCode;

  final NameType nameType;

  /// Pre-normalized form used for search matching (lowercased, whitespace
  /// collapsed, diacritics folded).
  final String normalizedName;

  /// Normalize a query/name for search: lowercase, collapse whitespace, fold
  /// common Latin diacritics. Full Unicode normalization/transliteration is a
  /// future enhancement.
  static String normalize(String input) {
    var s = input.toLowerCase().trim();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    // Fold common Latin diacritics to ASCII equivalents.
    final diacriticsMap = <String, String>{
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'ā': 'a',
      'ç': 'c', 'ć': 'c',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ē': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ī': 'i',
      'ñ': 'n', 'ń': 'n',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o', 'ō': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ū': 'u',
      'ý': 'y', 'ÿ': 'y',
      'ś': 's', 'š': 's',
      'ž': 'z', 'ź': 'z', 'ż': 'z',
    };
    diacriticsMap.forEach((key, value) {
      s = s.replaceAll(key, value);
    });
    return s;
  }

  FoodName copyWith({
    String? name,
    String? languageCode,
    NameType? nameType,
    String? normalizedName,
  }) {
    return FoodName(
      name: name ?? this.name,
      languageCode: languageCode ?? this.languageCode,
      nameType: nameType ?? this.nameType,
      normalizedName: normalizedName ?? this.normalizedName,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodName &&
          name == other.name &&
          languageCode == other.languageCode &&
          nameType == other.nameType &&
          normalizedName == other.normalizedName;

  @override
  int get hashCode => Object.hash(name, languageCode, nameType, normalizedName);
}
