import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/api/supabase_bootstrap.dart';
import '../../../core/database/diary_database.dart';
import '../../../core/storage/local_preferences.dart';
import '../../auth/auth_controller.dart';
import '../diary_providers.dart';
import '../diary_repository.dart';

/// Remote storage for diary rows (snake_case JSON maps).
abstract class DiaryRemoteDataSource {
  Future<void> upsert(List<Map<String, dynamic>> rows);
  Future<List<Map<String, dynamic>>> changedSince(DateTime? since);
}

/// Supabase `diary_entries` table (see `supabase/migrations`). Row-level
/// security restricts every row to its owner.
class SupabaseDiaryRemoteDataSource implements DiaryRemoteDataSource {
  SupabaseDiaryRemoteDataSource(this._client, this._userId);

  final SupabaseClient _client;
  final String _userId;
  static const table = 'diary_entries';

  @override
  Future<void> upsert(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    await _client
        .from(table)
        .upsert([for (final r in rows) {...r, 'user_id': _userId}]);
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
class SyncResult {
  const SyncResult({required this.pushed, required this.pulled});
  final int pushed;
  final int pulled;
}

/// Two-way, offline-first diary sync.
///
/// 1. Push: every `syncPending` row (including soft deletes) is upserted.
///    Pushed deletions are then purged locally.
/// 2. Pull: remote rows changed since the last pull are merged with
///    last-write-wins against unsynced local edits.
class DiarySyncService {
  DiarySyncService({
    required DiaryRepository repository,
    required DiaryRemoteDataSource remote,
    required LocalPreferences prefs,
    required String userId,
  })  : _repo = repository,
        _remote = remote,
        _prefs = prefs,
        _lastPullKey = 'nutrivoya.diary.lastPull.$userId';

  final DiaryRepository _repo;
  final DiaryRemoteDataSource _remote;
  final LocalPreferences _prefs;
  final String _lastPullKey;
  Future<SyncResult>? _inFlight;

  Future<SyncResult> sync() => _inFlight ??= _run().whenComplete(() {
        _inFlight = null;
      });

  /// Fire-and-forget sync; failures leave rows pending for the next attempt.
  Future<void> syncSafely() async {
    try {
      await sync();
    } catch (e) {
      if (kDebugMode) debugPrint('[Sync] failed: $e');
    }
  }

  Future<SyncResult> _run() async {
    final pending = await _repo.pendingRows();
    await _remote.upsert(pending.map(toRemote).toList());
    await _repo.markSynced(pending);

    final lastPull = DateTime.tryParse(_prefs.getString(_lastPullKey) ?? '');
    final changes = await _remote.changedSince(lastPull);
    DateTime? newest = lastPull;
    for (final row in changes) {
      final companion = fromRemote(row);
      await _repo.applyRemote(companion);
      final updated = companion.updatedAt.value;
      if (updated != null && (newest == null || updated.isAfter(newest))) {
        newest = updated;
      }
    }
    if (newest != null) {
      await _prefs.setString(_lastPullKey, newest.toUtc().toIso8601String());
    }
    return SyncResult(pushed: pending.length, pulled: changes.length);
  }

  static Map<String, dynamic> toRemote(DiaryEntryRow r) => {
        'id': r.remoteId,
        'food_id': r.foodId,
        'food_name': r.foodName,
        'food_canonical_name': r.foodCanonicalName,
        'meal_type': r.mealType,
        'grams': r.grams,
        'portion_name': r.portionName,
        'quantity': r.quantity,
        'calories_kcal': r.caloriesKcal,
        'protein_g': r.proteinG,
        'carbohydrate_g': r.carbohydrateG,
        'fat_g': r.fatG,
        'fibre_g': r.fibreG,
        'confidence': r.confidence,
        'source_name': r.sourceName,
        'logged_at': r.loggedAt.toUtc().toIso8601String(),
        'updated_at': (r.updatedAt ?? r.createdAt).toUtc().toIso8601String(),
        'deleted_at': r.deletedAt?.toUtc().toIso8601String(),
      };

  static DiaryEntriesCompanion fromRemote(Map<String, dynamic> m) {
    DateTime? date(String key) {
      final v = m[key];
      return v == null ? null : DateTime.parse(v as String).toLocal();
    }

    double? num_(String key) => (m[key] as num?)?.toDouble();
    return DiaryEntriesCompanion(
      remoteId: Value(m['id'] as String),
      foodId: Value(m['food_id'] as String),
      foodName: Value(m['food_name'] as String),
      foodCanonicalName: Value(m['food_canonical_name'] as String),
      mealType: Value(m['meal_type'] as String),
      grams: Value((m['grams'] as num).toDouble()),
      portionName: Value(m['portion_name'] as String?),
      quantity: Value((m['quantity'] as num?)?.toInt() ?? 1),
      caloriesKcal: Value(num_('calories_kcal')),
      proteinG: Value(num_('protein_g')),
      carbohydrateG: Value(num_('carbohydrate_g')),
      fatG: Value(num_('fat_g')),
      fibreG: Value(num_('fibre_g')),
      confidence: Value(m['confidence'] as String? ?? 'unknown'),
      sourceName: Value(m['source_name'] as String?),
      loggedAt: Value(date('logged_at')!),
      updatedAt: Value(date('updated_at')),
      deletedAt: Value(date('deleted_at')),
      syncPending: const Value(false),
    );
  }
}

/// Sync service for the signed-in Supabase user; `null` in local-only mode.
final diarySyncServiceProvider = Provider<DiarySyncService?>((ref) {
  final auth = ref.watch(authControllerProvider);
  final client = SupabaseBootstrap.client;
  if (client == null ||
      auth is! Authenticated ||
      auth.userId == AuthController.localUserId) {
    return null;
  }
  return DiarySyncService(
    repository: ref.watch(diaryRepositoryProvider),
    remote: SupabaseDiaryRemoteDataSource(client, auth.userId),
    prefs: ref.watch(localPreferencesSyncProvider),
    userId: auth.userId,
  );
});

/// Triggers a sync whenever a sync service becomes available (sign-in/launch).
final diaryAutoSyncProvider = Provider<void>((ref) {
  ref.listen<DiarySyncService?>(
    diarySyncServiceProvider,
    (_, next) => next?.syncSafely(),
    fireImmediately: true,
  );
});
