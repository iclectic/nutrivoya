import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/database/diary_database.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/diary/diary_repository.dart';
import 'package:nutrivoya/features/diary/sync/diary_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRemote implements DiaryRemoteDataSource {
  final Map<String, Map<String, dynamic>> rows = {};
  bool fail = false;

  @override
  Future<void> upsert(List<Map<String, dynamic>> batch) async {
    if (fail) throw Exception('offline');
    for (final r in batch) {
      rows[r['id'] as String] = r;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> changedSince(DateTime? since) async {
    return rows.values
        .where((r) =>
            since == null ||
            DateTime.parse(r['updated_at'] as String).isAfter(since))
        .toList();
  }
}

DiaryEntry _entry(String food) => DiaryEntry(
      foodId: food,
      foodName: food,
      foodCanonicalName: food,
      mealType: MealType.lunch,
      grams: 100,
      caloriesKcal: 200,
      loggedAt: DateTime(2024, 6, 15, 12),
    );

void main() {
  late DiaryDatabase db;
  late DiaryRepository repo;
  late _FakeRemote remote;
  late DiarySyncService sync;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = DiaryDatabase.forTesting(NativeDatabase.memory());
    repo = DiaryRepository(db);
    remote = _FakeRemote();
    sync = DiarySyncService(
      repository: repo,
      remote: remote,
      prefs: LocalPreferences(await SharedPreferences.getInstance()),
      userId: 'user-1',
    );
  });

  tearDown(() => db.close());

  test('pushes pending entries and clears the pending flag', () async {
    await repo.add(_entry('roti'));
    final result = await sync.sync();
    expect(result.pushed, 1);
    expect(remote.rows, hasLength(1));
    expect(remote.rows.values.first['food_id'], 'roti');
    expect(await repo.pendingSyncCount(), 0);
  });

  test('deletions are soft until pushed, then purged', () async {
    final id = await repo.add(_entry('dal'));
    await sync.sync();
    await repo.delete(id);
    expect(await repo.entriesForDate(DateTime(2024, 6, 15)), isEmpty);
    expect(await repo.pendingSyncCount(), 1);
    await sync.sync();
    expect(remote.rows.values.first['deleted_at'], isNotNull);
    expect(await repo.pendingRows(), isEmpty);
    expect(await db.select(db.diaryEntries).get(), isEmpty);
  });

  test('pulls entries created on another device', () async {
    remote.rows['11111111-1111-4111-8111-111111111111'] = {
      'id': '11111111-1111-4111-8111-111111111111',
      'food_id': 'injera',
      'food_name': 'Injera',
      'food_canonical_name': 'Injera',
      'meal_type': 'dinner',
      'grams': 120,
      'quantity': 1,
      'calories_kcal': 150.0,
      'confidence': 'medium',
      'logged_at': DateTime(2024, 6, 15, 19).toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
      'deleted_at': null,
    };
    final result = await sync.sync();
    expect(result.pulled, 1);
    final entries = await repo.entriesForDate(DateTime(2024, 6, 15));
    expect(entries.single.foodName, 'Injera');
    expect(entries.single.syncPending, isFalse);
  });

  test('failed push keeps entries pending', () async {
    await repo.add(_entry('ugali'));
    remote.fail = true;
    await sync.syncSafely();
    expect(await repo.pendingSyncCount(), 1);
  });
}
