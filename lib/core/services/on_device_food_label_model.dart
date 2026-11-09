import 'dart:typed_data';

import '../models/food.dart';
import '../models/food_label_token.dart';
import '../models/food_name.dart';
import '../models/user_profile.dart';

/// On-device model that may emit food **query tokens** only.
///
/// Product rules:
/// - Never invent calorie or macro values.
/// - Prefer returning an empty list over guessing from pixels alone.
/// - Callers must look up structured [Food] records and require confirmation.
abstract class OnDeviceFoodLabelModel {
  Future<List<FoodLabelToken>> analyze({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Iterable<String>? vocabulary,
  });
}

/// Builds searchable vocabulary phrases from structured foods.
List<String> foodVocabularyFrom(Iterable<Food> foods) {
  final out = <String>{};
  for (final food in foods) {
    for (final name in food.allDisplayNames) {
      final n = FoodName.normalize(name);
      if (n.isEmpty) continue;
      out.add(n);
      // Also index short primary tokens (single words ≥ 3 chars).
      for (final part in n.split(
        RegExp(r'[^a-z0-9\u0900-\u097F\u0600-\u06FF\u0A00-\u0A7F]+'),
      )) {
        if (part.length >= 3) out.add(part);
      }
    }
  }
  final list = out.toList()
    ..sort((a, b) => b.length.compareTo(a.length)); // longer first
  return list;
}

/// Default offline model: extract vocabulary matches from the user description.
///
/// Image bytes are ignored for naming — this model will not invent foods from
/// pixels. Without a description (or vocabulary) it returns an empty list.
class VocabularyOnDeviceFoodLabelModel implements OnDeviceFoodLabelModel {
  const VocabularyOnDeviceFoodLabelModel({this.defaultVocabulary = const []});

  /// Fallback vocabulary when callers do not pass one per analyze().
  final List<String> defaultVocabulary;

  @override
  Future<List<FoodLabelToken>> analyze({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Iterable<String>? vocabulary,
  }) async {
    // Presence of a photo is required by the session, but pixels are not a
    // food database. Empty images yield no tokens.
    if (imageBytes.isEmpty) return const [];

    final text = FoodName.normalize(description ?? '');
    if (text.isEmpty) return const [];

    final vocab = (vocabulary ?? defaultVocabulary)
        .map(FoodName.normalize)
        .where((v) => v.isNotEmpty)
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    if (vocab.isEmpty) return const [];

    final matched = <String, FoodLabelToken>{};
    for (final phrase in vocab) {
      if (!_containsPhrase(text, phrase)) continue;
      matched.putIfAbsent(
        phrase,
        () => FoodLabelToken(
          token: phrase,
          confidence: _confidenceFor(phrase, text),
          source: FoodLabelTokenSource.vocabulary,
        ),
      );
      if (matched.length >= 12) break;
    }

    final tokens = matched.values.toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    return tokens;
  }

  static bool _containsPhrase(String haystack, String needle) {
    if (needle.isEmpty || !haystack.contains(needle)) return false;
    // Word-boundary-ish check for short Latin tokens to avoid "dal" in "medal".
    if (needle.length <= 3 && _isMostlyLatin(needle)) {
      final re = RegExp(
        '(?:^|[^a-z0-9])${RegExp.escape(needle)}(?:[^a-z0-9]|\$)',
      );
      return re.hasMatch(haystack);
    }
    return true;
  }

  static bool _isMostlyLatin(String s) =>
      RegExp(r'^[a-z0-9\s-]+$').hasMatch(s);

  static double _confidenceFor(String phrase, String text) {
    if (text == phrase) return 0.95;
    if (text.startsWith(phrase) || text.endsWith(phrase)) return 0.85;
    final lenScore = (phrase.length / text.length).clamp(0.35, 0.8);
    return lenScore.toDouble();
  }
}

/// Documents that pixel statistics alone never invent food labels.
///
/// A future CV plug-in can replace this; until then it always returns [].
class StubPixelHistogramLabelModel implements OnDeviceFoodLabelModel {
  const StubPixelHistogramLabelModel();

  @override
  Future<List<FoodLabelToken>> analyze({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Iterable<String>? vocabulary,
  }) async {
    // Intentionally ignore inputs — pixels are not nutrition data and this
    // stub will not fabricate dish names.
    return const [];
  }
}

/// Wraps another model and lightly boosts tokens that appear in foods tagged
/// with the user's familiar cuisines. Still emits tokens only — never kcal.
class CuisineBiasedOnDeviceFoodLabelModel implements OnDeviceFoodLabelModel {
  const CuisineBiasedOnDeviceFoodLabelModel({
    required this.inner,
    this.foods = const [],
  });

  final OnDeviceFoodLabelModel inner;
  final List<Food> foods;

  @override
  Future<List<FoodLabelToken>> analyze({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Iterable<String>? vocabulary,
  }) async {
    final base = await inner.analyze(
      imageBytes: imageBytes,
      description: description,
      profile: profile,
      vocabulary: vocabulary,
    );
    if (base.isEmpty || foods.isEmpty) return base;

    final cuisines = profile?.familiarCuisines
            .map((c) => c.trim().toLowerCase())
            .where((c) => c.isNotEmpty)
            .toSet() ??
        const <String>{};
    if (cuisines.isEmpty) return base;

    final boostedNames = <String>{};
    for (final food in foods) {
      final cuisine = food.cuisine?.toLowerCase();
      if (cuisine == null ||
          !cuisines.any((c) => cuisine.contains(c) || c.contains(cuisine))) {
        continue;
      }
      for (final name in food.allDisplayNames) {
        boostedNames.add(FoodName.normalize(name));
      }
    }
    if (boostedNames.isEmpty) return base;

    return [
      for (final t in base)
        FoodLabelToken(
          token: t.token,
          confidence: boostedNames.contains(t.normalized)
              ? (t.confidence + 0.08).clamp(0.0, 0.99)
              : t.confidence,
          source: boostedNames.contains(t.normalized)
              ? FoodLabelTokenSource.cuisineBias
              : t.source,
        ),
    ]..sort((a, b) => b.confidence.compareTo(a.confidence));
  }
}

/// Runs vocabulary matching, then a pixel stub that must stay empty.
///
/// Production default: description → tokens; pixels → nothing.
class HybridOnDeviceFoodLabelModel implements OnDeviceFoodLabelModel {
  const HybridOnDeviceFoodLabelModel({
    required this.vocabularyModel,
    this.pixelModel = const StubPixelHistogramLabelModel(),
  });

  final OnDeviceFoodLabelModel vocabularyModel;
  final OnDeviceFoodLabelModel pixelModel;

  @override
  Future<List<FoodLabelToken>> analyze({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Iterable<String>? vocabulary,
  }) async {
    final fromText = await vocabularyModel.analyze(
      imageBytes: imageBytes,
      description: description,
      profile: profile,
      vocabulary: vocabulary,
    );
    // Pixel path is consulted for API completeness; stub returns [].
    final fromPixels = await pixelModel.analyze(
      imageBytes: imageBytes,
      description: description,
      profile: profile,
      vocabulary: vocabulary,
    );
    if (fromPixels.isEmpty) return fromText;

    final seen = {for (final t in fromText) t.normalized};
    return [
      ...fromText,
      for (final t in fromPixels)
        if (seen.add(t.normalized)) t,
    ];
  }
}
