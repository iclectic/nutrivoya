import '../../core/models/food.dart';
import '../../core/models/food_name.dart';
import '../../core/models/food_search_result.dart';
import '../../core/models/nutrient.dart';
import '../../core/models/user_profile.dart';

/// Search pipeline and ranking.
///
/// Pipeline (per spec):
///   query -> normalize -> exact primary -> exact alias ->
///   cuisine-preferred -> prefix -> contains -> fuzzy fallback
///
/// Within a match rank, previously logged foods ([recentFoodIds]) come first.
/// A phonetic step catches romanization variants ("dhal" → "dal").
class FoodSearchService {
  const FoodSearchService();

  /// Search a list of foods (typically the union of local + remote results).
  /// Results are deduplicated by food id and sorted by match rank.
  List<FoodSearchResult> search(
    String query,
    Iterable<Food> foods, {
    UserProfile? profile,
    Set<String> recentFoodIds = const {},
  }) {
    final normalized = FoodName.normalize(query);
    if (normalized.isEmpty) return const [];

    final preferredCuisines = profile?.familiarCuisines
            .map(FoodName.normalize)
            .toSet() ??
        const <String>{};

    final results = <FoodSearchResult>[];
    final seen = <String>{};

    for (final food in foods) {
      final result = _match(food, normalized, preferredCuisines);
      if (result != null && !seen.contains(food.id)) {
        seen.add(food.id);
        results.add(result);
      }
    }

    results.sort((a, b) {
      final byRank = b.matchKind.rank.compareTo(a.matchKind.rank);
      if (byRank != 0) return byRank;
      final aRecent = recentFoodIds.contains(a.food.id) ? 1 : 0;
      final bRecent = recentFoodIds.contains(b.food.id) ? 1 : 0;
      if (aRecent != bRecent) return bRecent.compareTo(aRecent);
      // Tie-break: prefer foods with configured calorie data, then name.
      final aKcal =
          a.food.nutrientPer100g(NutrientCode.energyKcal) != null ? 1 : 0;
      final bKcal =
          b.food.nutrientPer100g(NutrientCode.energyKcal) != null ? 1 : 0;
      final byData = bKcal.compareTo(aKcal);
      if (byData != 0) return byData;
      return a.food.displayName.compareTo(b.food.displayName);
    });

    return results;
  }

  FoodSearchResult? _match(
    Food food,
    String normalizedQuery,
    Set<String> preferredCuisines,
  ) {
    final allNames = <_NameEntry>[
      _NameEntry(
          FoodName.normalize(food.canonicalName), food.canonicalName, NameType.primary),
      ...food.names.map((n) => _NameEntry(n.normalizedName, n.name, n.nameType)),
    ];

    // 1. Exact primary match.
    final exactPrimary = allNames.firstWhereOrNull(
      (n) => n.normalized == normalizedQuery && n.type == NameType.primary,
    );
    if (exactPrimary != null) {
      return FoodSearchResult(
        food: food,
        matchKind: SearchMatchKind.exactPrimary,
        matchedName: exactPrimary.display,
      );
    }

    // 2. Exact alias/translation/transliteration/regional match.
    final exactAlias = allNames.firstWhereOrNull(
      (n) => n.normalized == normalizedQuery && n.type != NameType.primary,
    );
    if (exactAlias != null) {
      return FoodSearchResult(
        food: food,
        matchKind: SearchMatchKind.exactAlias,
        matchedName: exactAlias.display,
      );
    }

    final cuisineMatch = (food.cuisine != null &&
            preferredCuisines.contains(FoodName.normalize(food.cuisine!))) ||
        (food.region != null &&
            preferredCuisines.contains(FoodName.normalize(food.region!)));

    // 3. Prefix match.
    final prefix =
        allNames.firstWhereOrNull((n) => n.normalized.startsWith(normalizedQuery));
    if (prefix != null) {
      return FoodSearchResult(
        food: food,
        matchKind: cuisineMatch
            ? SearchMatchKind.cuisinePreferred
            : SearchMatchKind.prefix,
        matchedName: prefix.display,
      );
    }

    // 4. Contains match.
    final contains =
        allNames.firstWhereOrNull((n) => n.normalized.contains(normalizedQuery));
    if (contains != null) {
      return FoodSearchResult(
        food: food,
        matchKind: cuisineMatch
            ? SearchMatchKind.cuisinePreferred
            : SearchMatchKind.contains,
        matchedName: contains.display,
      );
    }

    // 5. Phonetic: transliteration variants (dhal/daal/dal, chapatti/chapati).
    final queryKey = FoodName.phoneticKey(normalizedQuery);
    final phonetic = allNames.firstWhereOrNull((n) {
      final key = FoodName.phoneticKey(n.normalized);
      return key == queryKey || (queryKey.length >= 3 && key.startsWith(queryKey));
    });
    if (phonetic != null) {
      return FoodSearchResult(
        food: food,
        matchKind: SearchMatchKind.fuzzy,
        matchedName: phonetic.display,
      );
    }

    // 6. Fuzzy: any query token appears as a name token.
    if (_tokenOverlap(normalizedQuery, allNames)) {
      return FoodSearchResult(
        food: food,
        matchKind: SearchMatchKind.fuzzy,
        matchedName: food.displayName,
      );
    }

    return null;
  }

  bool _tokenOverlap(String query, List<_NameEntry> names) {
    final queryTokens = query.split(' ').where((t) => t.isNotEmpty).toSet();
    if (queryTokens.isEmpty) return false;
    for (final n in names) {
      final nameTokens = n.normalized.split(' ').where((t) => t.isNotEmpty).toSet();
      if (queryTokens.intersection(nameTokens).isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}

class _NameEntry {
  const _NameEntry(this.normalized, this.display, this.type);
  final String normalized;
  final String display;
  final NameType type;
}

/// Lightweight `firstWhereOrNull` to avoid pulling in collection package.
extension _IterableFirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
