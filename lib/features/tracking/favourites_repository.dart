import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/favourite_food.dart';
import '../../core/storage/local_preferences.dart';

/// Offline favourites store (SharedPreferences JSON list).
class FavouritesRepository {
  FavouritesRepository(this._prefs);

  static const _key = 'nutrivoya.favourites.v1';

  final LocalPreferences _prefs;

  List<FavouriteFood> list() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (e) => FavouriteFood.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList()
        ..sort(
          (a, b) => (b.addedAt ?? DateTime(0))
              .compareTo(a.addedAt ?? DateTime(0)),
        );
    } catch (_) {
      return const [];
    }
  }

  bool isFavourite(String foodId) =>
      list().any((f) => f.foodId == foodId);

  Future<void> add(FavouriteFood food) async {
    final items = list().where((f) => f.foodId != food.foodId).toList();
    items.insert(
      0,
      FavouriteFood(
        foodId: food.foodId,
        foodName: food.foodName,
        foodCanonicalName: food.foodCanonicalName,
        addedAt: food.addedAt ?? DateTime.now(),
      ),
    );
    await _persist(items);
  }

  Future<void> remove(String foodId) async {
    await _persist(list().where((f) => f.foodId != foodId).toList());
  }

  Future<void> toggle(FavouriteFood food) async {
    if (isFavourite(food.foodId)) {
      await remove(food.foodId);
    } else {
      await add(food);
    }
  }

  Future<void> _persist(List<FavouriteFood> items) {
    return _prefs.setString(
      _key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}

final favouritesRepositoryProvider = Provider<FavouritesRepository>((ref) {
  return FavouritesRepository(ref.watch(localPreferencesSyncProvider));
});
