import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/models/nutrient.dart';
import 'open_food_facts_adapter.dart';

/// Camera barcode scanner with manual entry fallback.
class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key, this.showCamera = true});
  final bool showCamera;

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  final _manual = TextEditingController();
  bool _handling = false;
  String? _error;

  @override
  void dispose() {
    _manual.dispose();
    super.dispose();
  }

  Future<void> _open(String code) async {
    final l10n = AppLocalizations.of(context);
    final trimmed = code.trim();
    if (!isValidGtin(trimmed)) {
      setState(() => _error = l10n.barcodeInvalid);
      return;
    }
    if (_handling) return;
    _handling = true;
    setState(() => _error = null);
    await context.push('/barcode/$trimmed');
    _handling = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.barcodeTitle)),
      body: Column(
        children: [
          if (widget.showCamera)
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final value = capture.barcodes.firstOrNull?.rawValue;
                  if (value != null && isValidGtin(value)) _open(value);
                },
                errorBuilder: (context, error) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.barcodeCameraUnavailable, textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('barcode-manual'),
                    controller: _manual,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.barcodeManualHint,
                      errorText: _error,
                    ),
                    onSubmitted: _open,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  key: const Key('barcode-lookup'),
                  onPressed: () => _open(_manual.text),
                  child: Text(l10n.barcodeLookup),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a packaged product and asks the user to verify it against the label
/// before it can be logged.
class BarcodeProductScreen extends ConsumerStatefulWidget {
  const BarcodeProductScreen({super.key, required this.barcode});
  final String barcode;

  @override
  ConsumerState<BarcodeProductScreen> createState() => _BarcodeProductScreenState();
}

class _BarcodeProductScreenState extends ConsumerState<BarcodeProductScreen> {
  late Future<PackagedProduct?> _future;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final cached = ref.read(packagedFoodCacheProvider).byFoodId('off:${widget.barcode}');
    _future = cached != null
        ? Future.value(PackagedProduct(barcode: widget.barcode, food: cached, raw: const {}))
        : ref.read(packagedFoodRepositoryProvider).lookup(widget.barcode);
  }

  String _issueText(AppLocalizations l10n, LabelIssue issue) => switch (issue) {
        LabelIssue.missingEnergy => l10n.barcodeIssueMissingEnergy,
        LabelIssue.missingMacros => l10n.barcodeIssueMissingMacros,
        LabelIssue.energyMismatch => l10n.barcodeIssueEnergyMismatch,
        LabelIssue.implausibleValue => l10n.barcodeIssueImplausible,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.barcodeProductTitle)),
      body: FutureBuilder<PackagedProduct?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      snap.hasError ? l10n.barcodeLookupFailed : l10n.barcodeNotFound,
                      key: const Key('barcode-message'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (snap.hasError)
                      OutlinedButton(
                        onPressed: () => setState(_load),
                        child: Text(l10n.commonRetry),
                      ),
                    TextButton(
                      onPressed: () => context.go('/search'),
                      child: Text(l10n.barcodeSearchByName),
                    ),
                  ],
                ),
              ),
            );
          }
          final product = snap.data!;
          final food = product.food;
          final issues = checkLabel(food);
          String fmt(NutrientCode c) {
            final v = food.nutrientPer100g(c);
            return v == null ? '—' : '${v.toStringAsFixed(1)} ${c.unit}';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(food.canonicalName, style: Theme.of(context).textTheme.headlineSmall),
              Text(widget.barcode, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(l10n.barcodeSource, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Text(l10n.barcodePer100g, style: Theme.of(context).textTheme.titleMedium),
              for (final (label, code) in [
                (l10n.dashboardCalories, NutrientCode.energyKcal),
                (l10n.dashboardProtein, NutrientCode.proteinG),
                (l10n.dashboardCarbs, NutrientCode.carbohydrateG),
                (l10n.dashboardFat, NutrientCode.fatG),
                (l10n.dashboardFibre, NutrientCode.fibreG),
              ])
                ListTile(dense: true, title: Text(label), trailing: Text(fmt(code))),
              for (final issue in issues)
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(_issueText(l10n, issue)),
                  ),
                ),
              CheckboxListTile(
                key: const Key('barcode-verify'),
                value: _checked,
                onChanged: (v) => setState(() => _checked = v ?? false),
                title: Text(l10n.barcodeVerifyCheckbox),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              FilledButton(
                key: const Key('barcode-use'),
                onPressed: !_checked
                    ? null
                    : () async {
                        if (product.raw.isNotEmpty) {
                          await ref.read(packagedFoodCacheProvider).save(product);
                        }
                        if (context.mounted) context.push('/food/${food.id}');
                      },
                child: Text(l10n.barcodeUse),
              ),
            ],
          );
        },
      ),
    );
  }
}
