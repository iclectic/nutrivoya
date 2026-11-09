import 'package:drift/drift.dart';

import '../../core/database/diary_database.dart';
import '../../core/models/body_measurement.dart';
import '../../core/models/water_log.dart';
import '../../core/models/weight_entry.dart';

/// Offline repository for weight, body measurements and water logs.
class TrackingRepository {
  TrackingRepository(this._db);

  final DiaryDatabase _db;

  // --- Weight ------------------------------------------------------------

  Future<int> addWeight(WeightEntry entry) {
    return _db.into(_db.weightEntries).insert(
          WeightEntriesCompanion.insert(
            weightKg: entry.weightKg,
            loggedAt: entry.loggedAt,
            note: Value(entry.note),
          ),
        );
  }

  Future<int> deleteWeight(int id) {
    return (_db.delete(_db.weightEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<List<WeightEntry>> weightEntries({int limit = 60}) async {
    final rows = await (_db.select(_db.weightEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit))
        .get();
    return rows.map(_weightToDomain).toList();
  }

  Stream<List<WeightEntry>> watchWeightEntries({int limit = 60}) {
    return (_db.select(_db.weightEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_weightToDomain).toList());
  }

  // --- Body measurements -------------------------------------------------

  Future<int> addMeasurement(BodyMeasurement entry) {
    return _db.into(_db.bodyMeasurements).insert(
          BodyMeasurementsCompanion.insert(
            loggedAt: entry.loggedAt,
            waistCm: Value(entry.waistCm),
            hipCm: Value(entry.hipCm),
            note: Value(entry.note),
          ),
        );
  }

  Future<int> deleteMeasurement(int id) {
    return (_db.delete(_db.bodyMeasurements)..where((t) => t.id.equals(id)))
        .go();
  }

  Future<List<BodyMeasurement>> measurements({int limit = 30}) async {
    final rows = await (_db.select(_db.bodyMeasurements)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit))
        .get();
    return rows.map(_measurementToDomain).toList();
  }

  Stream<List<BodyMeasurement>> watchMeasurements({int limit = 30}) {
    return (_db.select(_db.bodyMeasurements)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_measurementToDomain).toList());
  }

  // --- Water -------------------------------------------------------------

  Future<int> addWater(WaterLog entry) {
    return _db.into(_db.waterLogs).insert(
          WaterLogsCompanion.insert(
            amountMl: entry.amountMl,
            loggedAt: entry.loggedAt,
          ),
        );
  }

  Future<int> deleteWater(int id) {
    return (_db.delete(_db.waterLogs)..where((t) => t.id.equals(id))).go();
  }

  Future<DailyWater> waterForDate(DateTime date, {int goalMl = 2000}) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final rows = await (_db.select(_db.waterLogs)
          ..where(
            (t) =>
                t.loggedAt.isBiggerOrEqualValue(dayStart) &
                t.loggedAt.isSmallerThanValue(dayEnd),
          ))
        .get();
    final total = rows.fold<int>(0, (s, r) => s + r.amountMl);
    return DailyWater(
      date: dayStart,
      totalMl: total,
      entryCount: rows.length,
      goalMl: goalMl,
    );
  }

  Stream<DailyWater> watchWaterForDate(DateTime date, {int goalMl = 2000}) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (_db.select(_db.waterLogs)
          ..where(
            (t) =>
                t.loggedAt.isBiggerOrEqualValue(dayStart) &
                t.loggedAt.isSmallerThanValue(dayEnd),
          ))
        .watch()
        .map((rows) {
      final total = rows.fold<int>(0, (s, r) => s + r.amountMl);
      return DailyWater(
        date: dayStart,
        totalMl: total,
        entryCount: rows.length,
        goalMl: goalMl,
      );
    });
  }

  WeightEntry _weightToDomain(WeightEntryRow row) => WeightEntry(
        id: row.id,
        weightKg: row.weightKg,
        loggedAt: row.loggedAt,
        note: row.note,
      );

  BodyMeasurement _measurementToDomain(BodyMeasurementRow row) =>
      BodyMeasurement(
        id: row.id,
        loggedAt: row.loggedAt,
        waistCm: row.waistCm,
        hipCm: row.hipCm,
        note: row.note,
      );
}
