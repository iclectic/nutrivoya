import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/product_submission.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/add_product/product_submission_repository.dart';
import 'package:nutrivoya/features/food/food_repository.dart';
import 'package:nutrivoya/features/food/food_search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalPreferences prefs;
  late ProductSubmissionRepository repo;
  final now = DateTime(2024, 6, 1, 12);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = LocalPreferences(await SharedPreferences.getInstance());
    repo = ProductSubmissionRepository(prefs);
  });

  ProductSubmission submission({
    String id = 'sub_1',
    String name = 'Diaspora snack mix',
    ProductSubmissionStatus status = ProductSubmissionStatus.pendingReview,
    double? energy,
  }) {
    return ProductSubmission(
      id: id,
      name: name,
      createdAt: now,
      updatedAt: now,
      status: status,
      brand: 'Home',
      barcode: '5012345678900',
      defaultServingGrams: 40,
      energyKcalPer100g: energy,
      proteinGPer100g: energy == null ? null : 5,
    );
  }

  group('ProductSubmissionRepository', () {
    test('save list delete round-trip', () async {
      await repo.save(submission());
      expect(repo.list(), hasLength(1));
      expect(repo.getById('sub_1')!.name, 'Diaspora snack mix');
      await repo.delete('sub_1');
      expect(repo.list(), isEmpty);
    });

    test('publishedFoods includes pending and verified, not drafts/rejected',
        () async {
      await repo.save(submission(status: ProductSubmissionStatus.draft));
      await repo.save(
        submission(
          id: 'sub_2',
          name: 'Pending mix',
          energy: 180,
          status: ProductSubmissionStatus.pendingReview,
        ),
      );
      await repo.save(
        submission(
          id: 'sub_3',
          name: 'Verified mix',
          energy: 200,
          status: ProductSubmissionStatus.verified,
        ),
      );
      await repo.save(
        submission(
          id: 'sub_4',
          name: 'Rejected mix',
          status: ProductSubmissionStatus.rejected,
        ),
      );
      final foods = repo.publishedFoods();
      expect(foods.map((f) => f.id), containsAll(['user:sub_2', 'user:sub_3']));
      expect(foods.map((f) => f.id), isNot(contains('user:sub_4')));
      final pending = foods.firstWhere((f) => f.id == 'user:sub_2');
      expect(pending.source.type, FoodSourceType.userSubmitted);
      expect(pending.source.reviewStatus, ReviewStatus.pending);
      final verified = foods.firstWhere((f) => f.id == 'user:sub_3');
      expect(verified.source.reviewStatus, ReviewStatus.verified);
    });

    test('publishedFoodById ignores drafts', () async {
      await repo.save(submission(status: ProductSubmissionStatus.draft));
      expect(repo.publishedFoodById('user:sub_1'), isNull);
    });
  });

  group('CompositeFoodRepository user foods', () {
    test('search and getById include pending user submissions', () async {
      await repo.save(
        submission(
          id: 'sub_x',
          name: 'UniqueNutrivoyaSnack',
          status: ProductSubmissionStatus.pendingReview,
        ),
      );
      final composite = CompositeFoodRepository(
        searchService: const FoodSearchService(),
        userFoods: () => repo.publishedFoods(),
      );
      final results = await composite.search('UniqueNutrivoyaSnack');
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'user:sub_x');
      final byId = await composite.getById('user:sub_x');
      expect(byId, isNotNull);
      expect(byId!.source.type, FoodSourceType.userSubmitted);
      // Missing nutrition stays empty — never invented.
      expect(byId.nutrientsPer100g, isEmpty);
    });
  });
}
