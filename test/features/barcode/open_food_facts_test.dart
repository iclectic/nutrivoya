import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/features/barcode/barcode_screens.dart';
import 'package:nutrivoya/features/barcode/open_food_facts_adapter.dart';
import 'package:nutrivoya/features/food/food_providers.dart';

import '../../helpers/test_app.dart';

const _product = {
  'code': '4006381333931',
  'product_name': 'Masala oats',
  'brands': 'Saffola, Marico',
  'serving_size': '40 g',
  'serving_quantity': 40,
  'nutriments': {
    'energy-kj_100g': 1674,
    'proteins_100g': 11.0,
    'carbohydrates_100g': 65.0,
    'fat_100g': 9.0,
    'sodium_100g': 0.4,
  },
};

class _FakeRepo implements PackagedFoodRepository {
  _FakeRepo(this.result, {this.fail = false});
  final Map<String, dynamic>? result;
  final bool fail;
  @override
  Future<PackagedProduct?> lookup(String barcode) async {
    if (fail) throw Exception('offline');
    if (result == null) return null;
    return PackagedProduct(
      barcode: barcode,
      food: OpenFoodFactsAdapter.foodFromProduct(barcode, result!),
      raw: result!,
    );
  }
}

void main() {
  test('GTIN check digits', () {
    expect(isValidGtin('4006381333931'), isTrue);
    expect(isValidGtin('036000291452'), isTrue);
    expect(isValidGtin('4006381333932'), isFalse);
    expect(isValidGtin('12ab'), isFalse);
  });

  test('maps Open Food Facts product without inventing values', () {
    final food = OpenFoodFactsAdapter.foodFromProduct('4006381333931', _product);
    expect(food.id, 'off:4006381333931');
    expect(food.canonicalName, 'Masala oats (Saffola)');
    expect(food.nutrientPer100g(NutrientCode.energyKcal), closeTo(1674 / 4.184, 0.01));
    expect(food.nutrientPer100g(NutrientCode.sodiumMg), closeTo(400, 0.001));
    expect(food.nutrientPer100g(NutrientCode.fibreG), isNull);
    expect(food.portions.single.grams, 40);
    expect(food.source.type, FoodSourceType.packaged);
    expect(food.source.reviewStatus, ReviewStatus.unverified);
  });

  test('label checks flag mismatched or missing data', () {
    final ok = OpenFoodFactsAdapter.foodFromProduct('1', _product);
    expect(checkLabel(ok), isEmpty);
    final bad = OpenFoodFactsAdapter.foodFromProduct('1', {
      'nutriments': {'energy-kcal_100g': 50, 'proteins_100g': 20, 'carbohydrates_100g': 60, 'fat_100g': 10},
    });
    expect(checkLabel(bad), contains(LabelIssue.energyMismatch));
    final missing = OpenFoodFactsAdapter.foodFromProduct('1', {'nutriments': {}});
    expect(checkLabel(missing), containsAll([LabelIssue.missingEnergy, LabelIssue.missingMacros]));
  });

  testWidgets('product must be checked against the label before use', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer(overrides: [
      packagedFoodRepositoryProvider.overrideWithValue(_FakeRepo(_product)),
    ]);
    await tester.pumpWidget(testApp(c, const BarcodeProductScreen(barcode: '4006381333931'), extraRoutes: [
      GoRoute(path: '/food/:id', builder: (context, state) => Text('stub-food-${state.pathParameters['id']}')),
    ]));
    await tester.pumpAndSettle();
    expect(find.text('Masala oats (Saffola)'), findsOneWidget);
    final use = find.byKey(const Key('barcode-use'));
    expect(tester.widget<FilledButton>(use).onPressed, isNull);
    await tester.tap(find.byKey(const Key('barcode-verify')));
    await tester.pump();
    await tester.tap(use);
    await tester.pumpAndSettle();
    expect(find.text('stub-food-off:4006381333931'), findsOneWidget);
    c.listen(foodByIdProvider('off:4006381333931'), (_, _) {});
    final cached = await c.read(foodByIdProvider('off:4006381333931').future);
    expect(cached?.source.reviewStatus, ReviewStatus.pending);
  });

  testWidgets('unknown product and network failure show helpful messages', (tester) async {
    final c = await testContainer(overrides: [
      packagedFoodRepositoryProvider.overrideWithValue(_FakeRepo(null)),
    ]);
    await tester.pumpWidget(testApp(c, const BarcodeProductScreen(barcode: '036000291452')));
    await tester.pumpAndSettle();
    expect(find.textContaining('not found'), findsOneWidget);

    final c2 = await testContainer(overrides: [
      packagedFoodRepositoryProvider.overrideWithValue(_FakeRepo(null, fail: true)),
    ]);
    await tester.pumpWidget(testApp(c2, const BarcodeProductScreen(barcode: '036000291452')));
    await tester.pumpAndSettle();
    expect(find.textContaining("Couldn't reach"), findsOneWidget);
  });

  testWidgets('manual entry validates the barcode', (tester) async {
    final c = await testContainer();
    await tester.pumpWidget(testApp(c, const BarcodeScanScreen(showCamera: false), extraRoutes: [
      GoRoute(path: '/barcode/:code', builder: (context, state) => Text('stub-${state.pathParameters['code']}')),
    ]));
    await tester.enterText(find.byKey(const Key('barcode-manual')), '123');
    await tester.tap(find.byKey(const Key('barcode-lookup')));
    await tester.pump();
    expect(find.textContaining('valid barcode'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('barcode-manual')), '4006381333931');
    await tester.tap(find.byKey(const Key('barcode-lookup')));
    await tester.pumpAndSettle();
    expect(find.text('stub-4006381333931'), findsOneWidget);
  });
}
