import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/product_submission.dart';
import '../../core/storage/local_preferences.dart';

/// Offline store for user-contributed product submissions.
///
/// Submissions are never treated as authoritative. Published entries become
/// personal-library foods with `userSubmitted` provenance and pending review.
class ProductSubmissionRepository {
  ProductSubmissionRepository(this._prefs);

  static const _key = 'nutrivoya.product_submissions.v1';

  final LocalPreferences _prefs;

  List<ProductSubmission> list() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (e) =>
                ProductSubmission.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      return const [];
    }
  }

  ProductSubmission? getById(String id) {
    for (final s in list()) {
      if (s.id == id) return s;
    }
    return null;
  }

  Future<void> save(ProductSubmission submission) async {
    final items = list().where((s) => s.id != submission.id).toList();
    items.add(submission);
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _persist(items);
  }

  Future<void> delete(String id) async {
    await _persist(list().where((s) => s.id != id).toList());
  }

  /// Foods published into the personal library (searchable offline).
  List<Food> publishedFoods() {
    return list()
        .where((s) => s.status == ProductSubmissionStatus.publishedLocally)
        .map((s) => s.toFood())
        .toList();
  }

  Food? publishedFoodById(String id) {
    if (!id.startsWith('user:')) return null;
    final submissionId = id.substring(5);
    final submission = getById(submissionId);
    if (submission == null ||
        submission.status != ProductSubmissionStatus.publishedLocally) {
      return null;
    }
    return submission.toFood();
  }

  Future<void> _persist(List<ProductSubmission> items) {
    return _prefs.setString(
      _key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}

final productSubmissionRepositoryProvider =
    Provider<ProductSubmissionRepository>((ref) {
  return ProductSubmissionRepository(ref.watch(localPreferencesSyncProvider));
});
