import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/nutrient.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'recipe_providers.dart';

/// Shows a saved personal recipe and its calculated nutrition.
class RecipeDetailsScreen extends ConsumerWidget {
  const RecipeDetailsScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final recipe = ref.watch(recipeByIdProvider(recipeId));

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.recipesTitle)),
        body: Center(child: Text(l10n.commonError)),
      );
    }

    final kcal = recipe.caloriesPerServing?.round() ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.recipesEdit,
            onPressed: () => context.push('/recipes/$recipeId/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.diaryDeleteEntry,
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.recipesDeleteTitle),
                  content: Text(l10n.recipesDeleteBody),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.commonCancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.diaryConfirmDeleteYes),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(recipeControllerProvider).delete(recipeId);
                if (context.mounted) context.go('/recipes');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.recipesServingsCount(recipe.servings),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.recipesPerServingKcal(kcal),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.onboardingSummaryMacros(
                recipe.nutrientPerServing(NutrientCode.proteinG)?.round() ?? 0,
                recipe
                        .nutrientPerServing(NutrientCode.carbohydrateG)
                        ?.round() ??
                    0,
                recipe.nutrientPerServing(NutrientCode.fatG)?.round() ?? 0,
                recipe.nutrientPerServing(NutrientCode.fibreG)?.round() ?? 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.recipesCalculationNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Text(l10n.recipesIngredients,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...recipe.ingredients.map(
              (i) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(i.foodName),
                trailing: Text('${i.grams.toStringAsFixed(0)} g'),
              ),
            ),
            if (recipe.notes != null && recipe.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.recipesNotesLabel,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(recipe.notes!),
            ],
          ],
        ),
      ),
    );
  }
}
