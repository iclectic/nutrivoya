import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'diary_entries_table.dart';

part 'diary_database.g.dart';

/// Offline-first diary database (drift / SQLite).
///
/// Stores all diary entries locally so food logging works without internet.
/// The `syncPending` flag marks entries that need to be pushed to Supabase
/// when connectivity returns (sync wiring is a later milestone).
@DriftDatabase(tables: [DiaryEntries])
class DiaryDatabase extends _$DiaryDatabase {
  DiaryDatabase() : super(_open());
  DiaryDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static LazyDatabase _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'nutrivoya_diary.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
