import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/nutrition_goal.dart';
import '../../core/models/reproductive_context.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../profile/profile_controller.dart';
import 'goal_labels.dart';
import 'targets_providers.dart';

/// Goals screen — estimated energy and macro targets with guardrails.
class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  late final TextEditingController _customCtrl;

  @override
  void initState() {
    super.initState();
    final custom = ref.read(customCalorieTargetProvider);
    _customCtrl = TextEditingController(text: custom?.round().toString() ?? '');
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(profileControllerProvider);
    final estimate = ref.watch(energyEstimateProvider);
    final targets = ref.watch(nutritionTargetsProvider);
    final custom = ref.watch(customCalorieTargetProvider);
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    if (profile == null || estimate == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.goalsTitle)),
        body: Center(child: Text(l10n.goalsCompleteProfile)),
      );
    }

    final warnings = {
      ...estimate.warnings,
      if (custom != null)
        ...ref
            .watch(energyRequirementServiceProvider)
            .checkCustomTarget(custom, estimate),
    };
    final showRate = profile.goal == NutritionGoal.loseWeight ||
        profile.goal == NutritionGoal.gainWeight;
    final rate = profile.targetRateKgPerWeek ??
        (profile.goal == NutritionGoal.loseWeight ? 0.5 : 0.25);

    String g(double? v) => l10n.goalsGramValue(v?.round().toString() ?? '—');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.goalsEstimateNote, style: muted),
            const SizedBox(height: 8),
            for (final w in warnings)
              TargetWarningCard(text: targetWarningText(w, l10n)),
            _TargetTile(
              key: const Key('goals-calories'),
              label: l10n.goalsCalorieTarget,
              value: l10n.goalsKcalValue(
                  targets.calorieTargetKcal!.round().toString()),
              subtitle: custom != null ? l10n.goalsUsingCustom : null,
            ),
            _TargetTile(label: l10n.goalsProteinTarget, value: g(targets.proteinTargetG)),
            _TargetTile(label: l10n.goalsCarbTarget, value: g(targets.carbTargetG)),
            _TargetTile(label: l10n.goalsFatTarget, value: g(targets.fatTargetG)),
            _TargetTile(label: l10n.goalsFibreTarget, value: g(targets.fibreTargetG)),
            const Divider(),
            _TargetTile(
                label: l10n.goalsMaintenance,
                value: l10n.goalsKcalValue(estimate.tdeeKcal.round().toString())),
            _TargetTile(
                label: l10n.goalsBmr,
                value: l10n.goalsKcalValue(estimate.bmrKcal.round().toString())),
            if (showRate) ...[
              const Divider(),
              Text(l10n.goalsRateTitle,
                  style: Theme.of(context).textTheme.titleSmall),
              Slider(
                value: rate.clamp(0.1, 1.0),
                min: 0.1,
                max: 1.0,
                divisions: 9,
                label: l10n.goalsRateValue(rate.toStringAsFixed(1)),
                onChanged: (v) => ref
                    .read(profileControllerProvider.notifier)
                    .save(profile.copyWith(targetRateKgPerWeek: v)),
              ),
            ],
            const Divider(),
            Text(l10n.goalsLifeStage,
                style: Theme.of(context).textTheme.titleSmall),
            DropdownButton<ReproductiveContext>(
              isExpanded: true,
              value: profile.reproductiveContext,
              onChanged: (c) => ref
                  .read(profileControllerProvider.notifier)
                  .save(profile.copyWith(reproductiveContext: c)),
              items: ReproductiveContext.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(reproductiveContextLabel(c, l10n)),
                      ))
                  .toList(),
            ),
            const Divider(),
            Text(l10n.goalsCustomTarget,
                style: Theme.of(context).textTheme.titleSmall),
            TextField(
              key: const Key('goals-custom-field'),
              controller: _customCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: l10n.goalsCustomTargetHint),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _customCtrl.clear();
                    ref.read(customCalorieTargetProvider.notifier).set(null);
                  },
                  child: Text(l10n.goalsUseEstimate),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('goals-custom-save'),
                  onPressed: () {
                    final v = double.tryParse(_customCtrl.text.trim());
                    ref
                        .read(customCalorieTargetProvider.notifier)
                        .set(v != null && v > 0 ? v : null);
                  },
                  child: Text(l10n.goalsSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetTile extends StatelessWidget {
  const _TargetTile({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
  });
  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
