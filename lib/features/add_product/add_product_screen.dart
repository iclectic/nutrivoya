import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/product_submission.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'add_product_providers.dart';

/// Submit a missing food / packaged product.
///
/// Values are never treated as authoritative. Optional nutrition stays null
/// when unknown — Nutrivoya will not invent calories.
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({
    super.key,
    this.initialName,
    this.initialBarcode,
  });

  final String? initialName;
  final String? initialBarcode;

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  late final TextEditingController _name;
  late final TextEditingController _brand;
  late final TextEditingController _barcode;
  late final TextEditingController _cuisine;
  late final TextEditingController _serving;
  late final TextEditingController _portionName;
  late final TextEditingController _energy;
  late final TextEditingController _protein;
  late final TextEditingController _carb;
  late final TextEditingController _fat;
  late final TextEditingController _fibre;
  late final TextEditingController _notes;
  List<String> _errors = const [];
  List<String> _warnings = const [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName ?? '');
    _brand = TextEditingController();
    _barcode = TextEditingController(text: widget.initialBarcode ?? '');
    _cuisine = TextEditingController();
    _serving = TextEditingController(text: '100');
    _portionName = TextEditingController();
    _energy = TextEditingController();
    _protein = TextEditingController();
    _carb = TextEditingController();
    _fat = TextEditingController();
    _fibre = TextEditingController();
    _notes = TextEditingController();
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _brand,
      _barcode,
      _cuisine,
      _serving,
      _portionName,
      _energy,
      _protein,
      _carb,
      _fat,
      _fibre,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parseOptional(String raw) {
    final t = raw.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  ProductSubmission _buildSubmission() {
    final now = DateTime.now();
    return ProductSubmission(
      id: 'sub_${now.millisecondsSinceEpoch}',
      name: _name.text.trim(),
      createdAt: now,
      updatedAt: now,
      brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
      barcode: _barcode.text.trim().isEmpty ? null : _barcode.text.trim(),
      cuisine: _cuisine.text.trim().isEmpty ? null : _cuisine.text.trim(),
      defaultServingGrams: _parseOptional(_serving.text) ?? 100,
      portionName:
          _portionName.text.trim().isEmpty ? null : _portionName.text.trim(),
      energyKcalPer100g: _parseOptional(_energy.text),
      proteinGPer100g: _parseOptional(_protein.text),
      carbohydrateGPer100g: _parseOptional(_carb.text),
      fatGPer100g: _parseOptional(_fat.text),
      fibreGPer100g: _parseOptional(_fibre.text),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
  }

  String _msg(AppLocalizations l10n, String key) {
    switch (key) {
      case 'addProductErrorNameRequired':
        return l10n.addProductErrorNameRequired;
      case 'addProductErrorNameShort':
        return l10n.addProductErrorNameShort;
      case 'addProductErrorServingInvalid':
        return l10n.addProductErrorServingInvalid;
      case 'addProductErrorBarcodeInvalid':
        return l10n.addProductErrorBarcodeInvalid;
      case 'addProductErrorEnergyInvalid':
        return l10n.addProductErrorEnergyInvalid;
      case 'addProductErrorProteinInvalid':
        return l10n.addProductErrorProteinInvalid;
      case 'addProductErrorCarbInvalid':
        return l10n.addProductErrorCarbInvalid;
      case 'addProductErrorFatInvalid':
        return l10n.addProductErrorFatInvalid;
      case 'addProductErrorFibreInvalid':
        return l10n.addProductErrorFibreInvalid;
      case 'addProductWarningNoNutrition':
        return l10n.addProductWarningNoNutrition;
      case 'addProductWarningNoEnergy':
        return l10n.addProductWarningNoEnergy;
      case 'addProductWarningMacrosHigh':
        return l10n.addProductWarningMacrosHigh;
      default:
        return key;
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _errors = const [];
      _warnings = const [];
    });
    final submission = _buildSubmission();
    final result = await ref
        .read(addProductControllerProvider.notifier)
        .submitAndPublish(submission);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _errors = result.errors;
      _warnings = result.warnings;
    });
    if (!result.isValid) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.addProductPublished)),
    );
    context.push('/food/${Uri.encodeComponent(submission.publishedFoodId)}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addProductTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.addProductIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addProductProvenanceNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.addProductNameLabel),
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              controller: _brand,
              decoration: InputDecoration(labelText: l10n.addProductBrandLabel),
            ),
            TextField(
              controller: _barcode,
              decoration:
                  InputDecoration(labelText: l10n.addProductBarcodeLabel),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cuisine,
              decoration:
                  InputDecoration(labelText: l10n.addProductCuisineLabel),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.addProductServingSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextField(
              controller: _serving,
              decoration:
                  InputDecoration(labelText: l10n.addProductServingGramsLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _portionName,
              decoration:
                  InputDecoration(labelText: l10n.addProductPortionNameLabel),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.addProductNutritionSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              l10n.addProductNutritionHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            TextField(
              controller: _energy,
              decoration:
                  InputDecoration(labelText: l10n.addProductEnergyLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _protein,
              decoration:
                  InputDecoration(labelText: l10n.addProductProteinLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _carb,
              decoration: InputDecoration(labelText: l10n.addProductCarbLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _fat,
              decoration: InputDecoration(labelText: l10n.addProductFatLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _fibre,
              decoration:
                  InputDecoration(labelText: l10n.addProductFibreLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _notes,
              decoration: InputDecoration(labelText: l10n.addProductNotesLabel),
              maxLines: 2,
            ),
            if (_errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._errors.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _msg(l10n, e),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ],
            if (_warnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._warnings.map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _msg(l10n, w),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.publish_outlined),
              label: Text(l10n.addProductSubmit),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addProductSubmitNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
