import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/assistant_models.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/nutrition_targets.dart';
import 'package:nutrivoya/core/services/nutrition_assistant_service.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

void main() {
  const service = NutritionAssistantService();

  Future<List<Food>> localLookup(String query) async {
    final q = query.toLowerCase();
    return LocalFoodDataset.all()
        .where(
          (f) => f.allDisplayNames.any((n) => n.toLowerCase().contains(q)) ||
              f.canonicalName.toLowerCase().contains(q),
        )
        .toList();
  }

  group('NutritionAssistantService intents', () {
    test('medical topics redirect without inventing advice', () async {
      final answer = await service.answer(
        'I think I have diabetes, what should I eat?',
        context: const AssistantContext(),
      );
      expect(answer.intent, AssistantIntent.medicalRedirect);
      expect(answer.showMedicalDisclaimer, isTrue);
      expect(answer.facts.containsKey('kcal'), isFalse);
      expect(answer.tipKeys, contains('assistantTipSeekProfessional'));
    });

    test('calorie lookup uses structured food data only', () async {
      final answer = await service.answer(
        'How many calories in roti?',
        context: const AssistantContext(),
        foodLookup: localLookup,
      );
      expect(answer.intent, AssistantIntent.calorieLookup);
      expect(answer.facts['kcal'], isA<int>());
      expect(answer.facts['kcal'] as int, greaterThan(0));
      expect(answer.matchedFoodName, isNotNull);
      expect(answer.citations, isNotEmpty);
      expect(answer.facts['sourceName'], isNotEmpty);
    });

    test('unknown food name does not invent calories', () async {
      final answer = await service.answer(
        'How many calories in xyzzy-not-a-food?',
        context: const AssistantContext(),
        foodLookup: (_) async => const <Food>[],
      );
      expect(answer.intent, AssistantIntent.calorieLookup);
      expect(answer.facts.containsKey('kcal'), isFalse);
      expect(answer.tipKeys, contains('assistantTipFoodNotFound'));
    });

    test('cultural staple guidance prefers modify over replace', () async {
      final answer = await service.answer(
        'Can I still eat rice while losing weight?',
        context: const AssistantContext(
          familiarCuisines: ['Nigerian'],
        ),
        foodLookup: localLookup,
      );
      expect(answer.intent, AssistantIntent.culturalStapleOk);
      expect(answer.tipKeys, contains('assistantTipModifyNotReplace'));
      expect(answer.tipKeys, contains('assistantTipNoMoralFood'));
      expect(answer.facts['staple']?.toString().toLowerCase(), 'rice');
    });

    test('protein guidance cites diary totals', () async {
      final answer = await service.answer(
        'How can I make my usual Punjabi breakfast higher in protein?',
        context: AssistantContext(
          familiarCuisines: const ['Punjabi'],
          todayTotals: const DailyTotals(proteinG: 22, entryCount: 2),
          targets: const NutritionTargets(
            calorieTargetKcal: 1800,
            proteinTargetG: 90,
          ),
        ),
      );
      expect(answer.intent, AssistantIntent.raiseProtein);
      expect(answer.facts['proteinConsumed'], 22);
      expect(answer.facts['proteinTarget'], 90);
      expect(answer.facts['proteinGap'], 68);
      expect(answer.facts['cuisine'], 'Punjabi');
      expect(answer.tipKeys, contains('assistantTipProteinPairDal'));
    });

    test('hunger uses logged macros without moralizing', () async {
      final answer = await service.answer(
        "Why am I still hungry even though I'm hitting my calorie target?",
        context: const AssistantContext(
          todayTotals: DailyTotals(
            caloriesKcal: 1750,
            proteinG: 40,
            fibreG: 8,
            entryCount: 4,
          ),
          targets: NutritionTargets(
            calorieTargetKcal: 1800,
            proteinTargetG: 100,
          ),
        ),
      );
      expect(answer.intent, AssistantIntent.hunger);
      expect(answer.facts['caloriesConsumed'], 1750);
      expect(answer.tipKeys, contains('assistantTipNoMoralFood'));
      expect(answer.tipKeys, contains('assistantTipHungerProteinFibre'));
    });

    test('meal balance cites diary and targets', () async {
      final answer = await service.answer(
        'How can I balance today\'s meals?',
        context: const AssistantContext(
          todayTotals: DailyTotals(
            caloriesKcal: 900,
            proteinG: 30,
            fibreG: 5,
            entryCount: 2,
          ),
          targets: NutritionTargets(
            calorieTargetKcal: 2000,
            proteinTargetG: 110,
          ),
        ),
      );
      expect(answer.intent, AssistantIntent.mealBalance);
      expect(answer.citations.length, greaterThanOrEqualTo(2));
      expect(answer.tipKeys, contains('assistantTipModifyNotReplace'));
    });

    test('generic substitution prefers modification tips', () async {
      final answer = await service.answer(
        'What is a good substitute for fried snacks?',
        context: const AssistantContext(familiarCuisines: ['Punjabi']),
      );
      expect(answer.intent, AssistantIntent.foodSubstitute);
      expect(answer.tipKeys.first, 'assistantTipModifyNotReplace');
      expect(answer.facts.containsKey('kcal'), isFalse);
    });

    test('empty question returns unknown with starter tips', () async {
      final answer = await service.answer(
        '   ',
        context: const AssistantContext(),
      );
      expect(answer.intent, AssistantIntent.unknown);
      expect(answer.tipKeys, isNotEmpty);
    });
  });
}
