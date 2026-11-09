import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../utils/uuid.dart';
import 'diary_entries_table.dart';
import 'tracking_tables.dart';

part 'diary_database.g.dart';

/// Offline-first app database (drift / SQLite).
///
/// Stores diary entries plus advanced-tracking tables (weight, body
/// measurements, water) so logging works without internet.
/// Diary rows carry `syncPending` / `remoteId` for Supabase sync.
@DriftDatabase(tables: [
  DiaryEntries,
  WeightEntries,
  BodyMeasurements,
  WaterLogs,
])
class DiaryDatabase extends _$DiaryDatabase {
  DiaryDatabase() : super(_open());
  DiaryDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(weightEntries);
            await m.createTable(bodyMeasurements);
            await m.createTable(waterLogs);
          }
          if (from < 3) {
            await m.addColumn(diaryEntries, diaryEntries.remoteId);
            await m.addColumn(diaryEntries, diaryEntries.updatedAt);
            await m.addColumn(diaryEntries, diaryEntries.deletedAt);
            final rows = await select(diaryEntries).get();
            for (final row in rows) {
              await (update(diaryEntries)..where((t) => t.id.equals(row.id)))
                  .write(
                DiaryEntriesCompanion(
                  remoteId: Value(generateUuidV4()),
                  updatedAt: Value(row.createdAt),
                  syncPending: const Value(true),
                ),
              );
            }
          }
          if (from < 4) {
            await m.addColumn(diaryEntries, diaryEntries.sodiumMg);
            await m.addColumn(diaryEntries, diaryEntries.ironMg);
            await m.addColumn(diaryEntries, diaryEntries.calciumMg);
            await m.addColumn(diaryEntries, diaryEntries.potassiumMg);
            await m.addColumn(diaryEntries, diaryEntries.vitaminCMg);
          }
        },
      );

  static LazyDatabase _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'nutrivoya_diary.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
