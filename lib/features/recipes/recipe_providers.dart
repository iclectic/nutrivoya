import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/recipe.dart';
import '../../core/services/recipe_nutrition_service.dart';
import 'recipe_repository.dart';

final recipeNutritionServiceProvider =
    Provider<RecipeNutritionService>((ref) => const RecipeNutritionService());

/// Tick to force recipe list refresh after saves/deletes.
final recipesRevisionProvider = StateProvider<int>((ref) => 0);

final recipesProvider = Provider<List<Recipe>>((ref) {
  ref.watch(recipesRevisionProvider);
  return ref.watch(recipeRepositoryProvider).list();
});

final recipeByIdProvider = Provider.family<Recipe?, String>((ref, id) {
  ref.watch(recipesRevisionProvider);
  return ref.watch(recipeRepositoryProvider).getById(id);
});

class RecipeController {
  RecipeController(this._ref);

  final Ref _ref;

  Future<void> save(Recipe recipe) async {
    await _ref.read(recipeRepositoryProvider).save(recipe);
    _ref.read(recipesRevisionProvider.notifier).state++;
  }

  Future<void> delete(String id) async {
    await _ref.read(recipeRepositoryProvider).delete(id);
    _ref.read(recipesRevisionProvider.notifier).state++;
  }
}

final recipeControllerProvider = Provider<RecipeController>((ref) {
  return RecipeController(ref);
});
