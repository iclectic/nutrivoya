import 'package:flutter/foundation.dart';

import '../../core/models/food.dart';
import '../../core/models/food_search_result.dart';
import '../../core/models/user_profile.dart';
import 'data/local_food_dataset.dart';
import 'data/usda_food_data_central_adapter.dart';
import 'food_search_service.dart';

/// Abstraction over Nutrivoya's multi-source food data architecture.
///
/// Sources are queried in priority order (local curated first for offline +
/// speed, then authoritative remote). Results are merged, ranked and
/// deduplicated by [FoodSearchService].
abstract class FoodRepository {
  Future<List<FoodSearchResult>> search(
    String query, {
    UserProfile? profile,
    Set<String> recentFoodIds = const {},
  });

  Future<Food?> getById(String id);
}

/// Composite repository: local curated dataset + optional USDA adapter.
///
/// The local dataset always provides results offline. The USDA adapter is
/// only queried when configured (API key present) and network is available;
/// its failures never break the local experience.
class CompositeFoodRepository implements FoodRepository {
  CompositeFoodRepository({
    required FoodSearchService searchService,
    UsdaFoodDataCentralAdapter? usdaAdapter,
  })  : _searchService = searchService,
        _usdaAdapter = usdaAdapter;

  final FoodSearchService _searchService;
  final UsdaFoodDataCentralAdapter? _usdaAdapter;

  @override
  Future<List<FoodSearchResult>> search(
    String query, {
    UserProfile? profile,
    Set<String> recentFoodIds = const {},
  }) async {
    final local = LocalFoodDataset.all();

    List<Food> remote = const [];
    if (_usdaAdapter != null && _usdaAdapter.isConfigured) {
      try {
        remote = await _usdaAdapter.search(query);
      } catch (e) {
        if (kDebugMode) debugPrint('[FoodRepository] USDA search failed: $e');
      }
    }

    final merged = [...local, ...remote];
    return _searchService.search(query, merged,
        profile: profile, recentFoodIds: recentFoodIds);
  }

  @override
  Future<Food?> getById(String id) async {
    // Local ids have no prefix; USDA ids are prefixed with 'usda:'.
    if (id.startsWith('usda:')) {
      if (_usdaAdapter == null || !_usdaAdapter.isConfigured) return null;
      try {
        return await _usdaAdapter.getById(id.substring(5));
      } catch (e) {
        if (kDebugMode) debugPrint('[FoodRepository] USDA getById failed: $e');
        return null;
      }
    }
    return LocalFoodDataset.byId(id);
  }
}

/// A pure-local repository used in tests and when no backend is configured.
class LocalFoodRepository implements FoodRepository {
  LocalFoodRepository({FoodSearchService? searchService})
      : _searchService = searchService ?? const FoodSearchService();

  final FoodSearchService _searchService;

  @override
  Future<List<FoodSearchResult>> search(
    String query, {
    UserProfile? profile,
    Set<String> recentFoodIds = const {},
  }) async {
    return _searchService.search(query, LocalFoodDataset.all(),
        profile: profile, recentFoodIds: recentFoodIds);
  }

  @override
  Future<Food?> getById(String id) async => LocalFoodDataset.byId(id);
}
