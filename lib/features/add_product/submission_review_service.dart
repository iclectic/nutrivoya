import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/api/supabase_bootstrap.dart';
import '../../core/models/product_submission.dart';
import '../../core/storage/local_preferences.dart';
import '../auth/auth_controller.dart';
import 'product_submission_repository.dart';

/// Remote store for product submissions (snake_case JSON).
abstract class ProductSubmissionRemoteDataSource {
  Future<void> upsert(List<Map<String, dynamic>> rows);
  Future<List<Map<String, dynamic>>> changedSince(DateTime? since);
}

class SupabaseProductSubmissionRemote
    implements ProductSubmissionRemoteDataSource {
  SupabaseProductSubmissionRemote(this._client, this._userId);

  final SupabaseClient _client;
  final String _userId;
  static const table = 'product_submissions';

  @override
  Future<void> upsert(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    await _client.from(table).upsert([
      for (final r in rows) {...r, 'user_id': _userId},
    ]);
  }

  @override
  Future<List<Map<String, dynamic>>> changedSince(DateTime? since) async {
    var query = _client.from(table).select().eq('user_id', _userId);
    if (since != null) {
      query = query.gt('updated_at', since.toUtc().toIso8601String());
    }
    final rows = await query.order('updated_at');
    return List<Map<String, dynamic>>.from(rows);
  }
}

@immutable
class SubmissionSyncResult {
  const SubmissionSyncResult({required this.pushed, required this.pulled});
  final int pushed;
  final int pulled;
}

/// Review + sync for user-contributed foods.
///
/// Approve / reject never invent nutrition — they only change review status
/// and provenance. Remote sync is a no-op without Supabase.
class SubmissionReviewService {
  SubmissionReviewService({
    required ProductSubmissionRepository repository,
    required LocalPreferences prefs,
    required String actorId,
    ProductSubmissionRemoteDataSource? remote,
  })  : _repo = repository,
        _prefs = prefs,
        _actorId = actorId,
        _remote = remote,
        _lastPullKey = 'nutrivoya.submissions.lastPull.$actorId';

  final ProductSubmissionRepository _repo;
  final LocalPreferences _prefs;
  final String _actorId;
  final ProductSubmissionRemoteDataSource? _remote;
  final String _lastPullKey;

  static const reviewerModeKey = 'nutrivoya.reviewerMode';

  bool get isReviewerMode => _prefs.getString(reviewerModeKey) == 'true';

  Future<void> setReviewerMode(bool enabled) =>
      _prefs.setString(reviewerModeKey, enabled ? 'true' : 'false');

  /// Approve a pending submission. Does not invent missing macros.
  Future<ProductSubmission?> approve(
    String id, {
    String? notes,
  }) async {
    final existing = _repo.getById(id);
    if (existing == null || !existing.status.awaitsReview) return null;
    final now = DateTime.now();
    final updated = existing.copyWith(
      status: ProductSubmissionStatus.verified,
      reviewNotes: notes,
      reviewedAt: now,
      reviewedBy: _actorId,
      updatedAt: now,
      syncPending: true,
    );
    await _repo.save(updated);
    return updated;
  }

  /// Reject a pending submission. Removes it from the personal library.
  Future<ProductSubmission?> reject(
    String id, {
    String? notes,
  }) async {
    final existing = _repo.getById(id);
    if (existing == null || !existing.status.awaitsReview) return null;
    final now = DateTime.now();
    final updated = existing.copyWith(
      status: ProductSubmissionStatus.rejected,
      reviewNotes: notes,
      reviewedAt: now,
      reviewedBy: _actorId,
      updatedAt: now,
      syncPending: true,
    );
    await _repo.save(updated);
    return updated;
  }

  Future<SubmissionSyncResult> syncSafely() async {
    try {
      return await sync();
    } catch (e) {
      if (kDebugMode) debugPrint('[SubmissionSync] failed: $e');
      return const SubmissionSyncResult(pushed: 0, pulled: 0);
    }
  }

