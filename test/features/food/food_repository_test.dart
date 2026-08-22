import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/features/food/food_repository.dart';
import 'package:nutrivoya/features/food/food_search_service.dart';

void main() {
  group('LocalFoodRepository', () {
    final repo = LocalFoodRepository();

    test('search returns ranked results', () async {
      final results = await repo.search('roti');
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'roti-whole-wheat');
    });

    test('search with empty query returns nothing', () async {
      expect(await repo.search(''), isEmpty);
    });

    test('getById returns food for known id', () async {
      final food = await repo.getById('roti-whole-wheat');
      expect(food, isNotNull);
      expect(food!.id, 'roti-whole-wheat');
    });

    test('getById returns null for unknown id', () async {
      expect(await repo.getById('nope'), isNull);
    });

    test('search resolves multilingual alias', () async {
      final results = await repo.search('chana');
      expect(results.first.food.id, 'chickpeas-cooked');
    });
  });

  group('CompositeFoodRepository', () {
    test('works without USDA adapter (offline)', () async {
      final repo = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        usdaAdapter: null,
      );
      final results = await repo.search('jollof');
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'jollof-rice');
    });

    test('getById resolves local ids', () async {
      final repo = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        usdaAdapter: null,
      );
      final food = await repo.getById('rice-white-cooked');
      expect(food?.id, 'rice-white-cooked');
    });

    test('getById returns null for usda: ids when adapter is absent',
        () async {
      final repo = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        usdaAdapter: null,
      );
      expect(await repo.getById('usda:12345'), isNull);
    });
  });
}
