import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/product_submission.dart';
import 'package:nutrivoya/core/services/product_submission_validator.dart';

void main() {
  const validator = ProductSubmissionValidator();
  final now = DateTime(2024, 6, 1);

  ProductSubmission base({
    String name = 'Homemade chutney',
    double? serving = 30,
    String? barcode,
    double? energy,
    double? protein,
    double? carb,
    double? fat,
    double? fibre,
  }) {
    return ProductSubmission(
      id: 'sub_test',
      name: name,
      createdAt: now,
      updatedAt: now,
      defaultServingGrams: serving,
      barcode: barcode,
      energyKcalPer100g: energy,
      proteinGPer100g: protein,
      carbohydrateGPer100g: carb,
      fatGPer100g: fat,
      fibreGPer100g: fibre,
    );
  }

  group('ProductSubmissionValidator', () {
    test('accepts name-only submission without inventing nutrition', () {
      final result = validator.validate(base());
      expect(result.isValid, isTrue);
      expect(result.warnings, contains('addProductWarningNoNutrition'));
      final food = base().toFood();
      expect(food.nutrientsPer100g, isEmpty);
      expect(food.source.type.name, 'userSubmitted');
      expect(food.source.reviewStatus.name, 'pending');
    });

    test('rejects empty name', () {
      final result = validator.validate(base(name: '  '));
      expect(result.isValid, isFalse);
      expect(result.errors, contains('addProductErrorNameRequired'));
    });

    test('rejects implausible energy rather than clamping', () {
      final result = validator.validate(base(energy: 1200));
      expect(result.isValid, isFalse);
      expect(result.errors, contains('addProductErrorEnergyInvalid'));
    });

    test('rejects short barcode', () {
      final result = validator.validate(base(barcode: '123'));
      expect(result.isValid, isFalse);
      expect(result.errors, contains('addProductErrorBarcodeInvalid'));
    });

    test('warns when macros present without energy', () {
      final result = validator.validate(base(protein: 10, carb: 20, fat: 5));
      expect(result.isValid, isTrue);
      expect(result.warnings, contains('addProductWarningNoEnergy'));
    });

    test('warns when macros sum over 110 g', () {
      final result = validator.validate(
        base(energy: 500, protein: 40, carb: 50, fat: 30),
      );
      expect(result.isValid, isTrue);
      expect(result.warnings, contains('addProductWarningMacrosHigh'));
    });

    test('toFood never fabricates missing macros', () {
      final food = base(energy: 120, protein: 8).toFood();
      expect(
        food.nutrientsPer100g.containsKey(NutrientCode.energyKcal),
        isTrue,
      );
      expect(
        food.nutrientsPer100g.containsKey(NutrientCode.fatG),
        isFalse,
      );
      expect(food.id, 'user:sub_test');
    });
  });
}
