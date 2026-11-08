import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/features/diary/diary_providers.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';
import 'package:nutrivoya/features/food_details/food_details_screen.dart';
import 'package:nutrivoya/features/tracking/progress_screen.dart';
import 'package:nutrivoya/features/tracking/tracking_models.dart';
import 'package:nutrivoya/features/tracking/tracking_providers.dart';

import '../../helpers/test_app.dart';

void main() {
  test('weight trend averages recent entries and reports weekly rate over 7+ days', () {
    final start = DateTime(2026, 1, 1);
    final entries = [for (var i = 0; i < 15; i++) WeightEntry(start.add(Duration(days: i)), 80 - i * 0.05)];
    final t = weightTrend(entries)!;
    expect(t.changeKgPerWeek, closeTo(-0.35, 0.001));
    expect(t.recentAverageKg, closeTo(80 - 11 * 0.05, 0.001));
    expect(weightTrend([WeightEntry(start, 70)])!.changeKgPerWeek, isNull);
    expect(weightTrend(const []), isNull);
  });

  test('tracking data persists on device', () async {
    final c = await testContainer();
    await c.read(waterProvider.notifier).add(250);
    await c.read(waterProvider.notifier).add(250);
    await c.read(favouritesProvider.notifier).toggle('banana', 'Banana');
    await c.read(weightLogProvider.notifier).add(72.5);
    final store = c.read(jsonStoreProvider);
    expect(WaterController(store).forDay(DateTime.now()), 500);
    expect(FavouritesController(store).state, {'banana': 'Banana'});
    expect(WeightLogController(store).state.single.kg, 72.5);
    await c.read(favouritesProvider.notifier).toggle('banana', 'Banana');
    expect(c.read(favouritesProvider), isEmpty);
  });

  test('frequent foods and meal templates', () async {
    final c = await testContainer();
    final diary = c.read(diaryControllerProvider.notifier);
    final banana = LocalFoodDataset.byId('banana')!;
    final today = DateTime.now();
    await diary.addEntry(food: banana, mealType: MealType.breakfast, grams: 120, loggedAt: today);
    await diary.addEntry(food: banana, mealType: MealType.snacks, grams: 100, loggedAt: today);
    final frequent = await c.read(diaryRepositoryProvider).frequentFoods();
    expect(frequent.single.foodId, 'banana');

    final template = MealTemplate(
      id: 't1',
      name: 'Usual breakfast',
      mealType: MealType.breakfast,
      items: const [TemplateItem('banana', 'Banana', 120), TemplateItem('rice-white-cooked', 'Rice', 150)],
    );
    await c.read(mealTemplatesProvider.notifier).add(template);
    expect(MealTemplatesController(c.read(jsonStoreProvider)).state.single.items, hasLength(2));
    final logged = await c.read(mealTemplateLoggerProvider).log(template, MealType.lunch, at: today);
    expect(logged, 2);
    final entries = await c.read(diaryRepositoryProvider).watchEntriesForDate(today).first;
    expect(entries.where((e) => e.mealType == MealType.lunch), hasLength(2));
  });

  testWidgets('progress screen logs weight and water', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const ProgressScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('progress-weight')), '70');
    await tester.tap(find.byKey(const Key('progress-weight-add')));
    await tester.pumpAndSettle();
    expect(find.text('70.0 kg'), findsOneWidget);
    expect(find.byKey(const Key('progress-trend')), findsOneWidget);
    await tester.tap(find.byKey(const Key('progress-water-add')));
    await tester.pumpAndSettle();
    expect(find.text('250 ml today'), findsOneWidget);
    await settleStreams(tester);
  });

  testWidgets('food details can be favourited', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const FoodDetailsScreen(foodId: 'banana')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('food-favourite')));
    await tester.pumpAndSettle();
    expect(c.read(favouritesProvider).containsKey('banana'), isTrue);
    await settleStreams(tester);
  });
}
