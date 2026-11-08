import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/food_search_result.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../../shared/widgets/empty_state.dart';
import '../diary/diary_providers.dart';
import '../food/food_providers.dart';
import '../recipes/recipe_providers.dart';
import '../tracking/tracking_providers.dart';

/// Food search screen.
///
/// Uses [foodSearchResultsProvider] (local curated dataset + optional USDA
/// adapter) and ranks results via [FoodSearchService]. Tapping a result opens
/// the food details screen.
class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = ref.watch(foodQueryProvider);
    final resultsAsync = ref.watch(foodSearchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchTitle),
        actions: [
          IconButton(
            key: const Key('search-scan-barcode'),
            tooltip: l10n.barcodeScanTooltip,
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.push('/barcode'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            ref.read(foodQueryProvider.notifier).state = '';
                          },
                        ),
                ),
                onChanged: (v) =>
                    ref.read(foodQueryProvider.notifier).state = v.trim(),
              ),
            ),
            Expanded(
              child: query.isEmpty
                  ? _suggestions(l10n)
                  : resultsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => EmptyState(
                        icon: Icons.error_outline,
                        title: l10n.commonError,
                      ),
                      data: (results) => results.isEmpty
                          ? EmptyState(
                              icon: Icons.travel_explore_outlined,
                              title: l10n.searchNoResults,
                              message: l10n.searchTryExample,
                            )
                          : _resultsList(l10n, results),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestions(AppLocalizations l10n) {
    final recent = ref.watch(recentFoodsProvider).valueOrNull ?? const [];
    final frequent = ref.watch(frequentFoodsProvider).valueOrNull ?? const [];
    final favourites = ref.watch(favouritesProvider);
    final recipes = ref.watch(recipesProvider);
    final sections = [
      (l10n.searchRecent, Icons.history, [for (final e in recent) (e.foodId, e.foodName)]),
      (l10n.searchFrequent, Icons.trending_up, [for (final e in frequent) (e.foodId, e.foodName)]),
      (l10n.searchFavourites, Icons.star_outline, [for (final e in favourites.entries) (e.key, e.value)]),
      (l10n.searchMyRecipes, Icons.menu_book_outlined, [for (final r in recipes) (r.foodId, r.name)]),
    ];
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        EmptyState(icon: Icons.search, title: l10n.searchEmpty),
        const SizedBox(height: 16),
        for (final (title, icon, items) in sections) ...[
          ListTile(
            leading: Icon(icon),
            title: Text(title, style: Theme.of(context).textTheme.titleSmall),
            subtitle: items.isEmpty ? Text(l10n.searchNothingYet) : null,
          ),
          for (final (id, name) in items.take(5))
            ListTile(
              key: Key('suggestion-$id'),
              contentPadding: const EdgeInsetsDirectional.only(start: 56, end: 16),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/food/$id'),
            ),
        ],
      ],
    );
  }

  Widget _resultsList(AppLocalizations l10n, List<FoodSearchResult> results) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final food = result.food;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(food.nameFor(Localizations.localeOf(context).languageCode)),
            subtitle: Text(
              [
                if (food.cuisine != null) food.cuisine,
                if (result.matchedName != null &&
                    result.matchedName != food.nameFor(Localizations.localeOf(context).languageCode))
                  result.matchedName,
              ].join(' · '),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/food/${food.id}'),
          ),
        );
      },
    );
  }
}
