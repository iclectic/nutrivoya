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

  /// Normalize a query/name for search across scripts:
  /// - lowercase, trim, collapse whitespace, strip punctuation;
  /// - fold Latin diacritics and strip combining marks;
  /// - Arabic: remove tashkeel/tatweel, unify alef/yeh/teh-marbuta forms;
  /// - Devanagari/Gurmukhi: remove nukta so variant spellings match.
  static String normalize(String input) {
    var s = input.toLowerCase().trim();
    _latinFold.forEach((key, value) {
      s = s.replaceAll(key, value);
    });
    s = s
        .replaceAll(_combiningMarks, '')
        .replaceAll(_arabicMarks, '')
        .replaceAll(RegExp('[\u0623\u0625\u0622\u0671]'), '\u0627')
        .replaceAll('\u0649', '\u064A')
        .replaceAll('\u0629', '\u0647')
        .replaceAll(RegExp('[\u093C\u0A3C]'), '')
        .replaceAll(_punctuation, ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return s;
  }

  /// Loose phonetic key for romanized names so common transliteration
  /// variants match: "dhal"/"daal"/"dal", "chapatti"/"chapati",
  /// "bhindi"/"bindi", "keema"/"kima". Applied to Latin text only.
  static String phoneticKey(String normalized) {
    if (RegExp(r'[^a-z0-9 ]').hasMatch(normalized)) return normalized;
    var s = normalized
        .replaceAll('ee', 'i')
        .replaceAll('oo', 'u')
        .replaceAllMapped(RegExp(r'([bdgjkpt])h'), (m) => m[1]!)
        .replaceAll('w', 'v')
        .replaceAll('z', 's');
    s = s.replaceAllMapped(RegExp(r'([a-z])\1+'), (m) => m[1]!);
    return s;
  }

  static final _combiningMarks = RegExp('[\u0300-\u036F]');
  static final _arabicMarks = RegExp('[\u064B-\u065F\u0670\u0640]');
  static final _punctuation = RegExp(
      r"[!-/:-@\[-`{-~\u00A1-\u00BF\u2010-\u2027\u060C\u061B\u061F\u06D4\u0964\u0965]");

  static const _latinFold = <String, String>{
    'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'ā': 'a',
    'ç': 'c', 'ć': 'c',
    'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ē': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ī': 'i',
    'ñ': 'n', 'ń': 'n',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o', 'ō': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ū': 'u',
    'ý': 'y', 'ÿ': 'y',
    'ś': 's', 'š': 's', 'ṣ': 's',
    'ž': 'z', 'ź': 'z', 'ż': 'z',
    'ɛ': 'e', 'ɔ': 'o', 'œ': 'oe', 'æ': 'ae', 'ß': 'ss',
  };

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
