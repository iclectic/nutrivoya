import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/diary_database.dart';
import '../../core/models/diary_entry.dart';
import '../../core/models/meal_type.dart';
import '../../core/models/nutrition_confidence.dart';
import '../../core/utils/uuid.dart';

/// Repository for diary entries (offline-first, drift/SQLite).
///
/// All operations are local. Mutations set `syncPending` so `DiarySyncService`
/// can push them to Supabase; deletions are soft until synced.
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
      remoteId: Value(entry.remoteId ?? generateUuidV4()),
      updatedAt: Value(DateTime.now()),
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
      updatedAt: Value(DateTime.now()),
    );
    final rows = await (_db.update(_db.diaryEntries)
          ..where((t) => t.id.equals(entry.id!)))
        .write(companion);
    return rows > 0;
  }

  /// Delete an entry by id (soft delete until the deletion is synced).
  Future<int> delete(int id) async {
    final now = DateTime.now();
    return (_db.update(_db.diaryEntries)..where((t) => t.id.equals(id))).write(
      DiaryEntriesCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        syncPending: const Value(true),
      ),
    );
  }

  /// Rows (including soft-deleted ones) awaiting push to the backend.
  Future<List<DiaryEntryRow>> pendingRows() {
    return (_db.select(_db.diaryEntries)
          ..where((t) => t.syncPending.equals(true)))
        .get();
  }

  /// Marks pushed rows as synced and purges pushed soft-deleted rows.
  Future<void> markSynced(List<DiaryEntryRow> rows) async {
    await _db.transaction(() async {
      for (final row in rows) {
        final q = _db.diaryEntries;
        if (row.deletedAt != null) {
          await (_db.delete(q)..where((t) => t.id.equals(row.id))).go();
        } else {
          await (_db.update(q)
                ..where((t) =>
                    t.id.equals(row.id) &
                    t.updatedAt.isValue(row.updatedAt ?? row.createdAt)))
              .write(const DiaryEntriesCompanion(syncPending: Value(false)));
        }
      }
    });
  }

  /// Applies a remote change (last-write-wins against unsynced local edits).
  Future<void> applyRemote(DiaryEntriesCompanion remote) async {
    final remoteId = remote.remoteId.value!;
    final remoteUpdated = remote.updatedAt.value;
    final local = await (_db.select(_db.diaryEntries)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    if (local != null &&
        local.syncPending &&
        local.updatedAt != null &&
        remoteUpdated != null &&
        local.updatedAt!.isAfter(remoteUpdated)) {
      return;
    }
    final deleted = remote.deletedAt.present && remote.deletedAt.value != null;
    if (local == null) {
      if (deleted) return;
      await _db.into(_db.diaryEntries).insert(remote);
    } else if (deleted) {
      await (_db.delete(_db.diaryEntries)..where((t) => t.id.equals(local.id)))
          .go();
    } else {
      await (_db.update(_db.diaryEntries)..where((t) => t.id.equals(local.id)))
          .write(remote);
    }
  }

  /// Get all entries for a given date (by calendar day of [date]).
  Future<List<DiaryEntry>> entriesForDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final rows = await (_db.select(_db.diaryEntries)
          ..where((t) =>
              t.loggedAt.isBetweenValues(dayStart, dayEnd) &
              t.deletedAt.isNull())
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
          ..where((t) =>
              t.loggedAt.isBetweenValues(dayStart, dayEnd) &
              t.deletedAt.isNull())
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
          ..where((t) => t.deletedAt.isNull())
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

  /// Foods logged at least twice recently, most frequent first.
  Future<List<DiaryEntry>> frequentFoods({int limit = 8}) async {
    final rows = await (_db.select(_db.diaryEntries)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(300))
        .get();
    final counts = <String, int>{};
    final latest = <String, DiaryEntry>{};
    for (final row in rows) {
      final e = _toDomain(row);
      counts[e.foodId] = (counts[e.foodId] ?? 0) + 1;
      latest.putIfAbsent(e.foodId, () => e);
    }
    final ids = counts.keys.where((id) => counts[id]! >= 2).toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return [for (final id in ids.take(limit)) latest[id]!];
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
      remoteId: row.remoteId,
      updatedAt: row.updatedAt,
    );
  }
}