  Future<SubmissionSyncResult> sync() async {
    final remote = _remote;
    if (remote == null) {
      return const SubmissionSyncResult(pushed: 0, pulled: 0);
    }

    final pending = _repo.pendingSync();
    await remote.upsert(pending.map(toRemote).toList());
    await _repo.markSynced(pending.map((e) => e.id));

    final lastPull = DateTime.tryParse(_prefs.getString(_lastPullKey) ?? '');
    final changes = await remote.changedSince(lastPull);
    DateTime? newest = lastPull;
    for (final row in changes) {
      final submission = fromRemote(row);
      await _repo.applyRemote(submission);
      if (newest == null || submission.updatedAt.isAfter(newest)) {
        newest = submission.updatedAt;
      }
    }
    if (newest != null) {
      await _prefs.setString(_lastPullKey, newest.toUtc().toIso8601String());
    }
    return SubmissionSyncResult(pushed: pending.length, pulled: changes.length);
  }

  static Map<String, dynamic> toRemote(ProductSubmission s) => {
        'id': s.id,
        'name': s.name,
        'status': s.status.id,
        'brand': s.brand,
        'barcode': s.barcode,
        'cuisine': s.cuisine,
        'default_serving_grams': s.defaultServingGrams,
        'portion_name': s.portionName,
        'energy_kcal_per_100g': s.energyKcalPer100g,
        'protein_g_per_100g': s.proteinGPer100g,
        'carbohydrate_g_per_100g': s.carbohydrateGPer100g,
        'fat_g_per_100g': s.fatGPer100g,
        'fibre_g_per_100g': s.fibreGPer100g,
        'notes': s.notes,
        'review_notes': s.reviewNotes,
        'reviewed_at': s.reviewedAt?.toUtc().toIso8601String(),
        'reviewed_by': s.reviewedBy,
        'created_at': s.createdAt.toUtc().toIso8601String(),
        'updated_at': s.updatedAt.toUtc().toIso8601String(),
      };

  static ProductSubmission fromRemote(Map<String, dynamic> m) {
    DateTime? date(String key) {
      final v = m[key];
      return v == null ? null : DateTime.parse(v as String).toLocal();
    }

    double? num_(String key) => (m[key] as num?)?.toDouble();

    return ProductSubmission(
      id: m['id'] as String,
      name: m['name'] as String,
      createdAt: date('created_at') ?? DateTime.now(),
      updatedAt: date('updated_at') ?? DateTime.now(),
      status: ProductSubmissionStatusX.fromId(
        m['status'] as String? ?? 'pendingReview',
      ),
      brand: m['brand'] as String?,
      barcode: m['barcode'] as String?,
      cuisine: m['cuisine'] as String?,
      defaultServingGrams: num_('default_serving_grams'),
      portionName: m['portion_name'] as String?,
      energyKcalPer100g: num_('energy_kcal_per_100g'),
      proteinGPer100g: num_('protein_g_per_100g'),
      carbohydrateGPer100g: num_('carbohydrate_g_per_100g'),
      fatGPer100g: num_('fat_g_per_100g'),
      fibreGPer100g: num_('fibre_g_per_100g'),
      notes: m['notes'] as String?,
      reviewNotes: m['review_notes'] as String?,
      reviewedAt: date('reviewed_at'),
      reviewedBy: m['reviewed_by'] as String?,
      syncPending: false,
    );
  }
}

final submissionReviewServiceProvider =
    Provider<SubmissionReviewService>((ref) {
  final auth = ref.watch(authControllerProvider);
  final userId = auth is Authenticated
      ? auth.userId
      : AuthController.localUserId;
  final client = SupabaseBootstrap.client;
  ProductSubmissionRemoteDataSource? remote;
  if (client != null &&
      auth is Authenticated &&
      auth.userId != AuthController.localUserId) {
    remote = SupabaseProductSubmissionRemote(client, auth.userId);
  }
  return SubmissionReviewService(
    repository: ref.watch(productSubmissionRepositoryProvider),
    prefs: ref.watch(localPreferencesSyncProvider),
    actorId: userId,
    remote: remote,
  );
});

final submissionAutoSyncProvider = Provider<void>((ref) {
  ref.watch(submissionReviewServiceProvider).syncSafely();
});
