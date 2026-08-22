import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/diary_database.dart';
import '../../core/models/diary_entry.dart';
import '../../core/models/food.dart';
import '../../core/models/food_portion.dart';
import '../../core/models/meal_type.dart';
import 'diary_repository.dart';

/// Provider for the drift diary database (singleton).
final diaryDatabaseProvider = Provider<DiaryDatabase>((ref) {
  final db = DiaryDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Provider for the diary repository.
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository(ref.watch(diaryDatabaseProvider));
});

/// The currently selected diary date (defaults to today).
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Reactive list of diary entries for the selected date.
final diaryEntriesProvider =
    StreamProvider.autoDispose<List<DiaryEntry>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final repo = ref.watch(diaryRepositoryProvider);
  return repo.watchEntriesForDate(date);
});

/// Reactive daily totals for the selected date.
final dailyTotalsProvider =
    StreamProvider.autoDispose<DailyTotals>((ref) {
  final date = ref.watch(selectedDateProvider);
  final repo = ref.watch(diaryRepositoryProvider);
  return repo.watchTotalsForDate(date);
});

/// Recent foods for quick re-logging.
final recentFoodsProvider = FutureProvider.autoDispose<List<DiaryEntry>>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return repo.recentFoods();
});

/// Controller for diary operations (add/update/delete).
class DiaryController extends Notifier {
  @override
  build() {}

  DiaryRepository get _repo => ref.read(diaryRepositoryProvider);

  /// Log a food entry to the diary.
  Future<int> addEntry({
    required Food food,
    required MealType mealType,
    required double grams,
    FoodPortion? portion,
    int quantity = 1,
    DateTime? loggedAt,
  }) async {
    final entry = DiaryEntry.fromFood(
      food: food,
      mealType: mealType,
      grams: grams,
      portion: portion,
      quantity: quantity,
      loggedAt: loggedAt,
    );
    final id = await _repo.add(entry);
    if (kDebugMode) debugPrint('[Diary] added entry id=$id for ${food.displayName}');
    return id;
  }

  /// Update an existing entry's quantity/grams.
  Future<void> updateEntry(DiaryEntry entry) async {
    await _repo.update(entry);
  }

  /// Delete an entry.
  Future<void> deleteEntry(int id) async {
    await _repo.delete(id);
  }
}

final diaryControllerProvider = NotifierProvider<DiaryController, void>(
  DiaryController.new,
);
