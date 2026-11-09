import '../models/product_submission.dart';

/// Validation result for a user product submission.
class ProductSubmissionValidation {
  const ProductSubmissionValidation({
    this.errors = const [],
    this.warnings = const [],
  });

  final List<String> errors;
  final List<String> warnings;

  bool get isValid => errors.isEmpty;
}

/// Validates user-contributed foods.
///
/// Missing nutrition is allowed (stays unavailable). Implausible numbers are
/// rejected rather than silently “fixed”.
class ProductSubmissionValidator {
  const ProductSubmissionValidator();

  ProductSubmissionValidation validate(ProductSubmission submission) {
    final errors = <String>[];
    final warnings = <String>[];

    final name = submission.name.trim();
    if (name.isEmpty) {
      errors.add('addProductErrorNameRequired');
    } else if (name.length < 2) {
      errors.add('addProductErrorNameShort');
    }

    final serving = submission.defaultServingGrams;
    if (serving != null && (serving <= 0 || serving > 5000)) {
      errors.add('addProductErrorServingInvalid');
    }

    final barcode = submission.barcode?.trim();
    if (barcode != null && barcode.isNotEmpty) {
      final digits = barcode.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 8 || digits.length > 14) {
        errors.add('addProductErrorBarcodeInvalid');
      }
    }

    void checkMacro(String key, double? value, {double max = 1000}) {
      if (value == null) return;
      if (value < 0 || value > max) {
        errors.add(key);
      }
    }

    checkMacro('addProductErrorEnergyInvalid', submission.energyKcalPer100g,
        max: 950);
    checkMacro('addProductErrorProteinInvalid', submission.proteinGPer100g);
    checkMacro('addProductErrorCarbInvalid', submission.carbohydrateGPer100g);
    checkMacro('addProductErrorFatInvalid', submission.fatGPer100g);
    checkMacro('addProductErrorFibreInvalid', submission.fibreGPer100g);

    if (!submission.hasAnyNutrition) {
      warnings.add('addProductWarningNoNutrition');
    } else if (submission.energyKcalPer100g == null) {
      warnings.add('addProductWarningNoEnergy');
    }

    final p = submission.proteinGPer100g ?? 0;
    final c = submission.carbohydrateGPer100g ?? 0;
    final f = submission.fatGPer100g ?? 0;
    if (submission.hasAnyNutrition && (p + c + f) > 110) {
      warnings.add('addProductWarningMacrosHigh');
    }

    return ProductSubmissionValidation(errors: errors, warnings: warnings);
  }
}
