import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/diary_entry.dart';
import '../../core/models/meal_template.dart';
import '../../core/models/nutrition_confidence.dart';
import '../../core/storage/local_preferences.dart';

/// Offline meal-template store (SharedPreferences JSON list).
class MealTemplateRepository {
  MealTemplateRepository(this._prefs);

  static const _key = 'nutrivoya.meal_templates.v1';

  final LocalPreferences _prefs;

  List<MealTemplate> list() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (e) => MealTemplate.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      return const [];
    }
  }

  MealTemplate? getById(String id) {
    for (final t in list()) {
      if (t.id == id) return t;
    }
    return null;
  }

  Future<void> save(MealTemplate template) async {
    final templates = list().where((t) => t.id != template.id).toList();
    templates.add(template);
    templates.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _prefs.setString(
      _key,
      jsonEncode(templates.map((t) => t.toJson()).toList()),
    );
  }

  Future<void> delete(String id) async {
    final templates = list().where((t) => t.id != id).toList();
    await _prefs.setString(
      _key,
      jsonEncode(templates.map((t) => t.toJson()).toList()),
    );
  }

  /// Build a template from today's diary entries.
  static MealTemplate fromDiaryEntries({
    required String id,
    required String name,
    required List<DiaryEntry> entries,
    DateTime? now,
  }) {
    final stamp = now ?? DateTime.now();
    return MealTemplate(
      id: id,
      name: name,
      items: entries
          .map(
            (e) => MealTemplateItem(
              foodId: e.foodId,
              foodName: e.foodName,
              foodCanonicalName: e.foodCanonicalName,
              mealType: e.mealType,
              grams: e.grams,
              portionName: e.portionName,
              quantity: e.quantity,
              caloriesKcal: e.caloriesKcal,
              proteinG: e.proteinG,
              carbohydrateG: e.carbohydrateG,
              fatG: e.fatG,
              fibreG: e.fibreG,
              confidence: e.confidence.id,
              sourceName: e.sourceName,
            ),
          )
          .toList(),
      createdAt: stamp,
      updatedAt: stamp,
    );
  }
}

final mealTemplateRepositoryProvider = Provider<MealTemplateRepository>((ref) {
  return MealTemplateRepository(ref.watch(localPreferencesSyncProvider));
});
