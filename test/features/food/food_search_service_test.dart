import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_search_result.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/features/food/food_search_service.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

UserProfile profileWithCuisines(List<String> cuisines) => UserProfile(
      id: 'u',
      ageYears: 30,
      heightCm: 170,
      weightKg: 70,
      physiologicalInput: PhysiologicalInput.female,
      activityLevel: ActivityLevel.moderate,
      goal: NutritionGoal.maintainWeight,
      familiarCuisines: cuisines,
    );

void main() {
  const service = FoodSearchService();
  final foods = LocalFoodDataset.all();

  group('FoodSearchService.search', () {
    test('exact primary match ranks highest', () {
      final results = service.search('roti', foods);
      expect(results, isNotEmpty);
      expect(results.first.matchKind, SearchMatchKind.exactPrimary);
      expect(results.first.food.id, 'roti-whole-wheat');
    });

    test('exact alias match resolves synonyms', () {
      final results = service.search('chapati', foods);
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'roti-whole-wheat');
      expect(results.first.matchKind, SearchMatchKind.exactAlias);
    });

    test('transliteration alias resolves "chana" to chickpeas', () {
      final results = service.search('chana', foods);
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'chickpeas-cooked');
    });

    test('diacritic-insensitive matching', () {
      final results = service.search('Crème', foods);
      // No food named crème, but normalization should not throw.
      expect(results, isEmpty);
    });

    test('prefix match works', () {
      final results = service.search('jol', foods);
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'jollof-rice');
    });

    test('contains match works', () {
      final results = service.search('rice', foods);
      expect(results, isNotEmpty);
      // Jollof rice and white rice both contain "rice".
      final ids = results.map((r) => r.food.id).toSet();
      expect(ids, contains('rice-white-cooked'));
      expect(ids, contains('jollof-rice'));
    });

    test('empty query returns no results', () {
      expect(service.search('   ', foods), isEmpty);
    });

    test('no match returns empty', () {
      expect(service.search('xyznotfood', foods), isEmpty);
    });

    test('results are sorted by rank (exact before prefix)', () {
      final results = service.search('rice', foods);
      // Exact matches (if any) come before contains matches.
      for (var i = 1; i < results.length; i++) {
        expect(
          results[i - 1].matchKind.rank >= results[i].matchKind.rank,
          isTrue,
          reason: 'Results should be sorted by descending rank',
        );
      }
    });

    test('cuisine preference boosts familiar foods', () {
      final profile = profileWithCuisines(['Nigerian']);
      final results = service.search('rice', foods, profile: profile);
      // Nigerian jollof should be boosted over generic white rice via
      // cuisinePreferred ranking when both are contains matches.
      final jollofIndex =
          results.indexWhere((r) => r.food.id == 'jollof-rice');
      final whiteRiceIndex =
          results.indexWhere((r) => r.food.id == 'rice-white-cooked');
      expect(jollofIndex, greaterThanOrEqualTo(0));
      expect(whiteRiceIndex, greaterThanOrEqualTo(0));
      expect(jollofIndex, lessThan(whiteRiceIndex));
    });

    test('deduplicates by food id', () {
      final results = service.search('roti', foods);
      final ids = results.map((r) => r.food.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  group('LocalFoodDataset', () {
    test('all foods have unique ids', () {
      final ids = foods.map((f) => f.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('all foods have a source with confidence', () {
      for (final f in foods) {
        expect(f.source.confidence, isNot(NutritionConfidence.unknown),
            reason: '${f.id} should have a known confidence');
      }
    });

    test('all foods have at least one name', () {
      for (final f in foods) {
        expect(f.allDisplayNames, isNotEmpty);
      }
    });

    test('high-confidence foods have energy data', () {
      for (final f in foods) {
        if (f.confidence == NutritionConfidence.high) {
          expect(f.nutrientPer100g(NutrientCode.energyKcal), isNotNull,
              reason: '${f.id} (high confidence) should have kcal');
        }
      }
    });

    test('byId returns the food or null', () {
      expect(LocalFoodDataset.byId('roti-whole-wheat')?.id,
          'roti-whole-wheat');
      expect(LocalFoodDataset.byId('does-not-exist'), isNull);
    });

    test('cultural foods are clearly estimated, not high confidence', () {
      final roti = LocalFoodDataset.byId('roti-whole-wheat')!;
      expect(roti.confidence, NutritionConfidence.medium);
      final jollof = LocalFoodDataset.byId('jollof-rice')!;
      expect(jollof.confidence, NutritionConfidence.estimated);
    });
  });
}
