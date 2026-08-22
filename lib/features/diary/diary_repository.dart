import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/diary_database.dart';
import '../../core/models/diary_entry.dart';
import '../../core/models/meal_type.dart';
import '../../core/models/nutrition_confidence.dart';

/// Repository for diary entries (offline-first, drift/SQLite).
///
/// All operations are local. The `syncPending` flag is set on new entries so
/// a future sync layer can push them to Supabase when connectivity returns.
class DiaryRepository {
  DiaryRepository(this._db);

  final DiaryDatabase _db;

  /// Insert a new diary entry. Returns the generated id.
  Future<int> add(DiaryEntry entry) async {
    final companion = DiaryEntriesCompanion.insert(
      foodId: entry.foodId,
      foodName: entry.foodName,
      foodCanonicalName: entry.foodCanonicalName,
      mealType: entry.mealType.id,
      grams: entry.grams,
      portionName: Value(entry.portionName),
      quantity: Value(entry.quantity),
      caloriesKcal: Value(entry.caloriesKcal),
      proteinG: Value(entry.proteinG),
      carbohydrateG: Value(entry.carbohydrateG),
      fatG: Value(entry.fatG),
      fibreG: Value(entry.fibreG),
      confidence: Value(entry.confidence.id),
      sourceName: Value(entry.sourceName),
      loggedAt: entry.loggedAt,
      syncPending: const Value(true),
    );
    return _db.into(_db.diaryEntries).insert(companion);
  }

  /// Update an existing entry (e.g. change quantity/grams).
  Future<bool> update(DiaryEntry entry) async {
    if (entry.id == null) return false;
    final companion = DiaryEntriesCompanion(
      id: Value(entry.id!),
      grams: Value(entry.grams),
      quantity: Value(entry.quantity),
      portionName: Value(entry.portionName),
      caloriesKcal: Value(entry.caloriesKcal),
      proteinG: Value(entry.proteinG),
      carbohydrateG: Value(entry.carbohydrateG),
      fatG: Value(entry.fatG),
      fibreG: Value(entry.fibreG),
      syncPending: const Value(true),
    );
    final rows = await (_db.update(_db.diaryEntries)
          ..where((t) => t.id.equals(entry.id!)))
        .write(companion);
    return rows > 0;
  }

  /// Delete an entry by id.
  Future<int> delete(int id) async {
    return (_db.delete(_db.diaryEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Get all entries for a given date (by calendar day of [date]).
  Future<List<DiaryEntry>> entriesForDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final rows = await (_db.select(_db.diaryEntries)
          ..where((t) => t.loggedAt.isBetweenValues(dayStart, dayEnd))
          ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  /// Get entries for a date + meal type.
  Future<List<DiaryEntry>> entriesForDateAndMeal(
    DateTime date,
    MealType mealType,
  ) async {
    final all = await entriesForDate(date);
    return all.where((e) => e.mealType == mealType).toList();
  }

  /// Daily totals for a given date.
  Future<DailyTotals> totalsForDate(DateTime date) async {
    final entries = await entriesForDate(date);
    return DailyTotals.fromEntries(entries);
  }

  /// Stream of entries for a date (reactive UI updates).
  Stream<List<DiaryEntry>> watchEntriesForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (_db.select(_db.diaryEntries)
          ..where((t) => t.loggedAt.isBetweenValues(dayStart, dayEnd))
          ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  /// Stream of daily totals (reactive).
  Stream<DailyTotals> watchTotalsForDate(DateTime date) {
    return watchEntriesForDate(date).map(DailyTotals.fromEntries);
  }

  /// Recent foods (distinct by foodId, most recent first), for quick re-logging.
  Future<List<DiaryEntry>> recentFoods({int limit = 10}) async {
    final rows = await (_db.select(_db.diaryEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit * 3))
        .get();
    final seen = <String>{};
    final recent = <DiaryEntry>[];
    for (final row in rows) {
      final entry = _toDomain(row);
      if (!seen.contains(entry.foodId)) {
        seen.add(entry.foodId);
        recent.add(entry);
        if (recent.length >= limit) break;
      }
    }
    return recent;
  }

  /// Count of entries pending sync.
  Future<int> pendingSyncCount() async {
    final pending = await (_db.selectOnly(_db.diaryEntries)
          ..addColumns([_db.diaryEntries.id.count()])
          ..where(_db.diaryEntries.syncPending.equals(true)))
        .map((row) => row.read(_db.diaryEntries.id.count()) ?? 0)
        .getSingle();
    if (kDebugMode) debugPrint('[Diary] pending sync=$pending');
    return pending;
  }

  DiaryEntry _toDomain(DiaryEntryRow row) {
    return DiaryEntry(
      id: row.id,
      foodId: row.foodId,
      foodName: row.foodName,
      foodCanonicalName: row.foodCanonicalName,
      mealType: MealTypeX.fromId(row.mealType),
      grams: row.grams,
      portionName: row.portionName,
      quantity: row.quantity,
      caloriesKcal: row.caloriesKcal,
      proteinG: row.proteinG,
      carbohydrateG: row.carbohydrateG,
      fatG: row.fatG,
      fibreG: row.fibreG,
      confidence: NutritionConfidenceX.fromId(row.confidence),
      sourceName: row.sourceName,
      loggedAt: row.loggedAt,
      syncPending: row.syncPending,
    );
  }
}
