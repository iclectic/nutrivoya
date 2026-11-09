import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/extensions/app_localizations_x.dart';
import '../diary/diary_providers.dart';
import 'tracking_providers.dart';

/// Save and apply reusable meal patterns from diary entries.
class MealTemplatesScreen extends ConsumerWidget {
  const MealTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final templates = ref.watch(mealTemplatesProvider);
    final entriesAsync = ref.watch(diaryEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.templatesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _saveFromToday(context, ref),
        icon: const Icon(Icons.save_outlined),
        label: Text(l10n.templatesSaveFromToday),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.templatesIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            entriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (entries) => Text(
                l10n.templatesTodayCount(entries.length),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            if (templates.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  l10n.templatesEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            else
              ...templates.map(
                (t) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(t.name),
                    subtitle: Text(
                      l10n.templatesItemSummary(
                        t.itemCount,
                        t.totalKcal?.round() ?? 0,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'apply') {
                          final n = await ref
                              .read(trackingControllerProvider.notifier)
                              .applyTemplate(t.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.templatesApplied(n)),
                              ),
                            );
                          }
                        } else if (value == 'delete') {
                          await ref
                              .read(trackingControllerProvider.notifier)
                              .deleteTemplate(t.id);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'apply',
                          child: Text(l10n.templatesApply),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(l10n.commonDelete),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFromToday(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final entries =
        ref.read(diaryEntriesProvider).asData?.value ?? const [];
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.templatesNeedEntries)),
      );
      return;
    }
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.templatesSaveFromToday),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.templatesNameLabel),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(trackingControllerProvider.notifier).saveTemplateFromToday(
          name: controller.text,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.templatesSaved)),
      );
    }
  }
}
