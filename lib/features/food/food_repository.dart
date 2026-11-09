import 'package:flutter/foundation.dart';

import '../../core/models/food.dart';
import '../../core/models/food_search_result.dart';
import '../../core/models/user_profile.dart';
import 'data/local_food_dataset.dart';
import 'data/packaged_food_repository.dart';
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
  });

  Future<Food?> getById(String id);
}

/// Composite repository: local curated + optional USDA + packaged (OFF).
///
/// The local dataset always provides results offline. Remote adapters are
/// only queried when available; their failures never break the local
/// experience.
class CompositeFoodRepository implements FoodRepository {
  CompositeFoodRepository({
    required FoodSearchService searchService,
    UsdaFoodDataCentralAdapter? usdaAdapter,
    PackagedFoodRepository? packagedFoodRepository,
    List<Food> Function()? userFoods,
  })  : _searchService = searchService,
        _usdaAdapter = usdaAdapter,
        _packaged = packagedFoodRepository,
        _userFoods = userFoods;

  final FoodSearchService _searchService;
  final UsdaFoodDataCentralAdapter? _usdaAdapter;
  final PackagedFoodRepository? _packaged;

  /// Optional personal-library foods (user-submitted, pending review).
  final List<Food> Function()? _userFoods;

  @override
  Future<List<FoodSearchResult>> search(
    String query, {
    UserProfile? profile,
  }) async {
    final local = LocalFoodDataset.all();
    final user = _userFoods?.call() ?? const <Food>[];

    List<Food> remote = const [];
    if (_usdaAdapter != null && _usdaAdapter.isConfigured) {
      try {
        remote = await _usdaAdapter.search(query);
      } catch (e) {
        if (kDebugMode) debugPrint('[FoodRepository] USDA search failed: $e');
      }
    }

    // Digit-only queries that look like barcodes hit packaged lookup and
    // short-circuit: the resolved product is the result, not a text match.
    if (_packaged != null && looksLikeBarcode(query.trim())) {
      try {
        final food = await _packaged.lookupBarcode(query.trim());
        if (food != null) {
          return [
            FoodSearchResult(
              food: food,
              matchKind: SearchMatchKind.exactAlias,
              matchedName: normalizeBarcode(query.trim()) ?? query.trim(),
            ),
          ];
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[FoodRepository] packaged barcode search failed: $e');
        }
      }
      // Fall through so a user-submitted barcode alias can still match.
    }

    final merged = [...local, ...user, ...remote];
    return _searchService.search(query, merged, profile: profile);
  }

  @override
  Future<Food?> getById(String id) async {
    // Local ids have no prefix; USDA ids are prefixed with 'usda:';
    // packaged (Open Food Facts) ids with 'off:'; user submissions 'user:'.
    if (id.startsWith('usda:')) {
      if (_usdaAdapter == null || !_usdaAdapter.isConfigured) return null;
      try {
        return await _usdaAdapter.getById(id.substring(5));
      } catch (e) {
        if (kDebugMode) debugPrint('[FoodRepository] USDA getById failed: $e');
        return null;
      }
    }
    if (id.startsWith('off:')) {
      if (_packaged == null) return null;
      try {
        return await _packaged.lookupBarcode(id.substring(4));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[FoodRepository] OFF getById failed: $e');
        }
        return null;
      }
    }
    if (id.startsWith('user:')) {
      final users = _userFoods?.call() ?? const <Food>[];
      for (final food in users) {
        if (food.id == id) return food;
      }
      return null;
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
  }) async {
    return _searchService.search(query, LocalFoodDataset.all(), profile: profile);
  }

  @override
  Future<Food?> getById(String id) async => LocalFoodDataset.byId(id);
}
