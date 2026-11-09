import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/energy_requirement.dart';
import '../../core/models/nutrition_goal.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../profile/profile_controller.dart';
import 'goals_providers.dart';

/// Goals screen — shows estimated BMR/TDEE and daily nutrition targets.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileControllerProvider);
    final estimate = ref.watch(energyRequirementProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (profile == null || estimate == null) ...[
              _TargetTile(label: l10n.goalsCalorieTarget, value: l10n.goalsNotSet),
              _TargetTile(label: l10n.goalsProteinTarget, value: l10n.goalsNotSet),
              _TargetTile(label: l10n.goalsCarbTarget, value: l10n.goalsNotSet),
              _TargetTile(label: l10n.goalsFatTarget, value: l10n.goalsNotSet),
              _TargetTile(label: l10n.goalsFibreTarget, value: l10n.goalsNotSet),
              const SizedBox(height: 16),
              Text(
                l10n.goalsNeedProfile,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ] else ...[
              Text(
                _goalLabel(estimate.targets.goal, l10n),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.goalsEstimateDisclaimer,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _MetricRow(
                        label: l10n.goalsBmr,
                        value:
                            '${estimate.bmrKcal.round()} ${l10n.diaryKcalShort}',
                      ),
                      const Divider(height: 24),
                      _MetricRow(
                        label: l10n.goalsTdee,
                        value:
                            '${estimate.tdeeKcal.round()} ${l10n.diaryKcalShort}',
                      ),
                      const Divider(height: 24),
                      _MetricRow(
                        label: l10n.goalsCalorieTarget,
                        value:
                            '${estimate.calorieTargetKcal?.round() ?? '—'} ${l10n.diaryKcalShort}',
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _TargetTile(
                label: l10n.goalsProteinTarget,
                value: '${estimate.targets.proteinTargetG?.round() ?? '—'} g',
              ),
              _TargetTile(
                label: l10n.goalsCarbTarget,
                value: '${estimate.targets.carbTargetG?.round() ?? '—'} g',
              ),
              _TargetTile(
                label: l10n.goalsFatTarget,
                value: '${estimate.targets.fatTargetG?.round() ?? '—'} g',
              ),
              _TargetTile(
                label: l10n.goalsFibreTarget,
                value: '${estimate.targets.fibreTargetG?.round() ?? '—'} g',
              ),
              if (estimate.warningCodes.isNotEmpty) ...[
                const SizedBox(height: 16),
                ...estimate.warningCodes.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _WarningBanner(message: _warningText(w, l10n)),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.goalsRefineOverTime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _goalLabel(NutritionGoal g, AppLocalizations l10n) {
    switch (g) {
      case NutritionGoal.maintainWeight:
        return l10n.onboardingGoalMaintain;
      case NutritionGoal.loseWeight:
        return l10n.onboardingGoalLose;
      case NutritionGoal.gainWeight:
        return l10n.onboardingGoalGain;
      case NutritionGoal.buildMuscle:
        return l10n.onboardingGoalBuildMuscle;
      case NutritionGoal.improveNutrition:
        return l10n.onboardingGoalImprove;
      case NutritionGoal.trackOnly:
        return l10n.onboardingGoalTrack;
    }
  }

  String _warningText(EnergyWarningCode code, AppLocalizations l10n) {
    switch (code) {
      case EnergyWarningCode.deficitCapped:
        return l10n.energyNoteDeficitCapped;
      case EnergyWarningCode.floorApplied:
        return l10n.energyNoteFloorApplied;
      case EnergyWarningCode.loseWhileLowWeight:
        return l10n.energyNoteLoseWhileLowWeight;
      case EnergyWarningCode.ageOutsideAdultRange:
        return l10n.energyNoteAgeOutsideAdultRange;
      case EnergyWarningCode.physiologicalUnspecified:
        return l10n.energyNotePhysiologicalUnspecified;
      case EnergyWarningCode.trackOnlyInformational:
        return l10n.energyNoteTrackOnly;
    }
  }
}

class _TargetTile extends StatelessWidget {
  const _TargetTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: style),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: scheme.onSecondaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSecondaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
