import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/meal_type.dart';
import '../../core/storage/local_preferences.dart';
import '../barcode/open_food_facts_adapter.dart';
import '../diary/diary_providers.dart';
import '../food/food_providers.dart';
import '../recipes/recipe_providers.dart';
import 'tracking_models.dart';

/// JSON persistence in on-device preferences (offline-first).
class JsonStore {
  JsonStore(this._prefs);
  final LocalPreferences _prefs;

  Object? read(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String key, Object value) => _prefs.setString(key, jsonEncode(value));

  List<Map<String, dynamic>> readList(String key) =>
      [for (final e in (read(key) as List?) ?? const []) (e as Map).cast<String, dynamic>()];
}

final jsonStoreProvider = Provider((ref) => JsonStore(ref.watch(localPreferencesSyncProvider)));

String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class WeightLogController extends StateNotifier<List<WeightEntry>> {
  WeightLogController(this._store)
      : super([for (final j in _store.readList(_key)) WeightEntry.fromJson(j)]);
  final JsonStore _store;
  static const _key = 'nutrivoya.tracking.weight';

  Future<void> add(double kg, {DateTime? at}) async {
    state = [...state, WeightEntry(at ?? DateTime.now(), kg)]..sort((a, b) => a.date.compareTo(b.date));
    await _store.write(_key, [for (final e in state) e.toJson()]);
  }

  Future<void> remove(WeightEntry entry) async {
    state = state.where((e) => e != entry).toList();
    await _store.write(_key, [for (final e in state) e.toJson()]);
  }
}

class MeasurementsController extends StateNotifier<List<MeasurementEntry>> {
  MeasurementsController(this._store)
      : super([for (final j in _store.readList(_key)) MeasurementEntry.fromJson(j)]);
  final JsonStore _store;
  static const _key = 'nutrivoya.tracking.measurements';

  Future<void> add(MeasurementEntry entry) async {
    state = [...state, entry]..sort((a, b) => a.date.compareTo(b.date));
    await _store.write(_key, [for (final e in state) e.toJson()]);
  }
}

class WaterController extends StateNotifier<Map<String, int>> {
  WaterController(this._store)
      : super({
          for (final e in ((_store.read(_key) as Map?) ?? const {}).entries)
            e.key as String: (e.value as num).toInt(),
        });
  final JsonStore _store;
  static const _key = 'nutrivoya.tracking.water';

  int forDay(DateTime day) => state[dayKey(day)] ?? 0;

  Future<void> add(int ml, {DateTime? day}) async {
    final k = dayKey(day ?? DateTime.now());
    final next = ((state[k] ?? 0) + ml).clamp(0, 20000);
    state = {...state, k: next};
    await _store.write(_key, state);
  }
}

/// Favourite foods: id → display name snapshot.
class FavouritesController extends StateNotifier<Map<String, String>> {
  FavouritesController(this._store)
      : super(((_store.read(_key) as Map?) ?? const {}).cast<String, String>());
  final JsonStore _store;
  static const _key = 'nutrivoya.favourites';

  Future<void> toggle(String foodId, String name) async {
    final next = {...state};
    if (next.remove(foodId) == null) next[foodId] = name;
    state = next;
    await _store.write(_key, state);
  }
}

class MealTemplatesController extends StateNotifier<List<MealTemplate>> {
  MealTemplatesController(this._store)
      : super([for (final j in _store.readList(_key)) MealTemplate.fromJson(j)]);
  final JsonStore _store;
  static const _key = 'nutrivoya.mealTemplates';

  Future<void> add(MealTemplate t) async {
    state = [...state, t];
    await _store.write(_key, [for (final e in state) e.toJson()]);
  }

  Future<void> delete(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _store.write(_key, [for (final e in state) e.toJson()]);
  }
}

final weightLogProvider = StateNotifierProvider<WeightLogController, List<WeightEntry>>(
    (ref) => WeightLogController(ref.watch(jsonStoreProvider)));
final measurementsProvider = StateNotifierProvider<MeasurementsController, List<MeasurementEntry>>(
    (ref) => MeasurementsController(ref.watch(jsonStoreProvider)));
final waterProvider = StateNotifierProvider<WaterController, Map<String, int>>(
    (ref) => WaterController(ref.watch(jsonStoreProvider)));
final favouritesProvider = StateNotifierProvider<FavouritesController, Map<String, String>>(
    (ref) => FavouritesController(ref.watch(jsonStoreProvider)));
final mealTemplatesProvider = StateNotifierProvider<MealTemplatesController, List<MealTemplate>>(
    (ref) => MealTemplatesController(ref.watch(jsonStoreProvider)));

/// Logs every item of a template into a meal, resolving foods from personal
/// recipes, cached packaged products or the food repository.
class MealTemplateLogger {
  MealTemplateLogger(this._ref);
  final Ref _ref;

  Future<Food?> _resolve(String id) async =>
      _ref.read(recipesProvider.notifier).byFoodId(id)?.toFood() ??
      _ref.read(packagedFoodCacheProvider).byFoodId(id) ??
      await _ref.read(foodRepositoryProvider).getById(id);

  /// Returns the number of items logged (unresolvable foods are skipped).
  Future<int> log(MealTemplate template, MealType meal, {DateTime? at}) async {
    var logged = 0;
    for (final item in template.items) {
      final food = await _resolve(item.foodId);
      if (food == null) continue;
      await _ref.read(diaryControllerProvider.notifier).addEntry(
            food: food,
            mealType: meal,
            grams: item.grams,
            loggedAt: at,
          );
      logged++;
    }
    return logged;
  }
}

final mealTemplateLoggerProvider = Provider((ref) => MealTemplateLogger(ref));
