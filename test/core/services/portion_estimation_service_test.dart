import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_portion.dart';
import 'package:nutrivoya/core/services/portion_estimation_service.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

void main() {
  const service = PortionEstimationService();

  group('PortionEstimationService', () {
    test('estimate prefers medium portion and marks as estimate', () {
      final roti = LocalFoodDataset.byId('roti-whole-wheat')!;
      final estimate = service.estimate(roti);
      expect(estimate.isEstimate, isTrue);
      expect(estimate.grams, greaterThan(0));
      expect(
        estimate.portion?.sizeClass,
        anyOf(PortionSizeClass.medium, isNull),
      );
    });

    test('options expose multiple sizes without inventing kcal', () {
      final roti = LocalFoodDataset.byId('roti-whole-wheat')!;
      final opts = service.options(roti);
      expect(opts.length, greaterThanOrEqualTo(2));
      expect(opts.every((o) => o.isEstimate), isTrue);
    });

    test('food without portions falls back to defaultServingGrams', () {
      final food = LocalFoodDataset.all().firstWhere(
        (f) => f.portions.isEmpty,
        orElse: () => LocalFoodDataset.all().first,
      );
      final estimate = service.estimate(food);
      expect(estimate.isEstimate, isTrue);
      expect(estimate.grams, greaterThan(0));
    });
  });
}
