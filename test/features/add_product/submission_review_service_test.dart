import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/product_submission.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/add_product/product_submission_repository.dart';
import 'package:nutrivoya/features/add_product/submission_review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRemote implements ProductSubmissionRemoteDataSource {
  final Map<String, Map<String, dynamic>> rows = {};
  bool fail = false;

  @override
  Future<void> upsert(List<Map<String, dynamic>> batch) async {
    if (fail) throw Exception('offline');
    for (final r in batch) {
      rows[r['id'] as String] = Map<String, dynamic>.from(r);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> changedSince(DateTime? since) async {
    return rows.values
        .where(
          (r) =>
              since == null ||
              DateTime.parse(r['updated_at'] as String).isAfter(since),
        )
        .toList();
  }
}

void main() {
  late LocalPreferences prefs;
  late ProductSubmissionRepository repo;
  late _FakeRemote remote;
  late SubmissionReviewService review;
  final now = DateTime(2024, 7, 1, 10);

  ProductSubmission pending({
    String id = 'sub_1',
    String name = 'Home chutney',
    double? energy,
  }) {
    return ProductSubmission(
      id: id,
      name: name,
      createdAt: now,
      updatedAt: now,
      status: ProductSubmissionStatus.pendingReview,
      energyKcalPer100g: energy,
      proteinGPer100g: energy == null ? null : 2,
      syncPending: true,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = LocalPreferences(await SharedPreferences.getInstance());
    repo = ProductSubmissionRepository(prefs);
    remote = _FakeRemote();
    review = SubmissionReviewService(
      repository: repo,
      prefs: prefs,
      actorId: 'reviewer-1',
      remote: remote,
    );
  });

  group('SubmissionReviewService', () {
    test('approve upgrades provenance without inventing nutrition', () async {
      await repo.save(pending(energy: null));
      final updated = await review.approve('sub_1', notes: 'Looks plausible');
      expect(updated!.status, ProductSubmissionStatus.verified);
      expect(updated.reviewedBy, 'reviewer-1');
      expect(updated.reviewNotes, 'Looks plausible');
      final food = updated.toFood();
      expect(food.source.reviewStatus, ReviewStatus.verified);
      expect(food.nutrientsPer100g, isEmpty);
      expect(food.source.type, FoodSourceType.userSubmitted);
    });

    test('approve keeps declared energy and does not add macros', () async {
      await repo.save(pending(energy: 90));
      final food = (await review.approve('sub_1'))!.toFood();
      expect(
        food.nutrientsPer100g.containsKey(NutrientCode.energyKcal),
        isTrue,
      );
      expect(food.nutrientsPer100g.containsKey(NutrientCode.fatG), isFalse);
      expect(food.source.confidence.name, 'medium');
    });

    test('reject removes submission from personal library', () async {
      await repo.save(pending());
      await review.reject('sub_1');
      expect(repo.publishedFoods(), isEmpty);
      expect(repo.getById('sub_1')!.status, ProductSubmissionStatus.rejected);
    });

    test('sync pushes pending then pulls remote status', () async {
      await repo.save(pending(id: 'sub_a', name: 'Local dish'));
      final result = await review.sync();
      expect(result.pushed, 1);
      expect(remote.rows['sub_a']?['status'], 'pendingReview');
      expect(repo.getById('sub_a')!.syncPending, isFalse);

      remote.rows['sub_a']!['status'] = 'verified';
      remote.rows['sub_a']!['updated_at'] =
          DateTime(2024, 7, 2).toUtc().toIso8601String();
      remote.rows['sub_a']!['reviewed_by'] = 'remote-reviewer';
      final pull = await review.sync();
      expect(pull.pulled, 1);
      expect(repo.getById('sub_a')!.status, ProductSubmissionStatus.verified);
      expect(repo.getById('sub_a')!.reviewedBy, 'remote-reviewer');
    });

    test('failed sync leaves syncPending true', () async {
      await repo.save(pending());
      remote.fail = true;
      await review.syncSafely();
      expect(repo.getById('sub_1')!.syncPending, isTrue);
    });
  });
}
