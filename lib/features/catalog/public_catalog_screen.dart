import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/nutrient.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'public_catalog_repository.dart';

/// Browse verified user-contributed foods published to the shared catalog.
class PublicCatalogScreen extends ConsumerWidget {
  const PublicCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final foods = ref.watch(publicCatalogFoodsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.catalogTitle)),
      body: SafeArea(
        child: foods.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.catalogEmpty,
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
                    l10n.catalogIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  for (final food in foods)
                    Card(
                      child: ListTile(
                        title: Text(food.displayName),
                        subtitle: Text(
                          [
                            l10n.catalogVerifiedBadge,
                            if (food.cuisine != null) food.cuisine!,
                            if (food.nutrientPer100g(NutrientCode.energyKcal) !=
                                null)
                              l10n.culturalSuggestionsKcalPer100g(
                                food
                                    .nutrientPer100g(NutrientCode.energyKcal)!
                                    .round(),
                              )
                            else
                              l10n.culturalSuggestionsKcalUnavailable,
                          ].join(' · '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          '/food/${Uri.encodeComponent(food.id)}',
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
