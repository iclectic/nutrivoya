import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/extensions/app_localizations_x.dart';

/// Goals screen shell — shows target structure. Values computed in M4.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _TargetTile(label: l10n.goalsCalorieTarget, value: l10n.goalsNotSet),
            _TargetTile(label: l10n.goalsProteinTarget, value: l10n.goalsNotSet),
            _TargetTile(label: l10n.goalsCarbTarget, value: l10n.goalsNotSet),
            _TargetTile(label: l10n.goalsFatTarget, value: l10n.goalsNotSet),
            _TargetTile(label: l10n.goalsFibreTarget, value: l10n.goalsNotSet),
            const SizedBox(height: 16),
            Text(
              l10n.settingsComingSoon,
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

class _TargetTile extends StatelessWidget {
  const _TargetTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(value,
          style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
