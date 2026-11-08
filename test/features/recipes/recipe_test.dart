import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';
import 'package:nutrivoya/features/food/food_providers.dart';
import 'package:nutrivoya/features/recipes/recipe.dart';
import 'package:nutrivoya/features/recipes/recipe_providers.dart';
import 'package:nutrivoya/features/recipes/recipes_screen.dart';

import '../../helpers/test_app.dart';

Recipe _stew() {
  final lentils = LocalFoodDataset.byId('lentils-cooked')!;
  final rice = LocalFoodDataset.byId('rice-white-cooked')!;
  return Recipe(
    id: 'r1',
    name: 'Family lentil rice',
    servings: 2,
    cookedYieldGrams: 300,
    ingredients: [
      RecipeIngredientLine.fromFood(lentils, 200),
      RecipeIngredientLine.fromFood(rice, 100),
    ],
  );
}

void main() {
  test('per-serving nutrition is calculated from ingredients and yield', () {
    final r = _stew();
    final lentilsKcal = LocalFoodDataset.byId('lentils-cooked')!.nutrientPer100g(NutrientCode.energyKcal)!;
    final riceKcal = LocalFoodDataset.byId('rice-white-cooked')!.nutrientPer100g(NutrientCode.energyKcal)!;
    final total = lentilsKcal * 2 + riceKcal;
    expect(r.servingGrams, 150);
    expect(r.perServing(NutrientCode.energyKcal), closeTo(total / 2, 0.01));
  });

  test('toFood exposes a loggable recipe-estimated food with a serving portion', () {
    final food = _stew().toFood();
    expect(food.id, 'recipe:r1');
    expect(food.source.type, FoodSourceType.recipeEstimated);
    expect(food.portions.single.grams, 150);
    expect(food.ingredients, hasLength(2));
  });

  test('JSON round-trip and persistence', () async {
    final c = await testContainer();
    await c.read(recipesProvider.notifier).upsert(_stew());
    final reloaded = c.read(recipeRepositoryProvider).load();
    expect(reloaded.single.name, 'Family lentil rice');
    expect(reloaded.single.perServing(NutrientCode.proteinG),
        closeTo(_stew().perServing(NutrientCode.proteinG)!, 0.001));
    expect(c.read(recipesProvider.notifier).byFoodId('recipe:r1')?.id, 'r1');
  });

  test('personal recipes appear in food search and resolve by id', () async {
    final c = await testContainer();
    await c.read(recipesProvider.notifier).upsert(_stew());
    c.listen(foodSearchResultsProvider, (_, _) {});
    c.read(foodQueryProvider.notifier).state = 'family lentil';
    final results = await c.read(foodSearchResultsProvider.future);
    expect(results.first.food.id, 'recipe:r1');
    c.listen(foodByIdProvider('recipe:r1'), (_, _) {});
    expect((await c.read(foodByIdProvider('recipe:r1').future))?.canonicalName, 'Family lentil rice');
  });

  testWidgets('build a recipe by searching ingredients and save it', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const RecipeEditorScreen(), extraRoutes: [
      GoRoute(path: '/recipes', builder: (context, state) => const Text('stub-recipes')),
    ]));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('recipe-name')), 'Okra stew');
    await tester.enterText(find.byKey(const Key('recipe-servings')), '2');
    await tester.tap(find.byKey(const Key('recipe-add-ingredient')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('recipe-ingredient-search')), 'bhindi');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('ingredient-result-okra-boiled')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('recipe-summary')), findsOneWidget);
    await tester.tap(find.byKey(const Key('recipe-save')));
    await tester.pumpAndSettle();
    final saved = c.read(recipesProvider);
    expect(saved.single.name, 'Okra stew');
    expect(saved.single.servings, 2);
    expect(find.text('stub-recipes'), findsOneWidget);
  });
}
