import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/weight_entry.dart';
import 'package:nutrivoya/core/services/weight_trend_service.dart';

void main() {
  const service = WeightTrendService();

  WeightEntry w(double kg, int day) => WeightEntry(
        weightKg: kg,
        loggedAt: DateTime(2024, 6, day),
      );

  group('WeightTrendService', () {
    test('empty list is insufficient', () {
      final t = service.analyze(const []);
      expect(t.direction, WeightTrendDirection.insufficientData);
      expect(t.entryCount, 0);
    });

    test('fewer than 3 entries is insufficient but reports average', () {
      final t = service.analyze([w(70, 1), w(70.2, 2)]);
      expect(t.direction, WeightTrendDirection.insufficientData);
      expect(t.averageKg, isNotNull);
      expect(t.latestKg, 70.2);
    });

    test('steady weights stay within steady band', () {
      final t = service.analyze([
        w(70.0, 1),
        w(70.05, 4),
        w(69.95, 8),
        w(70.1, 12),
        w(70.0, 16),
      ]);
      expect(t.direction, WeightTrendDirection.steady);
      expect(t.averageKg, closeTo(70.0, 0.2));
    });

    test('clear rise reports rising with positive weekly change', () {
      final t = service.analyze([
        w(70.0, 1),
        w(70.4, 5),
        w(70.8, 9),
        w(71.2, 13),
        w(71.6, 17),
      ]);
      expect(t.direction, WeightTrendDirection.rising);
      expect(t.weeklyChangeKg, greaterThan(0.15));
    });

    test('clear fall reports falling', () {
      final t = service.analyze([
        w(72.0, 1),
        w(71.6, 5),
        w(71.2, 9),
        w(70.8, 13),
        w(70.4, 17),
      ]);
      expect(t.direction, WeightTrendDirection.falling);
      expect(t.weeklyChangeKg, lessThan(-0.15));
    });
  });
}
