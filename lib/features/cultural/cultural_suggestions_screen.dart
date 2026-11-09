import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/nutrient.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'cultural_suggestions_providers.dart';

/// Cuisine-aware meal ideas from the structured food database.
///
/// Suggestions never invent calories — tapping opens food details to verify
/// and log from known nutrition.
class CulturalSuggestionsScreen extends ConsumerWidget {
  const CulturalSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final suggestions = ref.watch(culturalMealSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.culturalSuggestionsTitle)),
      body: SafeArea(
        child: suggestions.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.culturalSuggestionsEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.culturalSuggestionsIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  for (final s in suggestions)
                    Card(
                      child: ListTile(
                        title: Text(s.food.displayName),
                        subtitle: Text(
                          [
                            _reason(l10n, s.reasonKey),
                            if (s.matchedCuisine != null) s.matchedCuisine!,
                            if (s.food.nutrientPer100g(
                                  NutrientCode.energyKcal,
                                ) !=
                                null)
                              l10n.culturalSuggestionsKcalPer100g(
                                s.food
                                    .nutrientPer100g(NutrientCode.energyKcal)!
                                    .round(),
                              )
                            else
                              l10n.culturalSuggestionsKcalUnavailable,
                          ].join(' · '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          '/food/${Uri.encodeComponent(s.food.id)}',
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  String _reason(AppLocalizations l10n, String key) {
    switch (key) {
      case 'culturalSuggestReasonFamiliarCuisine':
        return l10n.culturalSuggestReasonFamiliarCuisine;
      case 'culturalSuggestReasonProteinFamiliar':
        return l10n.culturalSuggestReasonProteinFamiliar;
      case 'culturalSuggestReasonProtein':
        return l10n.culturalSuggestReasonProtein;
      case 'culturalSuggestReasonFibreFamiliar':
        return l10n.culturalSuggestReasonFibreFamiliar;
      case 'culturalSuggestReasonFibre':
        return l10n.culturalSuggestReasonFibre;
      default:
        return l10n.culturalSuggestReasonExplore;
    }
  }
}
