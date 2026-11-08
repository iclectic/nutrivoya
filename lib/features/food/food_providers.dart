import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/food_search_result.dart';
import '../../features/profile/profile_controller.dart';
import '../diary/diary_providers.dart';
import '../barcode/open_food_facts_adapter.dart';
import '../recipes/recipe_providers.dart';
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
  (ref) => CompositeFoodRepository(
    searchService: ref.watch(foodSearchServiceProvider),
    usdaAdapter: ref.watch(usdaAdapterProvider),
  ),
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
  Set<String> recent = const {};
  try {
    final entries = await ref.watch(recentFoodsProvider.future);
    recent = entries.map((e) => e.foodId).toSet();
  } catch (_) {}
  final results =
      await repo.search(query, profile: profile, recentFoodIds: recent);
  final recipes = ref.watch(recipesProvider).map((r) => r.toFood()).toList();
  if (recipes.isEmpty) return results;
  final recipeResults = ref
      .watch(foodSearchServiceProvider)
      .search(query, recipes, profile: profile, recentFoodIds: recent);
  return [...recipeResults, ...results];
});

/// A single food by id (for the details screen).
final foodByIdProvider =
    FutureProvider.autoDispose.family<Food?, String>((ref, id) async {
  final recipe = ref.watch(recipesProvider.notifier).byFoodId(id);
  if (recipe != null) return recipe.toFood();
  final packaged = ref.watch(packagedFoodCacheProvider).byFoodId(id);
  if (packaged != null) return packaged;
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getById(id);
});
