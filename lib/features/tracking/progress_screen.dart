import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/models/meal_type.dart';
import '../../core/utils/uuid.dart';
import '../diary/diary_providers.dart';
import 'tracking_models.dart';
import 'tracking_providers.dart';

String mealLabel(AppLocalizations l10n, MealType m) => switch (m) {
      MealType.breakfast => l10n.diaryMealBreakfast,
      MealType.lunch => l10n.diaryMealLunch,
      MealType.dinner => l10n.diaryMealDinner,
      MealType.snacks => l10n.diaryMealSnacks,
    };

/// Optional advanced tracking: weight trend, measurements, water and meal
/// templates. Nothing here is required to use Nutrivoya.
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  final _weight = TextEditingController();
  final _waist = TextEditingController();
  final _hip = TextEditingController();

  @override
  void dispose() {
    _weight.dispose();
    _waist.dispose();
    _hip.dispose();
    super.dispose();
  }

  String _date(DateTime d) => dayKey(d);

  Future<void> _saveTemplate() async {
    final l10n = AppLocalizations.of(context);
    final name = TextEditingController();
    var meal = MealType.breakfast;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: Text(l10n.progressTemplateSave),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('template-name'),
                controller: name,
                decoration: InputDecoration(labelText: l10n.progressTemplateName),
              ),
              DropdownButton<MealType>(
                key: const Key('template-meal'),
                value: meal,
                isExpanded: true,
                items: [
                  for (final m in MealType.values) DropdownMenuItem(value: m, child: Text(mealLabel(l10n, m))),
                ],
                onChanged: (m) => setLocal(() => meal = m ?? meal),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
            FilledButton(
              key: const Key('template-confirm'),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
    final templateName = name.text.trim();
    name.dispose();
    if (ok != true || !mounted) return;
    final date = ref.read(selectedDateProvider);
    final entries = await ref.read(diaryRepositoryProvider).watchEntriesForDate(date).first;
    final items = [
      for (final e in entries.where((e) => e.mealType == meal)) TemplateItem(e.foodId, e.foodName, e.grams),
    ];
    if (!mounted) return;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.progressTemplateNoEntries)));
      return;
    }
    await ref.read(mealTemplatesProvider.notifier).add(MealTemplate(
          id: generateUuidV4(),
          name: templateName.isEmpty ? mealLabel(l10n, meal) : templateName,
          mealType: meal,
          items: items,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final weights = ref.watch(weightLogProvider);
    final trend = weightTrend(weights);
    final measurements = ref.watch(measurementsProvider);
    ref.watch(waterProvider);
    final waterToday = ref.read(waterProvider.notifier).forDay(DateTime.now());
    final templates = ref.watch(mealTemplatesProvider);
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final small = Theme.of(context).textTheme.bodySmall;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.progressTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.progressWeight, style: titleStyle),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('progress-weight'),
                  controller: _weight,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.progressWeightHint),
                ),
              ),
              TextButton(
                key: const Key('progress-weight-add'),
                onPressed: () async {
                  final kg = double.tryParse(_weight.text.replaceAll(',', '.'));
                  if (kg == null || kg < 20 || kg > 400) return;
                  await ref.read(weightLogProvider.notifier).add(kg);
                  _weight.clear();
                },
                child: Text(l10n.progressAdd),
              ),
            ],
          ),
          if (trend == null)
            Text(l10n.progressNoWeight, style: small)
          else ...[
            Text(
              trend.changeKgPerWeek == null
                  ? l10n.progressWeightAverage(trend.recentAverageKg.toStringAsFixed(1))
                  : l10n.progressWeightTrend(trend.recentAverageKg.toStringAsFixed(1),
                      trend.changeKgPerWeek!.toStringAsFixed(2)),
              key: const Key('progress-trend'),
            ),
            Text(l10n.progressWeightNote, style: small),
            for (final w in weights.reversed.take(5))
              ListTile(
                dense: true,
                title: Text('${w.kg.toStringAsFixed(1)} kg'),
                subtitle: Text(_date(w.date)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref.read(weightLogProvider.notifier).remove(w),
                ),
              ),
          ],
          const Divider(height: 32),
          Text(l10n.progressMeasurements, style: titleStyle),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('progress-waist'),
                  controller: _waist,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.progressWaist),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: const Key('progress-hip'),
                  controller: _hip,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.progressHip),
                ),
              ),
              TextButton(
                key: const Key('progress-measure-add'),
                onPressed: () async {
                  final waist = double.tryParse(_waist.text);
                  final hip = double.tryParse(_hip.text);
                  if (waist == null && hip == null) return;
                  await ref
                      .read(measurementsProvider.notifier)
                      .add(MeasurementEntry(DateTime.now(), waistCm: waist, hipCm: hip));
                  _waist.clear();
                  _hip.clear();
                },
                child: Text(l10n.progressAdd),
              ),
            ],
          ),
          if (measurements.isEmpty)
            Text(l10n.progressNoMeasurements, style: small)
          else
            for (final m in measurements.reversed.take(5))
              ListTile(
                dense: true,
                title: Text([
                  if (m.waistCm != null) '${l10n.progressWaist}: ${m.waistCm!.toStringAsFixed(1)}',
                  if (m.hipCm != null) '${l10n.progressHip}: ${m.hipCm!.toStringAsFixed(1)}',
                ].join(' · ')),
                subtitle: Text(_date(m.date)),
              ),
          const Divider(height: 32),
          Text(l10n.progressWater, style: titleStyle),
          Row(
            children: [
              Expanded(child: Text(l10n.progressWaterToday(waterToday.toString()), key: const Key('progress-water'))),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: waterToday == 0 ? null : () => ref.read(waterProvider.notifier).add(-250),
              ),
              FilledButton.tonal(
                key: const Key('progress-water-add'),
                onPressed: () => ref.read(waterProvider.notifier).add(250),
                child: Text(l10n.progressWaterAdd),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(l10n.progressTemplates, style: titleStyle),
          if (templates.isEmpty) Text(l10n.progressTemplatesEmpty, style: small),
          for (final t in templates)
            ListTile(
              key: Key('template-${t.id}'),
              title: Text(t.name),
              subtitle: Text(t.items.map((i) => i.foodName).join(', ')),
              trailing: PopupMenuButton<MealType?>(
                key: Key('template-menu-${t.id}'),
                onSelected: (meal) async {
                  if (meal == null) {
                    await ref.read(mealTemplatesProvider.notifier).delete(t.id);
                    return;
                  }
                  await ref.read(mealTemplateLoggerProvider).log(t, meal, at: ref.read(selectedDateProvider));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(l10n.progressTemplateLogged(t.name))));
                  }
                },
                itemBuilder: (_) => [
                  for (final m in MealType.values)
                    PopupMenuItem(value: m, child: Text(l10n.progressTemplateLog(mealLabel(l10n, m)))),
                  PopupMenuItem(value: null, child: Text(l10n.progressTemplateDelete)),
                ],
              ),
            ),
          TextButton.icon(
            key: const Key('template-save'),
            onPressed: _saveTemplate,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: Text(l10n.progressTemplateSave),
          ),
        ],
      ),
    );
  }
}
