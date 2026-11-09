import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/product_submission.dart';
import '../../core/services/product_submission_validator.dart';
import 'product_submission_repository.dart';
import 'submission_review_service.dart';

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

final pendingReviewSubmissionsProvider =
    Provider.autoDispose<List<ProductSubmission>>((ref) {
  ref.watch(productSubmissionsRevisionProvider);
  return ref.watch(productSubmissionRepositoryProvider).pendingReview();
});

final publishedUserFoodsProvider =
    Provider.autoDispose<List<Food>>((ref) {
  ref.watch(productSubmissionsRevisionProvider);
  return ref.watch(productSubmissionRepositoryProvider).publishedFoods();
});

final reviewerModeProvider = Provider<bool>((ref) {
  ref.watch(productSubmissionsRevisionProvider);
  return ref.watch(submissionReviewServiceProvider).isReviewerMode;
});

class AddProductController extends Notifier {
  @override
  void build() {}

  ProductSubmissionRepository get _repo =>
      ref.read(productSubmissionRepositoryProvider);
  ProductSubmissionValidator get _validator =>
      ref.read(productSubmissionValidatorProvider);
  SubmissionReviewService get _review =>
      ref.read(submissionReviewServiceProvider);

  void _bump() =>
      ref.read(productSubmissionsRevisionProvider.notifier).state++;

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
        syncPending: true,
      ),
    );
    _bump();
    return result;
  }

  /// Submit for review and add to the personal library as pending —
  /// never as authoritative / verified.
  Future<ProductSubmissionValidation> submitAndPublish(
    ProductSubmission submission,
  ) async {
    final result = _validator.validate(submission);
    if (!result.isValid) return result;
    final now = DateTime.now();
    await _repo.save(
      submission.copyWith(
        status: ProductSubmissionStatus.pendingReview,
        updatedAt: now,
        syncPending: true,
        clearReview: true,
      ),
    );
    _bump();
    _review.syncSafely();
    return result;
  }

  Future<void> withdraw(String id) async {
    final existing = _repo.getById(id);
    if (existing == null) return;
    await _repo.save(
      existing.copyWith(
        status: ProductSubmissionStatus.withdrawn,
        updatedAt: DateTime.now(),
        syncPending: true,
      ),
    );
    _bump();
    _review.syncSafely();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _bump();
  }

  Future<bool> approve(String id, {String? notes}) async {
    final updated = await _review.approve(id, notes: notes);
    if (updated == null) return false;
    _bump();
    _review.syncSafely();
    return true;
  }

  Future<bool> reject(String id, {String? notes}) async {
    final updated = await _review.reject(id, notes: notes);
    if (updated == null) return false;
    _bump();
    _review.syncSafely();
    return true;
  }

  Future<void> setReviewerMode(bool enabled) async {
    await _review.setReviewerMode(enabled);
    _bump();
  }
}

final addProductControllerProvider =
    NotifierProvider<AddProductController, void>(AddProductController.new);
