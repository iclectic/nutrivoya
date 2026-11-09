import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/recipe.dart';
import '../../core/storage/local_preferences.dart';

/// Offline personal recipe store (SharedPreferences JSON list).
class RecipeRepository {
  RecipeRepository(this._prefs);

  static const _key = 'nutrivoya.recipes.v1';

  final LocalPreferences _prefs;

  List<Recipe> list() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Recipe.fromJson((e as Map).cast<String, dynamic>()))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      return const [];
    }
  }

  Recipe? getById(String id) {
    for (final recipe in list()) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  Future<void> save(Recipe recipe) async {
    final recipes = list().where((r) => r.id != recipe.id).toList();
    recipes.add(recipe);
    recipes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _prefs.setString(
      _key,
      jsonEncode(recipes.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> delete(String id) async {
    final recipes = list().where((r) => r.id != id).toList();
    await _prefs.setString(
      _key,
      jsonEncode(recipes.map((r) => r.toJson()).toList()),
    );
  }
}

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(ref.watch(localPreferencesSyncProvider));
});
