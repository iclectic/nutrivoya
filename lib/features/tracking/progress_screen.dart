import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/models/weight_entry.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'tracking_providers.dart';

/// Progress — weight trend, water, body measurements (calm, non-guilt framing).
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final trend = ref.watch(weightTrendProvider);
    final weightsAsync = ref.watch(weightEntriesProvider);
    final waterAsync = ref.watch(dailyWaterProvider);
    final measurementsAsync = ref.watch(bodyMeasurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progressTitle),
        actions: [
          IconButton(
            tooltip: l10n.templatesTitle,
            icon: const Icon(Icons.playlist_add_check_outlined),
            onPressed: () => context.push('/templates'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.progressIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),

            // Water -------------------------------------------------------
            Text(l10n.progressWater, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            waterAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(l10n.commonError),
              data: (water) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.progressWaterTotal(water.totalMl, water.goalMl),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: water.progress.clamp(0.0, 1.0),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final ml in const [150, 250, 500])
                        ActionChip(
                          label: Text(l10n.progressWaterAdd(ml)),
                          onPressed: () => ref
                              .read(trackingControllerProvider.notifier)
                              .addWaterMl(ml),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Weight ------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.progressWeight,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _logWeight(context, ref),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.progressLogWeight),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _trendText(l10n, trend),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.progressTrendNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            weightsAsync.when(
              loading: () => const SizedBox(height: 80),
              error: (_, _) => Text(l10n.commonError),
              data: (entries) {
                if (entries.isEmpty) {
                  return Text(
                    l10n.progressWeightEmpty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  );
                }
                final dateFmt = DateFormat.yMMMd();
                return Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: _WeightSparkline(entries: entries.take(14).toList()),
                    ),
                    const SizedBox(height: 8),
                    ...entries.take(8).map(
                      (e) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.progressWeightValue(e.weightKg.toStringAsFixed(1)),
                        ),
                        subtitle: Text(dateFmt.format(e.loggedAt)),
                        trailing: e.id == null
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => ref
                                    .read(trackingControllerProvider.notifier)
                                    .deleteWeight(e.id!),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // Measurements ------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.progressMeasurements,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _logMeasurement(context, ref),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.progressLogMeasurement),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.progressMeasurementsNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            measurementsAsync.when(
              loading: () => const SizedBox(height: 40),
              error: (_, _) => Text(l10n.commonError),
              data: (items) {
                if (items.isEmpty) {
                  return Text(
                    l10n.progressMeasurementsEmpty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  );
                }
                final dateFmt = DateFormat.yMMMd();
                return Column(
                  children: items.take(6).map((m) {
                    final parts = <String>[];
                    if (m.waistCm != null) {
                      parts.add(l10n.progressWaist(m.waistCm!.toStringAsFixed(1)));
                    }
                    if (m.hipCm != null) {
                      parts.add(l10n.progressHip(m.hipCm!.toStringAsFixed(1)));
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(parts.join(' · ')),
                      subtitle: Text(dateFmt.format(m.loggedAt)),
                      trailing: m.id == null
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ref
                                  .read(trackingControllerProvider.notifier)
                                  .deleteMeasurement(m.id!),
                            ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _trendText(AppLocalizations l10n, WeightTrend trend) {
    switch (trend.direction) {
      case WeightTrendDirection.insufficientData:
        return l10n.progressTrendInsufficient;
      case WeightTrendDirection.steady:
        return l10n.progressTrendSteady(
          trend.averageKg?.toStringAsFixed(1) ?? '—',
        );
      case WeightTrendDirection.rising:
        return l10n.progressTrendRising(
          trend.averageKg?.toStringAsFixed(1) ?? '—',
          trend.weeklyChangeKg?.abs().toStringAsFixed(2) ?? '—',
        );
      case WeightTrendDirection.falling:
        return l10n.progressTrendFalling(
          trend.averageKg?.toStringAsFixed(1) ?? '—',
          trend.weeklyChangeKg?.abs().toStringAsFixed(2) ?? '—',
        );
    }
  }

  Future<void> _logWeight(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.progressLogWeight),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.progressWeightKgLabel),
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
    final kg = double.tryParse(controller.text.replaceAll(',', '.'));
    if (kg == null || kg < 20 || kg > 400) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.progressWeightInvalid)),
        );
      }
      return;
    }
    await ref.read(trackingControllerProvider.notifier).logWeight(kg);
  }

  Future<void> _logMeasurement(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final waist = TextEditingController();
    final hip = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.progressLogMeasurement),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: waist,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.progressWaistLabel),
            ),
            TextField(
              controller: hip,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.progressHipLabel),
            ),
          ],
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
    final w = double.tryParse(waist.text.replaceAll(',', '.'));
    final h = double.tryParse(hip.text.replaceAll(',', '.'));
    if (w == null && h == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.progressMeasurementInvalid)),
        );
      }
      return;
    }
    await ref.read(trackingControllerProvider.notifier).logMeasurement(
          waistCm: w,
          hipCm: h,
        );
  }
}

class _WeightSparkline extends StatelessWidget {
  const _WeightSparkline({required this.entries});

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    final chronological = [...entries]
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    return CustomPaint(
      painter: _SparklinePainter(
        values: chronological.map((e) => e.weightKg).toList(),
        color: Theme.of(context).colorScheme.primary,
        track: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.track,
  });

  final List<double> values;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = track;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(12),
      ),
      bg,
    );
    if (values.length < 2) return;
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.01 ? 1.0 : maxV - minV;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * (i / (values.length - 1));
      final y = size.height -
          ((values[i] - minV) / range) * (size.height * 0.7) -
          size.height * 0.15;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values;
}
