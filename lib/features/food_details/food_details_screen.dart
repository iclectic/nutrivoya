import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/food.dart';
import '../../core/models/food_portion.dart';
import '../../core/models/meal_type.dart';
import '../../core/models/nutrient.dart';
import '../../core/models/nutrition_confidence.dart';
import '../../core/utils/nutrition_calculator.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../diary/diary_providers.dart';
import '../food/food_providers.dart';
import '../tracking/tracking_providers.dart';
import 'portion_selector.dart';

/// Food details screen — the "Food Result Card" plus portion selection.
///
/// Shows name, portion, ≈kcal, macros, fibre, confidence and source note.
/// "Add to Meal" opens a meal-type picker and logs the entry to the diary.
class FoodDetailsScreen extends ConsumerStatefulWidget {
  const FoodDetailsScreen({super.key, required this.foodId});

  final String foodId;

  @override
  ConsumerState<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends ConsumerState<FoodDetailsScreen> {
  double _selectedGrams = 100;
  FoodPortion? _selectedPortion;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final foodAsync = ref.watch(foodByIdProvider(widget.foodId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodDetailsTitle),
        actions: [
          Builder(builder: (context) {
            final fav = ref.watch(favouritesProvider).containsKey(widget.foodId);
            return IconButton(
              key: const Key('food-favourite'),
              tooltip: fav ? l10n.favouriteRemove : l10n.favouriteAdd,
              icon: Icon(fav ? Icons.star : Icons.star_outline),
              onPressed: () => ref.read(favouritesProvider.notifier).toggle(
                    widget.foodId,
                    foodAsync.valueOrNull?.displayName ?? widget.foodId,
                  ),
            );
          }),
        ],
      ),
      body: foodAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonError)),
        data: (food) {
          if (food == null) {
            return Center(child: Text(l10n.foodDetailsNoData));
          }
          return _FoodDetailsBody(
            food: food,
            grams: _selectedGrams,
            portion: _selectedPortion,
            quantity: _quantity,
            onSelectionChanged: (grams, portion, quantity) {
              setState(() {
                _selectedGrams = grams;
                _selectedPortion = portion;
                _quantity = quantity;
              });
            },
          );
        },
      ),
    );
  }
}

class _FoodDetailsBody extends ConsumerWidget {
  const _FoodDetailsBody({
    required this.food,
    required this.grams,
    required this.portion,
    required this.quantity,
    required this.onSelectionChanged,
  });

  final Food food;
  final double grams;
  final FoodPortion? portion;
  final int quantity;
  final void Function(double grams, FoodPortion? portion, int quantity)
      onSelectionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scaled = NutritionCalculator.forGrams(food, grams);
    final kcal = scaled[NutrientCode.energyKcal]?.amountPer100g;
    final hasEnergy = kcal != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Header(food: food, l10n: l10n),
        const SizedBox(height: 16),
        PortionSelector(
          food: food,
          onChanged: (sel) =>
              onSelectionChanged(sel.grams, sel.portion, sel.quantity),
        ),
        const SizedBox(height: 24),
        _EnergyCard(
          kcal: NutritionCalculator.roundKcal(kcal),
          hasEnergy: hasEnergy,
          l10n: l10n,
        ),
        const SizedBox(height: 16),
        _MacroGrid(scaled: scaled, l10n: l10n),
        const SizedBox(height: 16),
        _ConfidenceCard(food: food, l10n: l10n),
        const SizedBox(height: 16),
        if (_hasMicronutrients(scaled)) ...[
          _MicronutrientList(scaled: scaled, l10n: l10n),
          const SizedBox(height: 16),
        ],
        _SourceCard(food: food, l10n: l10n),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => _showMealPicker(context, ref),
          icon: const Icon(Icons.add),
          label: Text(l10n.foodDetailsAddToMeal),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showMealPicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.diaryAddToMealTitle,
                    style: Theme.of(sheetContext).textTheme.titleMedium),
              ),
              ...mealTypeDisplayOrder.map((meal) {
                return ListTile(
                  leading: Icon(_mealIcon(meal)),
                  title: Text(_mealLabel(meal, l10n)),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _logEntry(context, ref, meal);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logEntry(
    BuildContext context,
    WidgetRef ref,
    MealType meal,
  ) async {
    final l10n = context.l10n;
    await ref.read(diaryControllerProvider.notifier).addEntry(
          food: food,
          mealType: meal,
          grams: grams,
          portion: portion,
          quantity: quantity,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.diaryEntryAdded(food.nameFor(Localizations.localeOf(context).languageCode), _mealLabel(meal, l10n)),
          ),
          action: SnackBarAction(
            label: l10n.navDiary,
            onPressed: () => context.go('/diary'),
          ),
        ),
      );
      context.go('/home');
    }
  }

  IconData _mealIcon(MealType meal) {
    switch (meal) {
      case MealType.breakfast:
        return Icons.wb_sunny_outlined;
      case MealType.lunch:
        return Icons.lunch_dining_outlined;
      case MealType.dinner:
        return Icons.dinner_dining_outlined;
      case MealType.snacks:
        return Icons.cookie_outlined;
    }
  }

  String _mealLabel(MealType meal, AppLocalizations l10n) {
    switch (meal.l10nKey) {
      case 'diaryMealBreakfast':
        return l10n.diaryMealBreakfast;
      case 'diaryMealLunch':
        return l10n.diaryMealLunch;
      case 'diaryMealDinner':
        return l10n.diaryMealDinner;
      default:
        return l10n.diaryMealSnacks;
    }
  }

  bool _hasMicronutrients(Map<NutrientCode, NutrientAmount> scaled) {
    const micros = [
      NutrientCode.sodiumMg,
      NutrientCode.ironMg,
      NutrientCode.calciumMg,
      NutrientCode.potassiumMg,
      NutrientCode.vitaminCMg,
    ];
    return micros.any((c) => scaled[c]?.amountPer100g != null);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.food, required this.l10n});
  final Food food;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final aliases = food.names
        .where((n) => n.nameType.name == 'alias' || n.nameType.name == 'transliteration')
        .map((n) => n.name)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(food.nameFor(Localizations.localeOf(context).languageCode), style: Theme.of(context).textTheme.headlineSmall),
        if (food.canonicalName != food.nameFor(Localizations.localeOf(context).languageCode))
          Text(food.canonicalName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
        if (food.cuisine != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              if (food.cuisine != null) Chip(label: Text(food.cuisine!)),
              if (food.region != null) Chip(label: Text('${l10n.foodDetailsRegion}: ${food.region}')),
              if (food.preparationMethod != null) Chip(label: Text(food.preparationMethod!)),
              for (final c in food.culturalContexts) Chip(label: Text(c)),
            ],
          ),
        ],
        if (aliases.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('${l10n.foodDetailsAliases}: ${aliases.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
        ],
      ],
    );
  }
}

