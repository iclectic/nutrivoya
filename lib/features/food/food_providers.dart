import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/food_search_result.dart';
import '../../features/profile/profile_controller.dart';
import '../add_product/add_product_providers.dart';
import '../barcode/barcode_providers.dart';
import 'data/usda_food_data_central_adapter.dart';
import 'food_repository.dart';
import 'food_search_service.dart';

final foodSearchServiceProvider = Provider<FoodSearchService>(
  (ref) => const FoodSearchService(),
);

final usdaAdapterProvider = Provider<UsdaFoodDataCentralAdapter>(
  (ref) => UsdaFoodDataCentralAdapter(),
);

final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) {
    // Watch revision so search picks up newly published user foods.
    ref.watch(productSubmissionsRevisionProvider);
    final userFoods = ref.watch(publishedUserFoodsProvider);
    return CompositeFoodRepository(
      searchService: ref.watch(foodSearchServiceProvider),
      usdaAdapter: ref.watch(usdaAdapterProvider),
      packagedFoodRepository: ref.watch(packagedFoodRepositoryProvider),
      userFoods: () => userFoods,
    );
  },
);

/// Current search query state.
final foodQueryProvider = StateProvider<String>((ref) => '');

/// Search results for the current query.
final foodSearchResultsProvider =
    FutureProvider.autoDispose<List<FoodSearchResult>>((ref) async {
  final query = ref.watch(foodQueryProvider);
  if (query.trim().isEmpty) return const [];
  final repo = ref.watch(foodRepositoryProvider);
  final profile = ref.watch(profileControllerProvider);
  return repo.search(query, profile: profile);
});

/// A single food by id (for the details screen).
final foodByIdProvider =
    FutureProvider.autoDispose.family<Food?, String>((ref, id) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getById(id);
});
