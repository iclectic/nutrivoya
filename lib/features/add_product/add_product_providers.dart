import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/product_submission.dart';
import '../../core/services/product_submission_validator.dart';
import 'product_submission_repository.dart';

final productSubmissionValidatorProvider =
    Provider<ProductSubmissionValidator>((ref) {
  return const ProductSubmissionValidator();
});

final productSubmissionsRevisionProvider = StateProvider<int>((ref) => 0);

final productSubmissionsProvider =
    Provider.autoDispose<List<ProductSubmission>>((ref) {
  ref.watch(productSubmissionsRevisionProvider);
  return ref.watch(productSubmissionRepositoryProvider).list();
});

final publishedUserFoodsProvider =
    Provider.autoDispose<List<Food>>((ref) {
  ref.watch(productSubmissionsRevisionProvider);
  return ref.watch(productSubmissionRepositoryProvider).publishedFoods();
});

class AddProductController extends Notifier {
  @override
  void build() {}

  ProductSubmissionRepository get _repo =>
      ref.read(productSubmissionRepositoryProvider);
  ProductSubmissionValidator get _validator =>
      ref.read(productSubmissionValidatorProvider);

  ProductSubmissionValidation validate(ProductSubmission submission) =>
      _validator.validate(submission);

  Future<ProductSubmissionValidation> saveDraft(
    ProductSubmission submission,
  ) async {
    final result = _validator.validate(submission);
    if (!result.isValid) return result;
    await _repo.save(
      submission.copyWith(
        status: ProductSubmissionStatus.draft,
        updatedAt: DateTime.now(),
      ),
    );
    ref.read(productSubmissionsRevisionProvider.notifier).state++;
    return result;
  }

  /// Submit for review and publish into the personal library immediately as
  /// `userSubmitted` + pending — never as authoritative.
  Future<ProductSubmissionValidation> submitAndPublish(
    ProductSubmission submission,
  ) async {
    final result = _validator.validate(submission);
    if (!result.isValid) return result;
    final now = DateTime.now();
    await _repo.save(
      submission.copyWith(
        status: ProductSubmissionStatus.publishedLocally,
        updatedAt: now,
      ),
    );
    ref.read(productSubmissionsRevisionProvider.notifier).state++;
    return result;
  }

  Future<void> withdraw(String id) async {
    final existing = _repo.getById(id);
    if (existing == null) return;
    await _repo.save(
      existing.copyWith(
        status: ProductSubmissionStatus.withdrawn,
        updatedAt: DateTime.now(),
      ),
    );
    ref.read(productSubmissionsRevisionProvider.notifier).state++;
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    ref.read(productSubmissionsRevisionProvider.notifier).state++;
  }
}

final addProductControllerProvider =
    NotifierProvider<AddProductController, void>(AddProductController.new);
