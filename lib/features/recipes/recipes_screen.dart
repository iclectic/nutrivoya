import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/extensions/app_localizations_x.dart';
import '../../shared/widgets/empty_state.dart';
import 'recipe_providers.dart';

/// Lists the user's personal recipes.
class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final recipes = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recipesTitle)),
      body: recipes.isEmpty
          ? EmptyState(
              icon: Icons.menu_book_outlined,
              title: l10n.recipesEmptyTitle,
              message: l10n.recipesEmptyBody,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final kcal = recipe.caloriesPerServing?.round();
                return Card(
                  child: ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(
                      [
                        l10n.recipesServingsCount(recipe.servings),
                        if (kcal != null)
                          '≈ $kcal ${l10n.diaryKcalShort}/${l10n.recipesPerServingShort}',
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/recipes/${recipe.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recipes/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.recipesCreate),
      ),
    );
  }
}
