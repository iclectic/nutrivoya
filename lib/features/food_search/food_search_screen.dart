import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/food_search_result.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../../shared/widgets/empty_state.dart';
import '../diary/diary_providers.dart';
import '../food/food_providers.dart';
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
            tooltip: l10n.photoTitle,
            icon: const Icon(Icons.photo_camera_outlined),
            onPressed: () => context.push('/photo'),
          ),
          IconButton(
            tooltip: l10n.barcodeTitle,
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
    final recentAsync = ref.watch(recentFoodsProvider);
    final favourites = ref.watch(favouritesProvider);
    final frequentAsync = ref.watch(frequentFoodsProvider);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        EmptyState(icon: Icons.search, title: l10n.searchEmpty),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined),
          title: Text(l10n.photoTitle),
          subtitle: Text(l10n.photoSearchSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/photo'),
        ),
        ListTile(
          leading: const Icon(Icons.qr_code_scanner),
          title: Text(l10n.barcodeTitle),
          subtitle: Text(l10n.barcodeHint),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/barcode'),
        ),
        ListTile(
          leading: const Icon(Icons.menu_book_outlined),
          title: Text(l10n.searchMyRecipes),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/recipes'),
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add_check_outlined),
          title: Text(l10n.templatesTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/templates'),
        ),
        if (favourites.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l10n.favouritesTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          ...favourites.take(6).map(
                (f) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.star_outline),
                  title: Text(f.foodName),
                  onTap: () => context.push('/food/${f.foodId}'),
                ),
              ),
        ],
        const SizedBox(height: 8),
        Text(
          l10n.frequentFoodsTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        frequentAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (frequent) {
            if (frequent.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.frequentFoodsEmpty,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              );
            }
            return Column(
              children: frequent
                  .take(6)
                  .map(
                    (f) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_fire_department_outlined),
                      title: Text(f.foodName),
                      subtitle: Text(l10n.frequentFoodsCount(f.logCount)),
                      onTap: () => context.push('/food/${f.foodId}'),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(l10n.searchRecent, style: Theme.of(context).textTheme.titleSmall),
        recentAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (recent) {
            if (recent.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.diaryEmpty,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              );
            }
            final seen = <String>{};
            final unique = recent.where((e) => seen.add(e.foodId)).toList();
            return Column(
              children: unique
                  .take(8)
                  .map(
                    (e) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history),
                      title: Text(e.foodName),
                      subtitle: e.portionName != null
                          ? Text(e.portionName!)
                          : null,
                      onTap: () => context.push('/food/${e.foodId}'),
                    ),
                  )
                  .toList(),
            );
          },
        ),
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
            title: Text(food.displayName),
            subtitle: Text(
              [
                if (food.cuisine != null) food.cuisine,
                if (result.matchedName != null &&
                    result.matchedName != food.displayName)
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
