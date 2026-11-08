import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../utils/uuid.dart';
import 'diary_entries_table.dart';

part 'diary_database.g.dart';

/// Offline-first diary database (drift / SQLite).
///
/// Stores all diary entries locally so food logging works without internet.
/// The `syncPending` flag marks entries that need to be pushed to Supabase by
/// `DiarySyncService` when signed in and online.
@DriftDatabase(tables: [DiaryEntries])
class DiaryDatabase extends _$DiaryDatabase {
  DiaryDatabase() : super(_open());
  DiaryDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(diaryEntries, diaryEntries.remoteId);
            await m.addColumn(diaryEntries, diaryEntries.updatedAt);
            await m.addColumn(diaryEntries, diaryEntries.deletedAt);
            final rows = await select(diaryEntries).get();
            for (final row in rows) {
              await (update(diaryEntries)..where((t) => t.id.equals(row.id)))
                  .write(DiaryEntriesCompanion(
                remoteId: Value(generateUuidV4()),
                updatedAt: Value(row.createdAt),
                syncPending: const Value(true),
              ));
            }
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
