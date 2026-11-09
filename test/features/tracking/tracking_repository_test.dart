import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/database/diary_database.dart';
import 'package:nutrivoya/core/models/body_measurement.dart';
import 'package:nutrivoya/core/models/water_log.dart';
import 'package:nutrivoya/core/models/weight_entry.dart';
import 'package:nutrivoya/features/tracking/tracking_repository.dart';

void main() {
  late DiaryDatabase db;
  late TrackingRepository repo;

  setUp(() {
    db = DiaryDatabase.forTesting(NativeDatabase.memory());
    repo = TrackingRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TrackingRepository weight', () {
    test('add and list weight entries newest first', () async {
      await repo.addWeight(
        WeightEntry(weightKg: 70, loggedAt: DateTime(2024, 6, 1)),
      );
      await repo.addWeight(
        WeightEntry(weightKg: 69.5, loggedAt: DateTime(2024, 6, 8)),
      );
      final list = await repo.weightEntries();
      expect(list, hasLength(2));
      expect(list.first.weightKg, 69.5);
    });

    test('delete weight by id', () async {
      final id = await repo.addWeight(
        WeightEntry(weightKg: 70, loggedAt: DateTime(2024, 6, 1)),
      );
      await repo.deleteWeight(id);
      expect(await repo.weightEntries(), isEmpty);
    });
  });

  group('TrackingRepository water', () {
    test('sums water for a calendar day', () async {
      final day = DateTime(2024, 6, 15);
      await repo.addWater(WaterLog(amountMl: 250, loggedAt: day.add(const Duration(hours: 8))));
      await repo.addWater(WaterLog(amountMl: 500, loggedAt: day.add(const Duration(hours: 12))));
      await repo.addWater(
        WaterLog(amountMl: 250, loggedAt: day.add(const Duration(days: 1))),
      );
      final daily = await repo.waterForDate(day);
      expect(daily.totalMl, 750);
      expect(daily.entryCount, 2);
    });
  });

  group('TrackingRepository measurements', () {
    test('stores waist and hip', () async {
      await repo.addMeasurement(
        BodyMeasurement(
          loggedAt: DateTime(2024, 6, 1),
          waistCm: 80,
          hipCm: 95,
        ),
      );
      final list = await repo.measurements();
      expect(list.single.waistCm, 80);
      expect(list.single.hipCm, 95);
    });
  });
}