class _EnergyCard extends StatelessWidget {
  const _EnergyCard({required this.kcal, required this.hasEnergy, required this.l10n});
  final int kcal;
  final bool hasEnergy;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              hasEnergy ? '${l10n.foodDetailsApprox} $kcal ${l10n.nutrientEnergyKcal.toLowerCase()}' : l10n.foodDetailsNoData,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroGrid extends StatelessWidget {
  const _MacroGrid({required this.scaled, required this.l10n});
  final Map<NutrientCode, NutrientAmount> scaled;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final macros = [
      (NutrientCode.proteinG, l10n.nutrientProteinG),
      (NutrientCode.carbohydrateG, l10n.nutrientCarbohydrateG),
      (NutrientCode.fatG, l10n.nutrientFatG),
      (NutrientCode.fibreG, l10n.nutrientFibreG),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.foodDetailsMacros, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: macros
              .map((m) => Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Column(
                          children: [
                            Text(m.$2,
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 4),
                            Text(
                              '${NutritionCalculator.roundMacro(scaled[m.$1]?.amountPer100g)} ${m.$1.unit}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  const _ConfidenceCard({required this.food, required this.l10n});
  final Food food;
  final AppLocalizations l10n;

  String _confidenceLabel(NutritionConfidence c) {
    switch (c) {
      case NutritionConfidence.high:
        return l10n.confidenceHigh;
      case NutritionConfidence.medium:
        return l10n.confidenceMedium;
      case NutritionConfidence.estimated:
        return l10n.confidenceEstimated;
      case NutritionConfidence.unknown:
        return l10n.confidenceUnknown;
    }
  }

  String? _confidenceNote(NutritionConfidence c) {
    switch (c) {
      case NutritionConfidence.high:
        return l10n.confidenceHighNote;
      case NutritionConfidence.medium:
        return l10n.confidenceMediumNote;
      case NutritionConfidence.estimated:
        return l10n.confidenceEstimatedNote;
      case NutritionConfidence.unknown:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = food.confidence;
    final note = _confidenceNote(c);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.confidenceLabel}: ${_confidenceLabel(c)}',
                style: Theme.of(context).textTheme.bodyMedium),
            if (note != null) ...[
              const SizedBox(height: 4),
              Text(note,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ],
            const SizedBox(height: 8),
            Text(l10n.foodDetailsPreparationNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      ),
    );
  }
}

class _MicronutrientList extends StatelessWidget {
  const _MicronutrientList({required this.scaled, required this.l10n});
  final Map<NutrientCode, NutrientAmount> scaled;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final micros = [
      (NutrientCode.sodiumMg, l10n.nutrientSodiumMg),
      (NutrientCode.ironMg, l10n.nutrientIronMg),
      (NutrientCode.calciumMg, l10n.nutrientCalciumMg),
      (NutrientCode.potassiumMg, l10n.nutrientPotassiumMg),
      (NutrientCode.vitaminCMg, l10n.nutrientVitaminCMg),
    ];
    final present = micros.where((m) => scaled[m.$1]?.amountPer100g != null).toList();
    if (present.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.foodDetailsMicronutrients, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: present.map((m) {
                final amt = scaled[m.$1]!.amountPer100g;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(m.$2),
                  trailing: Text('${NutritionCalculator.roundMacro(amt)} ${m.$1.unit}',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.food, required this.l10n});
  final Food food;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final s = food.source;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sourceLabel, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(s.name, style: Theme.of(context).textTheme.bodyMedium),
            if (s.reference != null)
              Text(s.reference!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
          ],
        ),
      ),
    );
  }
}
