import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/diary_entry.dart';
import '../../core/models/meal_type.dart';
import '../../core/models/nutrition_targets.dart';
import '../../features/profile/profile_controller.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../../shared/widgets/empty_state.dart';
import '../diary/diary_providers.dart';
import '../goals/goals_providers.dart';

/// Dashboard — daily totals vs targets and meal summary.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileControllerProvider);
    final greeting = _greeting(l10n);
    final totalsAsync = ref.watch(dailyTotalsProvider);
    final entriesAsync = ref.watch(diaryEntriesProvider);
    final targets = ref.watch(nutritionTargetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardToday),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: l10n.progressTitle,
            onPressed: () => context.push('/progress'),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: l10n.diarySelectDate,
            onPressed: () => _pickDate(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '$greeting, ${profile?.displayName ?? ''}'.trim().replaceAll(
                  RegExp(r',\s*$'), ''),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            totalsAsync.when(
              loading: () => const _CalorieCardPlaceholder(),
              error: (_, _) => const _CalorieCardPlaceholder(),
              data: (totals) => _CalorieCard(
                totals: totals,
                targets: targets,
                l10n: l10n,
              ),
            ),
            const SizedBox(height: 16),
            totalsAsync.when(
              loading: () => const SizedBox(height: 80),
              error: (_, _) => const SizedBox(height: 80),
              data: (totals) => _MacroRow(
                totals: totals,
                targets: targets,
                l10n: l10n,
              ),
            ),
            const SizedBox(height: 12),
            totalsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (totals) => _MicroSection(totals: totals, l10n: l10n),
            ),
            if (targets?.isEstimate == true) ...[
              const SizedBox(height: 8),
              Text(
                l10n.goalsEstimateDisclaimer,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 24),
            entriesAsync.when(
              loading: () => const SizedBox(height: 100),
              error: (_, _) => const SizedBox(height: 100),
              data: (entries) {
                if (entries.isEmpty) {
                  return EmptyState(
                    icon: Icons.restaurant_outlined,
                    title: l10n.dashboardEmptyTitle,
                    message: l10n.dashboardEmptyBody,
                  );
                }
                return Column(
                  children: mealTypeDisplayOrder
                      .map((m) => _MealSection(
                            mealType: m,
                            l10n: l10n,
                            entries: entries
                                .where((e) => e.mealType == m)
                                .toList(),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('search'),
        icon: const Icon(Icons.add),
        label: Text(l10n.dashboardLogFood),
      ),
    );
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.dashboardGreetingMorning;
    if (hour < 18) return l10n.dashboardGreetingAfternoon;
    return l10n.dashboardGreetingEvening;
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final selected = ref.read(selectedDateProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state =
          DateTime(picked.year, picked.month, picked.day);
    }
  }
}

class _CalorieCardPlaceholder extends StatelessWidget {
  const _CalorieCardPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          height: 24,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}

class _CalorieCard extends StatelessWidget {
  const _CalorieCard({
    required this.totals,
    required this.targets,
    required this.l10n,
  });
  final DailyTotals totals;
  final NutritionTargets? targets;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final target = targets?.calorieTargetKcal;
    final progress = target != null && target > 0
        ? (totals.caloriesKcal / target).clamp(0.0, 1.5)
        : null;
    final remaining =
        target != null ? (target - totals.caloriesKcal).round() : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dashboardCalories,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              target == null
                  ? '${totals.caloriesRounded} ${l10n.diaryKcalShort}'
                  : l10n.dashboardCaloriesOf(
                      totals.caloriesRounded,
                      target.round(),
                    ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (progress != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                remaining == null
                    ? ''
                    : remaining >= 0
                        ? l10n.dashboardCaloriesRemaining(remaining)
                        : l10n.dashboardCaloriesOver((-remaining)),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${totals.entryCount} ${totals.entryCount == 1 ? "entry" : "entries"}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.totals,
    required this.targets,
    required this.l10n,
  });
  final DailyTotals totals;
  final NutritionTargets? targets;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final macros = [
      (
        l10n.dashboardProtein,
        totals.proteinG,
        targets?.proteinTargetG,
      ),
      (
        l10n.dashboardCarbs,
        totals.carbohydrateG,
        targets?.carbTargetG,
      ),
      (
        l10n.dashboardFat,
        totals.fatG,
        targets?.fatTargetG,
      ),
      (
        l10n.dashboardFibre,
        totals.fibreG,
        targets?.fibreTargetG,
      ),
    ];
    return Row(
      children: macros
          .map((m) => Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: Column(
                      children: [
                        Text(m.$1,
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(
                          m.$3 == null
                              ? '${m.$2.toStringAsFixed(0)} g'
                              : '${m.$2.toStringAsFixed(0)} / ${m.$3!.round()} g',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _MicroSection extends StatelessWidget {
  const _MicroSection({required this.totals, required this.l10n});
  final DailyTotals totals;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (l10n.nutrientIronMg, totals.ironMg, 'mg'),
      (l10n.nutrientCalciumMg, totals.calciumMg, 'mg'),
      (l10n.nutrientPotassiumMg, totals.potassiumMg, 'mg'),
      (l10n.nutrientSodiumMg, totals.sodiumMg, 'mg'),
      (l10n.nutrientVitaminCMg, totals.vitaminCMg, 'mg'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dashboardMicrosTitle,
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(
          l10n.dashboardMicrosNote,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              Chip(
                label: Text(
                  item.$2 == null
                      ? '${item.$1}: ${l10n.dashboardMicroUnavailable}'
                      : '${item.$1}: ${item.$2!.toStringAsFixed(1)} ${item.$3}',
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({
    required this.mealType,
    required this.l10n,
    required this.entries,
  });
  final MealType mealType;
  final AppLocalizations l10n;
  final List<DiaryEntry> entries;

  String get _label {
    switch (mealType.l10nKey) {
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

  @override
  Widget build(BuildContext context) {
    final mealCalories = entries.fold<double>(
      0,
      (sum, e) => sum + (e.caloriesKcal ?? 0),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_label, style: Theme.of(context).textTheme.titleSmall),
              if (entries.isNotEmpty)
                Text('${mealCalories.round()} ${l10n.diaryKcalShort}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('search'),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.diaryAddToMeal),
              ),
            ],
          ),
          if (entries.isEmpty)
            EmptyState(
              icon: Icons.restaurant_outlined,
              title: l10n.diaryNoEntriesForMeal,
            )
          else
            ...entries.map((e) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.foodName),
                  subtitle: Text(
                    '${e.grams.toStringAsFixed(0)} g'
                    '${e.portionName != null ? ' · ${e.portionName}' : ''}'
                    '${e.quantity > 1 ? ' ×${e.quantity}' : ''}',
                  ),
                  trailing: Text(
                    '${e.caloriesKcal?.round() ?? 0} ${l10n.diaryKcalShort}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )),
        ],
      ),
    );
  }
}
