import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/nutrition_targets.dart';
import 'package:nutrivoya/features/assistant/assistant_screen.dart';
import 'package:nutrivoya/features/assistant/nutrition_assistant.dart';
import 'package:nutrivoya/features/food/data/global_food_dataset.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

import '../../helpers/test_app.dart';

void main() {
  const a = NutritionAssistant();
  final foods = LocalFoodDataset.all();

  test('high-risk topics are detected before any guidance', () {
    expect(a.safetyTopics('I want to purge after dinner'), contains(SafetyTopic.eatingDisorder));
    expect(a.safetyTopics('I am pregnant, what should I eat'), contains(SafetyTopic.pregnancy));
    expect(a.safetyTopics('How do I adjust insulin'), contains(SafetyTopic.medication));
    expect(a.safetyTopics('how is my day'), isEmpty);
  });

  test('intents are classified deterministically', () {
    expect(a.classify('How is my day going?'), AssistantIntent.dayReview);
    expect(a.classify('Swap ideas for jollof rice'), AssistantIntent.swapIdeas);
    expect(a.classify('Tell me about injera'), AssistantIntent.foodInsight);
    expect(a.classify('Balance my next meal'), AssistantIntent.balanceMeal);
    expect(a.foodQuery('Tell me about injera'), 'injera');
  });

  test('highlights are factual and derived only from known values', () {
    expect(a.highlights(GlobalFoodDataset.blackBeans), containsAll([FoodHighlight.highProtein, FoodHighlight.highFibre]));
    expect(a.highlights(GlobalFoodDataset.vegetableOil), contains(FoodHighlight.energyDense));
    final insight = a.insight(LocalFoodDataset.byId('jollof-rice')!);
    expect(insight.perServing.values.whereType<double>(), isNotEmpty);
  });

  test('meal balance suggests protein ideas, familiar cuisines first', () {
    const targets = NutritionTargets(calorieTargetKcal: 2000, proteinTargetG: 100, fibreTargetG: 30);
    final totals = DailyTotals.fromEntries(const []);
    final b = a.balance(totals, targets, foods, null);
    expect(b.proteinGapG, 100);
    expect(b.proteinIdeas, hasLength(3));
    expect(b.fibreIdeas, isNotEmpty);
  });

  test('swaps stay within the same food tradition', () {
    final ugali = foods.firstWhere((f) => f.id == 'ugali');
    for (final s in a.swaps(ugali, foods)) {
      expect(s.food.allCountries.intersection(ugali.allCountries).isNotEmpty ||
          s.food.cuisine == ugali.cuisine || s.food.region == ugali.region, isTrue);
    }
  });

  testWidgets('assistant answers day review and refers safety topics', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const AssistantScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('assistant-day')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nothing logged yet'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('assistant-input')), 'should I make myself sick after eating');
    await tester.tap(find.byKey(const Key('assistant-send')));
    await tester.pumpAndSettle();
    expect(find.textContaining('qualified professional'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('assistant-input')), 'tell me about injera');
    await tester.tap(find.byKey(const Key('assistant-send')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Injera'), findsWidgets);
    expect(find.textContaining('Nutrivoya standard recipe'), findsOneWidget);
    await settleStreams(tester);
  });
}
