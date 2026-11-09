import 'package:flutter/foundation.dart';

/// How an on-device label model produced a query token.
///
/// Tokens are never calories. Nutrition always comes from a later structured
/// food lookup after the user confirms a match.
enum FoodLabelTokenSource {
  /// Matched against curated food vocabulary / aliases.
  vocabulary,

  /// Boosted because it aligns with the user's familiar cuisines.
  cuisineBias,

  /// Reserved for a future CV plug-in. Stub models must return no tokens.
  modelStub,
}

/// A query token emitted by an on-device food label model.
///
/// Contains **no** nutrition fields. Confidence is match strength only.
@immutable
class FoodLabelToken {
  const FoodLabelToken({
    required this.token,
    this.confidence = 0.5,
    this.source = FoodLabelTokenSource.vocabulary,
  });

  /// Free-text query fragment (e.g. "roti", "dal") for repository lookup.
  final String token;

  /// Relative match strength in `0..1`. Never a calorie estimate.
  final double confidence;

  final FoodLabelTokenSource source;

  String get normalized => token.trim().toLowerCase();

  bool get isUsable => normalized.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodLabelToken &&
          token == other.token &&
          confidence == other.confidence &&
          source == other.source;

  @override
  int get hashCode => Object.hash(token, confidence, source);
}
