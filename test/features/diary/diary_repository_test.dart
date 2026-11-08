import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/database/diary_database.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/features/diary/diary_repository.dart';

DiaryEntry _entry({
  String foodId = 'roti',
  String foodName = 'Roti',
  MealType mealType = MealType.breakfast,
  double grams = 40,
  double kcal = 120,
  DateTime? loggedAt,
}) {
  return DiaryEntry(
    foodId: foodId,
    foodName: foodName,
    foodCanonicalName: 'Whole wheat flatbread',
    mealType: mealType,
    grams: grams,
    caloriesKcal: kcal,
    proteinG: 3.6,
    carbohydrateG: 22,
    fatG: 1.2,
    fibreG: 1.6,
    confidence: NutritionConfidence.medium,
    sourceName: 'Nutrivoya curated',
    loggedAt: loggedAt ?? DateTime(2024, 6, 15, 8, 0),
  );
}

void main() {
  late DiaryDatabase db;
  late DiaryRepository repo;

  setUp(() {
    db = DiaryDatabase.forTesting(NativeDatabase.memory());
    repo = DiaryRepository(db);
  });

  tearDown(() => db.close());

  group('DiaryRepository.add', () {
    test('inserts and returns an id', () async {
      final id = await repo.add(_entry());
      expect(id, greaterThan(0));
    });

    test('entry is retrievable by date', () async {
      await repo.add(_entry(loggedAt: DateTime(2024, 6, 15, 8, 0)));
      final entries = await repo.entriesForDate(DateTime(2024, 6, 15));
      expect(entries.length, 1);
      expect(entries.first.foodName, 'Roti');
      expect(entries.first.mealType, MealType.breakfast);
    });

    test('entries from other dates are not returned', () async {
      await repo.add(_entry(loggedAt: DateTime(2024, 6, 15, 8, 0)));
      await repo.add(_entry(loggedAt: DateTime(2024, 6, 16, 12, 0)));
      final june15 = await repo.entriesForDate(DateTime(2024, 6, 15));
      expect(june15.length, 1);
    });
  });

  group('DiaryRepository.update', () {
    test('updates grams and quantity', () async {
      await repo.add(_entry());
      final entries = await repo.entriesForDate(DateTime(2024, 6, 15));
      final entry = entries.first.copyWith(grams: 80, quantity: 2);
      final ok = await repo.update(entry);
      expect(ok, isTrue);
      final updated = await repo.entriesForDate(DateTime(2024, 6, 15));
      expect(updated.first.grams, 80);
      expect(updated.first.quantity, 2);
    });

    test('returns false for entry without id', () async {
      final ok = await repo.update(_entry());
      expect(ok, isFalse);
    });
  });

  group('DiaryRepository.delete', () {
    test('deletes an entry by id (hidden from queries)', () async {
      await repo.add(_entry());
      final entries = await repo.entriesForDate(DateTime(2024, 6, 15));
      expect(entries.length, 1);
      await repo.delete(entries.first.id!);
      final after = await repo.entriesForDate(DateTime(2024, 6, 15));
      expect(after, isEmpty);
    });
  });

  group('DiaryRepository.totalsForDate', () {
    test('sums calories and macros for the day', () async {
      await repo.add(_entry(kcal: 120, grams: 40));
      await repo.add(_entry(kcal: 300, grams: 100, mealType: MealType.lunch));
      final totals = await repo.totalsForDate(DateTime(2024, 6, 15));
      expect(totals.caloriesKcal, 420);
      expect(totals.entryCount, 2);
    });

    test('returns zero for empty day', () async {
      final totals = await repo.totalsForDate(DateTime(2024, 6, 15));
      expect(totals.caloriesKcal, 0);
      expect(totals.entryCount, 0);
    });
  });

  group('DiaryRepository.entriesForDateAndMeal', () {
    test('filters by meal type', () async {
      await repo.add(_entry(mealType: MealType.breakfast));
      await repo.add(_entry(mealType: MealType.lunch));
      await repo.add(_entry(mealType: MealType.lunch));
      final breakfast = await repo.entriesForDateAndMeal(
          DateTime(2024, 6, 15), MealType.breakfast);
      final lunch = await repo.entriesForDateAndMeal(
          DateTime(2024, 6, 15), MealType.lunch);
      expect(breakfast.length, 1);
      expect(lunch.length, 2);
    });
  });

  group('DiaryRepository.recentFoods', () {
    test('returns distinct foods by foodId, most recent first', () async {
      await repo.add(_entry(foodId: 'a', foodName: 'Apple',
          loggedAt: DateTime(2024, 6, 15, 8, 0)));
      await repo.add(_entry(foodId: 'b', foodName: 'Banana',
          loggedAt: DateTime(2024, 6, 15, 12, 0)));
      await repo.add(_entry(foodId: 'a', foodName: 'Apple',
          loggedAt: DateTime(2024, 6, 15, 18, 0)));
      final recent = await repo.recentFoods(limit: 5);
      expect(recent.length, 2);
      // Most recent first → Apple (logged at 18:00) then Banana (12:00)
      expect(recent.first.foodId, 'a');
      expect(recent.last.foodId, 'b');
    });
  });

  group('DiaryRepository.watchEntriesForDate', () {
    test('emits entries reactively', () async {
      final stream = repo.watchEntriesForDate(DateTime(2024, 6, 15));
      final firstEmission = await stream.first;
      expect(firstEmission, isEmpty);
      // Add an entry and read the next emission
      await repo.add(_entry());
      final secondEmission = await stream.first;
      expect(secondEmission.length, 1);
    });
  });

  group('DiaryRepository.pendingSyncCount', () {
    test('counts entries with syncPending=true', () async {
      await repo.add(_entry());
      await repo.add(_entry());
      final pending = await repo.pendingSyncCount();
      expect(pending, 2);
    });
  });
}
