import 'package:flutter/foundation.dart';

import 'food.dart';

/// Why a search result matched, used for ranking and (later) highlighting.
enum SearchMatchKind {
  /// Exact match on a primary name in the query's language.
  exactPrimary,
  /// Exact match on an alias.
  exactAlias,
  /// Match on user's familiar cuisine/region.
  cuisinePreferred,
  /// Starts-with match.
  prefix,
  /// Substring / contains match.
  contains,
  /// Fuzzy fallback.
  fuzzy,
}

extension SearchMatchKindX on SearchMatchKind {
  /// Higher rank = better match.
  int get rank {
    switch (this) {
      case SearchMatchKind.exactPrimary:
        return 100;
      case SearchMatchKind.exactAlias:
        return 90;
      case SearchMatchKind.cuisinePreferred:
        return 80;
      case SearchMatchKind.prefix:
        return 70;
      case SearchMatchKind.contains:
        return 50;
      case SearchMatchKind.fuzzy:
        return 10;
    }
  }
}

/// A single search hit.
@immutable
class FoodSearchResult {
  const FoodSearchResult({
    required this.food,
    required this.matchKind,
    this.matchedName,
  });

  final Food food;
  final SearchMatchKind matchKind;

  /// The name that matched the query (for display/highlight).
  final String? matchedName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodSearchResult &&
          food == other.food &&
          matchKind == other.matchKind &&
          matchedName == other.matchedName;

  @override
  int get hashCode => Object.hash(food, matchKind, matchedName);
}
