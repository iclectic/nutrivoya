import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_name.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/core/utils/confidence_scorer.dart';
import 'package:nutrivoya/core/utils/recipe_nutrition_calculator.dart';
import 'package:nutrivoya/features/food/data/global_food_dataset.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';
import 'package:nutrivoya/features/food/food_search_service.dart';

void main() {
  const search = FoodSearchService();
  final foods = LocalFoodDataset.all();

  group('Unicode normalization', () {
    test('Arabic tashkeel and alef forms are folded', () {
      expect(FoodName.normalize('أَرُزّ'), FoodName.normalize('ارز'));
      expect(FoodName.normalize('بامية'), FoodName.normalize('باميه'));
    });
    test('Devanagari nukta and punctuation are removed', () {
      expect(FoodName.normalize('प्याज़'), FoodName.normalize('प्याज'));
      expect(FoodName.normalize("ladies' fingers!"), 'ladies fingers');
    });
    test('phonetic key unifies transliteration variants', () {
      expect(FoodName.phoneticKey('dhal'), FoodName.phoneticKey('dal'));
      expect(FoodName.phoneticKey('daal'), FoodName.phoneticKey('dal'));
      expect(FoodName.phoneticKey('chapatti'), FoodName.phoneticKey('chapati'));
      expect(FoodName.phoneticKey('keema'), FoodName.phoneticKey('kima'));
    });
  });

  group('Multilingual search', () {
    String top(String q) => search.search(q, foods).first.food.id;
    test('finds foods by local names and scripts', () {
      expect(top('garbanzos'), 'chickpeas-cooked');
      expect(top('أرز'), 'rice-white-cooked');
      expect(top('bhindi'), 'okra-boiled');
      expect(top('yuca'), 'cassava-raw');
      expect(top('sima'), 'ugali');
      expect(top('छोले'), 'chana-masala');
    });
    test('finds romanization variants phonetically', () {
      expect(search.search('dhal', foods).map((r) => r.food.id), contains('dal-curried'));
    });
    test('recently logged foods rank first within a match kind', () {
      final ids = search
          .search('rice', foods, recentFoodIds: {'arroz-con-frijoles'})
          .map((r) => r.food.id)
          .toList();
      final kinds = search.search('rice', foods);
      final idx = ids.indexOf('arroz-con-frijoles');
      final sameKind = kinds.firstWhere((r) => r.food.id == 'arroz-con-frijoles').matchKind;
      expect(ids.indexWhere((id) =>
          kinds.firstWhere((r) => r.food.id == id).matchKind == sameKind), idx);
    });
  });

  group('RecipeNutritionCalculator', () {
    test('divides ingredient totals by cooked yield', () {
      final per100 = RecipeNutritionCalculator.per100g(
        [RecipeIngredient(GlobalFoodDataset.cornmeal, 250), RecipeIngredient(GlobalFoodDataset.water, 750)],
        cookedYieldGrams: 900,
      );
      expect(per100[NutrientCode.energyKcal]!.amountPer100g, closeTo(362 * 2.5 / 9, 0.01));
    });
    test('missing ingredient data yields null, never a guess', () {
      final per100 = RecipeNutritionCalculator.per100g([
        RecipeIngredient(GlobalFoodDataset.cornmeal, 100),
        RecipeIngredient(LocalFoodDataset.byId('dal-curried')!, 100),
      ]);
      expect(per100[NutrientCode.sodiumMg]?.amountPer100g, isNull);
      expect(per100[NutrientCode.energyKcal]!.amountPer100g, isNotNull);
    });
  });

  group('Dataset integrity', () {
    test('ids are unique and every food has provenance', () {
      final ids = foods.map((f) => f.id).toList();
      expect(ids.toSet().length, ids.length);
      for (final f in foods) {
        expect(f.source.name, isNotEmpty);
        expect(f.names, isNotEmpty, reason: f.id);
      }
    });
    test('recipe dishes list ingredients and are not marked high confidence', () {
      for (final d in GlobalFoodDataset.dishes()) {
        expect(d.ingredients, isNotEmpty);
        expect(d.source.type, FoodSourceType.recipeEstimated);
        expect(d.confidence, isNot(NutritionConfidence.high));
      }
    });
    test('covers multiple continents', () {
      final countries = foods.expand((f) => f.allCountries).toSet();
      expect(countries, containsAll(['IN', 'NG', 'KE', 'ET', 'MX', 'PE', 'LB', 'MA']));
    });
  });

  group('ConfidenceScorer', () {
    test('verified authoritative complete data is high', () {
      expect(ConfidenceScorer.forFood(GlobalFoodDataset.okra), NutritionConfidence.high);
    });
    test('user-submitted data is estimated; missing energy is unknown', () {
      expect(
        ConfidenceScorer.score(
          type: FoodSourceType.userSubmitted,
          review: ReviewStatus.unverified,
          nutrients: GlobalFoodDataset.okra.nutrientsPer100g,
        ),
        NutritionConfidence.estimated,
      );
      expect(
        ConfidenceScorer.score(type: FoodSourceType.authoritative, review: ReviewStatus.verified, nutrients: const {}),
        NutritionConfidence.unknown,
      );
    });
  });
}
