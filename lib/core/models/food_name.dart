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
  /// Latin diacritics, and strip combining marks.
  ///
  /// Non-Latin scripts (Devanagari, Arabic, Gurmukhi, Hangul, etc.) are
  /// preserved so users can search in those orthographies directly.
  static String normalize(String input) {
    var s = input.toLowerCase().trim();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    const diacriticsMap = <String, String>{
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
    final buffer = StringBuffer();
    for (final rune in s.runes) {
      // Skip combining diacritical marks (NFD leftovers).
      if (rune >= 0x0300 && rune <= 0x036F) continue;
      final ch = String.fromCharCode(rune);
      buffer.write(diacriticsMap[ch] ?? ch);
    }
    return buffer.toString();
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
