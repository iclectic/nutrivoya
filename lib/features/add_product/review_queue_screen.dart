import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/product_submission.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'add_product_providers.dart';

/// Queue of user-submitted foods awaiting verification.
///
/// Approve / reject change provenance only — nutrition values are never
/// invented or rewritten during review.
class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pending = ref.watch(pendingReviewSubmissionsProvider);
    final isReviewer = ref.watch(reviewerModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewQueueTitle)),
      body: SafeArea(
        child: !isReviewer
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.reviewQueueNeedReviewerMode,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            : pending.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.reviewQueueEmpty,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: pending.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final s = pending[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _summary(l10n, s),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.reviewQueueProvenanceNote,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  TextButton(
                                    onPressed: () => context.push(
                                      '/food/${Uri.encodeComponent(s.publishedFoodId)}',
                                    ),
                                    child: Text(l10n.reviewQueueOpenFood),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                            addProductControllerProvider
                                                .notifier,
                                          )
                                          .approve(s.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              l10n.reviewQueueApproved,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(l10n.reviewQueueApprove),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                            addProductControllerProvider
                                                .notifier,
                                          )
                                          .reject(s.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              l10n.reviewQueueRejected,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(l10n.reviewQueueReject),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  String _summary(AppLocalizations l10n, ProductSubmission s) {
    final parts = <String>[];
    if (s.brand != null && s.brand!.isNotEmpty) parts.add(s.brand!);
    if (s.barcode != null && s.barcode!.isNotEmpty) {
      parts.add(l10n.reviewQueueBarcode(s.barcode!));
    }
    if (s.energyKcalPer100g != null) {
      parts.add(l10n.reviewQueueEnergy(s.energyKcalPer100g!.round()));
    } else {
      parts.add(l10n.reviewQueueNoEnergy);
    }
    return parts.join(' · ');
  }
}
