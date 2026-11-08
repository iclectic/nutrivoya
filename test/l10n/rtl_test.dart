import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';
import 'package:nutrivoya/features/food_details/food_details_screen.dart';
import 'package:nutrivoya/features/recipes/recipe.dart';
import 'package:nutrivoya/features/recipes/recipe_providers.dart';
import 'package:nutrivoya/features/recipes/recipes_screen.dart';

import '../helpers/test_app.dart';

void main() {
  const ar = Locale('ar');

  test('foods show names in the UI language when available', () {
    final rice = LocalFoodDataset.byId('rice-white-cooked')!;
    expect(rice.nameFor('ar'), 'أرز');
    expect(rice.nameFor('hi'), 'चावल');
    expect(rice.nameFor('xx'), rice.displayName);
  });

  testWidgets('recipes screen lays out right-to-left in Arabic', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await c.read(recipesProvider.notifier).upsert(Recipe(
          id: 'r',
          name: 'كشري',
          servings: 2,
          ingredients: [RecipeIngredientLine.fromFood(LocalFoodDataset.byId('lentils-cooked')!, 200)],
        ));
    await tester.pumpWidget(testApp(c, const RecipesScreen(), locale: ar));
    await tester.pumpAndSettle();
    expect(find.text('وصفاتي'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('كشري'))), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });

  testWidgets('recipe editor renders in Arabic without overflow', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const RecipeEditorScreen(), locale: ar));
    await tester.pumpAndSettle();
    expect(Directionality.of(tester.element(find.byKey(const Key('recipe-name')))), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });

  testWidgets('food details shows the Arabic food name in RTL', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const FoodDetailsScreen(foodId: 'rice-white-cooked'), locale: ar));
    await tester.pumpAndSettle();
    expect(find.text('أرز'), findsWidgets);
    expect(Directionality.of(tester.element(find.text('أرز').first)), TextDirection.rtl);
    expect(tester.takeException(), isNull);
    await settleStreams(tester);
  });
}
