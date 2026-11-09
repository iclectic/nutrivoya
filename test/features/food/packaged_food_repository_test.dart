import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/food_name.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/features/food/data/packaged_food_repository.dart';
import 'package:nutrivoya/features/food/food_repository.dart';
import 'package:nutrivoya/features/food/food_search_service.dart';

class _FakePackagedRepo implements PackagedFoodRepository {
  _FakePackagedRepo(this.food);
  final Food? food;
  int calls = 0;

  @override
  Future<Food?> lookupBarcode(String barcode) async {
    calls++;
    return food;
  }
}

Food _sampleOffFood() {
  return Food(
    id: 'off:3017620422003',
    canonicalName: 'Nutella (Ferrero)',
    foodType: FoodType.single,
    names: [
      FoodName(name: 'Nutella', languageCode: 'en'),
    ],
    nutrientsPer100g: {
      NutrientCode.energyKcal: const NutrientAmount(
        code: NutrientCode.energyKcal,
        amountPer100g: 539,
      ),
    },
    source: const FoodSource(
      type: FoodSourceType.packaged,
      name: 'Open Food Facts',
      reference: '3017620422003',
      confidence: NutritionConfidence.medium,
    ),
  );
}

void main() {
  group('CompositeFoodRepository packaged integration', () {
    test('search resolves barcode queries via packaged repo', () async {
      final packaged = _FakePackagedRepo(_sampleOffFood());
      final repo = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        packagedFoodRepository: packaged,
      );

      final results = await repo.search('3017620422003');
      expect(packaged.calls, 1);
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'off:3017620422003');
    });

    test('getById resolves off: ids', () async {
      final packaged = _FakePackagedRepo(_sampleOffFood());
      final repo = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        packagedFoodRepository: packaged,
      );

      final food = await repo.getById('off:3017620422003');
      expect(food?.canonicalName, contains('Nutella'));
    });

    test('non-barcode queries do not hit packaged repo', () async {
      final packaged = _FakePackagedRepo(_sampleOffFood());
      final repo = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        packagedFoodRepository: packaged,
      );

      await repo.search('roti');
      expect(packaged.calls, 0);
    });
  });
}
