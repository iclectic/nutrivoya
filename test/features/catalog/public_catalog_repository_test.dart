import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/product_submission.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/catalog/public_catalog_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalPreferences prefs;
  late PublicCatalogRepository catalog;
  final now = DateTime(2024, 8, 1);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = LocalPreferences(await SharedPreferences.getInstance());
    catalog = PublicCatalogRepository(prefs);
  });

  ProductSubmission verified({String id = 'sub_c', double? energy}) {
    return ProductSubmission(
      id: id,
      name: 'Community sambhar',
      createdAt: now,
      updatedAt: now,
      status: ProductSubmissionStatus.verified,
      energyKcalPer100g: energy,
      proteinGPer100g: energy == null ? null : 4,
    );
  }

  test('publish requires verified status', () async {
    final pending = verified().copyWith(
      status: ProductSubmissionStatus.pendingReview,
    );
    expect(() => catalog.publish(pending), throwsStateError);
  });

  test('publish keeps userSubmitted verified provenance and null nutrition',
      () async {
    await catalog.publish(verified(energy: null));
    final food = catalog.foods().single;
    expect(food.source.type, FoodSourceType.userSubmitted);
    expect(food.source.reviewStatus, ReviewStatus.verified);
    expect(food.nutrientsPer100g, isEmpty);
  });

  test('publish does not invent macros when energy is present alone', () async {
    await catalog.publish(verified(energy: 70));
    final food = catalog.foods().single;
    expect(food.nutrientsPer100g.length, 2); // energy + protein from fixture
  });
}
