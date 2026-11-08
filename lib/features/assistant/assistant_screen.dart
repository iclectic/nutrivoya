import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/models/diary_entry.dart';
import '../../core/models/food.dart';
import '../../core/models/nutrient.dart';
import '../diary/diary_providers.dart';
import '../food/data/local_food_dataset.dart';
import '../food/food_providers.dart';
import '../goals/targets_providers.dart';
import '../profile/profile_controller.dart';
import '../recipes/recipe_providers.dart';
import '../recipes/recipes_screen.dart';
import 'nutrition_assistant.dart';

final nutritionAssistantProvider = Provider((ref) => const NutritionAssistant());

String _r(double? v) => v == null ? '—' : v.round().toString();

class _Message {
  const _Message(this.fromUser, this.lines);
  final bool fromUser;
  final List<String> lines;
}

/// "Ask Nutrivoya": structured-data guidance, not a generative chatbot.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _input = TextEditingController();
  final _messages = <_Message>[];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  NutritionAssistant get _engine => ref.read(nutritionAssistantProvider);

  List<Food> _candidates() => [
        ...LocalFoodDataset.all(),
        ...ref.read(recipesProvider).map((r) => r.toFood()),
      ];

  void _add(bool fromUser, List<String> lines) => setState(() => _messages.add(_Message(fromUser, lines)));

  Future<DailyTotals> _totals() async {
    final date = ref.read(selectedDateProvider);
    return ref.read(diaryRepositoryProvider).totalsForDate(date);
  }

  Future<void> _ask(AssistantIntent intent, {String? text, Food? food}) async {
    final l10n = AppLocalizations.of(context);
    if (text != null) _add(true, [text]);
    switch (intent) {
      case AssistantIntent.dayReview:
        final t = await _totals();
        final targets = ref.read(nutritionTargetsProvider);
        if (t.entryCount == 0) {
          _add(false, [l10n.assistantDayEmpty]);
        } else if (targets.calorieTargetKcal == null) {
          _add(false, [l10n.assistantDayNoTargets(_r(t.caloriesKcal), _r(t.proteinG), _r(t.fibreG))]);
        } else {
          _add(false, [
            l10n.assistantDaySummary(_r(t.caloriesKcal), _r(targets.calorieTargetKcal), _r(t.proteinG),
                _r(targets.proteinTargetG), _r(t.fibreG), _r(targets.fibreTargetG)),
          ]);
        }
      case AssistantIntent.balanceMeal:
        final targets = ref.read(nutritionTargetsProvider);
        if (targets.proteinTargetG == null) {
          _add(false, [l10n.assistantBalanceNoTargets]);
          break;
        }
        final b = _engine.balance(await _totals(), targets, _candidates(), ref.read(profileControllerProvider));
        if (b.onTrack) {
          _add(false, [l10n.assistantBalanceOnTrack]);
          break;
        }
        _add(false, [
          if (b.proteinGapG != null) ...[
            l10n.assistantBalanceProtein(_r(b.proteinGapG)),
            for (final f in b.proteinIdeas) '• ${f.nameFor(l10n.localeName)}',
          ],
          if (b.fibreGapG != null) ...[
            l10n.assistantBalanceFibre(_r(b.fibreGapG)),
            for (final f in b.fibreIdeas) '• ${f.nameFor(l10n.localeName)}',
          ],
        ]);
      case AssistantIntent.foodInsight:
      case AssistantIntent.swapIdeas:
        final chosen = food ?? await _pickFood();
        if (chosen == null || !mounted) return;
        intent == AssistantIntent.foodInsight ? _insight(l10n, chosen) : _swaps(l10n, chosen);
      case AssistantIntent.unknown:
        _add(false, [l10n.assistantUnknown]);
    }
  }

  void _insight(AppLocalizations l10n, Food food) {
    final i = _engine.insight(food);
    final p = i.perServing;
    final places = [food.cuisine, food.region].whereType<String>().join(', ');
    _add(false, [
      l10n.assistantFoodSummary(food.nameFor(l10n.localeName), _r(i.servingGrams), _r(p[NutrientCode.energyKcal]),
          _r(p[NutrientCode.proteinG]), _r(p[NutrientCode.carbohydrateG]), _r(p[NutrientCode.fatG])),
      for (final h in i.highlights) _highlight(l10n, h),
      if (i.hasMissingValues) l10n.assistantFoodUnavailable,
      if (places.isNotEmpty) l10n.assistantFoodCulture(places),
      l10n.assistantFoodSource(food.source.name, food.confidence.name),
    ]);
  }

  void _swaps(AppLocalizations l10n, Food food) {
    final ideas = _engine.swaps(food, _candidates());
    if (ideas.isEmpty) {
      _add(false, [l10n.assistantSwapNone]);
      return;
    }
    _add(false, [
      l10n.assistantSwapIntro,
      for (final s in ideas)
        switch (s.reason) {
          SwapReason.moreFibre => l10n.assistantSwapMoreFibre(s.food.nameFor(l10n.localeName)),
          SwapReason.moreProtein => l10n.assistantSwapMoreProtein(s.food.nameFor(l10n.localeName)),
          SwapReason.lighter => l10n.assistantSwapLighter(s.food.nameFor(l10n.localeName)),
        },
    ]);
  }

  String _highlight(AppLocalizations l10n, FoodHighlight h) => switch (h) {
        FoodHighlight.highProtein => l10n.assistantHighlightHighProtein,
        FoodHighlight.sourceOfProtein => l10n.assistantHighlightSourceProtein,
        FoodHighlight.highFibre => l10n.assistantHighlightHighFibre,
        FoodHighlight.sourceOfFibre => l10n.assistantHighlightSourceFibre,
        FoodHighlight.energyDense => l10n.assistantHighlightEnergyDense,
        FoodHighlight.lowEnergyDensity => l10n.assistantHighlightLight,
        FoodHighlight.highSodium => l10n.assistantHighlightHighSodium,
      };

  Future<Food?> _pickFood() => showDialog<Food>(context: context, builder: (_) => const FoodPickerDialog());

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    final topics = _engine.safetyTopics(text);
    if (topics.isNotEmpty) {
      _add(true, [text]);
      _add(false, [
        if (topics.contains(SafetyTopic.eatingDisorder)) l10n.assistantSafetyEatingDisorder,
        l10n.assistantSafety,
      ]);
      return;
    }
    final intent = _engine.classify(text);
    Food? food;
    if (intent == AssistantIntent.foodInsight || intent == AssistantIntent.swapIdeas) {
      final q = _engine.foodQuery(text);
      if (q.isNotEmpty) {
        final results = await ref.read(foodRepositoryProvider).search(q);
        if (results.isNotEmpty) food = results.first.food;
      }
    }
    await _ask(intent, text: text, food: food);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final caution = _engine.profileNeedsCaution(ref.watch(profileControllerProvider));
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.assistantTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l10n.assistantIntro, style: Theme.of(context).textTheme.bodyMedium),
                if (caution)
                  Card(
                    color: scheme.tertiaryContainer,
                    child: ListTile(leading: const Icon(Icons.health_and_safety_outlined), title: Text(l10n.assistantProfileCaution)),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (key, label, intent) in [
                      ('assistant-day', l10n.assistantAskDay, AssistantIntent.dayReview),
                      ('assistant-balance', l10n.assistantAskBalance, AssistantIntent.balanceMeal),
                      ('assistant-food', l10n.assistantAskFood, AssistantIntent.foodInsight),
                      ('assistant-swap', l10n.assistantAskSwap, AssistantIntent.swapIdeas),
                    ])
                      ActionChip(key: Key(key), label: Text(label), onPressed: () => _ask(intent, text: label)),
                  ],
                ),
                for (final m in _messages)
                  Align(
                    alignment: m.fromUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                    child: Card(
                      color: m.fromUser ? scheme.primaryContainer : scheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [for (final l in m.lines) Text(l)],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                key: const Key('assistant-input'),
                controller: _input,
                decoration: InputDecoration(
                  hintText: l10n.assistantInputHint,
                  suffixIcon: IconButton(key: const Key('assistant-send'), icon: const Icon(Icons.send), onPressed: _submit),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
