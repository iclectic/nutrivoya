import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

void main() {
  group('LocalFoodDataset cultural coverage', () {
    test('includes foods across multiple continents/cuisines', () {
      final foods = LocalFoodDataset.all();
      expect(foods.length, greaterThanOrEqualTo(30));

      final cuisines = foods.map((f) => f.cuisine).whereType<String>().toSet();
      expect(cuisines, contains('Punjabi'));
      expect(cuisines, contains('Nigerian'));
      expect(cuisines, contains('Ethiopian'));
      expect(cuisines, contains('Vietnamese'));
      expect(cuisines, contains('Korean'));
      expect(cuisines, contains('Mexican'));
      expect(cuisines, contains('Jamaican'));
      expect(cuisines, contains('Middle Eastern'));
      expect(cuisines, contains('Eastern European'));
    });

    test('resolves aubergine/eggplant/brinjal aliases', () {
      expect(LocalFoodDataset.byId('aubergine-cooked'), isNotNull);
      final food = LocalFoodDataset.byId('aubergine-cooked')!;
      final names = food.allDisplayNames.map((n) => n.toLowerCase()).toSet();
      expect(names, contains('aubergine'));
      expect(names, contains('brinjal'));
      expect(names, contains('baingan'));
    });

    test('every food has provenance and never fabricates confidence', () {
      for (final food in LocalFoodDataset.all()) {
        expect(food.source.name, isNotEmpty);
        expect(food.nutrientsPer100g, isNotEmpty);
      }
    });
  });
}
