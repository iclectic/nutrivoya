import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_preferences.dart';
import 'recipe.dart';

/// Stores personal recipes on-device (offline-first).
class RecipeRepository {
  RecipeRepository(this._prefs);
  final LocalPreferences _prefs;

  static const _key = 'nutrivoya.recipes';

  List<Recipe> load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      return [
        for (final r in jsonDecode(raw) as List)
          Recipe.fromJson(r as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<void> saveAll(List<Recipe> recipes) => _prefs.setString(
        _key,
        jsonEncode([for (final r in recipes) r.toJson()]),
      );
}

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepository(ref.watch(localPreferencesSyncProvider)),
);

class RecipesController extends StateNotifier<List<Recipe>> {
  RecipesController(this._repo) : super(_repo.load());
  final RecipeRepository _repo;

  Future<void> upsert(Recipe recipe) async {
    final exists = state.any((r) => r.id == recipe.id);
    state = exists
        ? [for (final r in state) r.id == recipe.id ? recipe : r]
        : [...state, recipe];
    await _repo.saveAll(state);
  }

  Future<void> delete(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _repo.saveAll(state);
  }

  Recipe? byFoodId(String foodId) {
    if (!foodId.startsWith(Recipe.idPrefix)) return null;
    final id = foodId.substring(Recipe.idPrefix.length);
    for (final r in state) {
      if (r.id == id) return r;
    }
    return null;
  }
}

final recipesProvider =
    StateNotifierProvider<RecipesController, List<Recipe>>(
  (ref) => RecipesController(ref.watch(recipeRepositoryProvider)),
);
