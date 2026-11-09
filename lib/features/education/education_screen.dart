import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/nutrition_education_tip.dart';
import '../../features/profile/profile_controller.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// Short, culturally respectful nutrition education tips.
///
/// Tips never invent calorie figures for specific foods — they explain how
/// Nutrivoya uses structured data and portions.
class EducationScreen extends ConsumerWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cuisines = ref
            .watch(profileControllerProvider)
            ?.familiarCuisines
            .map((c) => c.toLowerCase())
            .toSet() ??
        {};

    final tips = NutritionEducationLibrary.tips.toList()
      ..sort((a, b) {
        final aHit = a.cuisineTags.any(cuisines.contains);
        final bHit = b.cuisineTags.any(cuisines.contains);
        if (aHit == bHit) return 0;
        return aHit ? -1 : 1;
      });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.educationTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.educationIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            for (final tip in tips)
              Card(
                child: ListTile(
                  title: Text(_title(l10n, tip.titleKey)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(_body(l10n, tip.bodyKey)),
                  ),
                  isThreeLine: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n, String key) {
    switch (key) {
      case 'educationTipPortionsTitle':
        return l10n.educationTipPortionsTitle;
      case 'educationTipStaplesTitle':
        return l10n.educationTipStaplesTitle;
      case 'educationTipPairProteinTitle':
        return l10n.educationTipPairProteinTitle;
      case 'educationTipFibreTitle':
        return l10n.educationTipFibreTitle;
      case 'educationTipMissingDataTitle':
        return l10n.educationTipMissingDataTitle;
      case 'educationTipProvenanceTitle':
        return l10n.educationTipProvenanceTitle;
      default:
        return key;
    }
  }

  String _body(AppLocalizations l10n, String key) {
    switch (key) {
      case 'educationTipPortionsBody':
        return l10n.educationTipPortionsBody;
      case 'educationTipStaplesBody':
        return l10n.educationTipStaplesBody;
      case 'educationTipPairProteinBody':
        return l10n.educationTipPairProteinBody;
      case 'educationTipFibreBody':
        return l10n.educationTipFibreBody;
      case 'educationTipMissingDataBody':
        return l10n.educationTipMissingDataBody;
      case 'educationTipProvenanceBody':
        return l10n.educationTipProvenanceBody;
      default:
        return key;
    }
  }
}
