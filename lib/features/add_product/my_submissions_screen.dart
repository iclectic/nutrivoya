import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/product_submission.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'add_product_providers.dart';

/// List of the user's product submissions and personal-library status.
class MySubmissionsScreen extends ConsumerWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(productSubmissionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mySubmissionsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-product'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addProductTitle),
      ),
      body: SafeArea(
        child: items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.mySubmissionsEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final s = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(s.name),
                      subtitle: Text(_statusLabel(l10n, s.status)),
                      trailing: s.status ==
                              ProductSubmissionStatus.publishedLocally
                          ? IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () => context.push(
                                '/food/${Uri.encodeComponent(s.publishedFoodId)}',
                              ),
                            )
                          : null,
                      onLongPress: () async {
                        await ref
                            .read(addProductControllerProvider.notifier)
                            .delete(s.id);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, ProductSubmissionStatus status) {
    switch (status) {
      case ProductSubmissionStatus.draft:
        return l10n.addProductStatusDraft;
      case ProductSubmissionStatus.pendingReview:
        return l10n.addProductStatusPending;
      case ProductSubmissionStatus.publishedLocally:
        return l10n.addProductStatusPublished;
      case ProductSubmissionStatus.withdrawn:
        return l10n.addProductStatusWithdrawn;
    }
  }
}
