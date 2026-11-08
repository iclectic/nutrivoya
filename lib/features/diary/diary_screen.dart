import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/diary_entry.dart';
import '../../core/models/meal_type.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../../shared/widgets/empty_state.dart';
import '../diary/diary_providers.dart';

/// Diary screen — full day grouped by meal type with live entries.
///
/// Supports editing quantity/grams and deleting entries. Uses the reactive
/// diary stream so changes appear immediately.
class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entriesAsync = ref.watch(diaryEntriesProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diaryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: l10n.diarySelectDate,
            onPressed: () => _pickDate(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _DateHeader(date: selectedDate, l10n: l10n),
            Expanded(
              child: entriesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, _) => EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.commonError,
                ),
                data: (entries) {
                  if (entries.isEmpty) {
                    return EmptyState(
                      icon: Icons.book_outlined,
                      title: l10n.diaryEmpty,
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: mealTypeDisplayOrder
                        .map((m) => _MealGroup(
                              mealType: m,
                              l10n: l10n,
                              entries: entries
                                  .where((e) => e.mealType == m)
                                  .toList(),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final selected = ref.read(selectedDateProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state =
          DateTime(picked.year, picked.month, picked.day);
    }
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date, required this.l10n});
  final DateTime date;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final yesterday = today.subtract(const Duration(days: 1));
    final isYesterday = date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    final label = isToday
        ? l10n.diaryToday
        : isYesterday
            ? l10n.diaryYesterday
            : '${date.day}/${date.month}/${date.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _MealGroup extends ConsumerWidget {
  const _MealGroup({
    required this.mealType,
    required this.l10n,
    required this.entries,
  });

  final MealType mealType;
  final AppLocalizations l10n;
  final List<DiaryEntry> entries;

  String get _label {
    switch (mealType.l10nKey) {
      case 'diaryMealBreakfast':
        return l10n.diaryMealBreakfast;
      case 'diaryMealLunch':
        return l10n.diaryMealLunch;
      case 'diaryMealDinner':
        return l10n.diaryMealDinner;
      default:
        return l10n.diaryMealSnacks;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealCalories =
        entries.fold<double>(0, (sum, e) => sum + (e.caloriesKcal ?? 0));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_label, style: Theme.of(context).textTheme.titleMedium),
              if (entries.isNotEmpty)
                Text('${mealCalories.round()} ${l10n.diaryKcalShort}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
              TextButton.icon(
                onPressed: () => context.go('/search'),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.diaryAddToMeal),
              ),
            ],
          ),
          if (entries.isEmpty)
            EmptyState(
                icon: Icons.restaurant_outlined,
                title: l10n.diaryNoEntriesForMeal)
          else
            ...entries.map((e) => _DiaryEntryTile(
                  entry: e,
                  l10n: l10n,
                )),
        ],
      ),
    );
  }
}

class _DiaryEntryTile extends ConsumerWidget {
  const _DiaryEntryTile({required this.entry, required this.l10n});
  final DiaryEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        title: Text(entry.foodName),
        subtitle: Text(
          '${entry.grams.toStringAsFixed(0)} g'
          '${entry.portionName != null ? ' · ${entry.portionName}' : ''}'
          '${entry.quantity > 1 ? ' ×${entry.quantity}' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${entry.caloriesKcal?.round() ?? 0} ${l10n.diaryKcalShort}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            PopupMenuButton<String>(
              onSelected: (action) async {
                if (action == 'edit') {
                  _showEditDialog(context, ref);
                } else if (action == 'delete') {
                  _confirmDelete(context, ref);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.diaryEditEntry),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.diaryDeleteEntry),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final gramsController =
        TextEditingController(text: entry.grams.toStringAsFixed(0));
    final qtyController =
        TextEditingController(text: entry.quantity.toString());

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.diaryEditEntry),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: gramsController,
                decoration: InputDecoration(labelText: l10n.diaryGramsLabel),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                decoration:
                    InputDecoration(labelText: l10n.diaryQuantityLabel),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () async {
                final newGrams =
                    double.tryParse(gramsController.text) ?? entry.grams;
                final newQty =
                    int.tryParse(qtyController.text) ?? entry.quantity;
                final updated = entry.copyWith(
                  grams: newGrams,
                  quantity: newQty,
                );
                await ref
                    .read(diaryControllerProvider.notifier)
                    .updateEntry(updated);
                if (context.mounted) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.diaryEntryUpdated)),
                  );
                }
              },
              child: Text(l10n.commonSave),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.diaryDeleteEntry),
          content: Text(l10n.diaryConfirmDelete),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () async {
                if (entry.id != null) {
                  await ref
                      .read(diaryControllerProvider.notifier)
                      .deleteEntry(entry.id!);
                }
                if (context.mounted) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.diaryEntryDeleted)),
                  );
                }
              },
              child: Text(l10n.diaryConfirmDeleteYes),
            ),
          ],
        );
      },
    );
  }
}
