import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/api/supabase_bootstrap.dart';
import '../../core/models/food.dart';
import '../../core/models/food_source.dart';
import '../../core/models/product_submission.dart';
import '../../core/storage/local_preferences.dart';
import '../auth/auth_controller.dart';
import '../add_product/product_submission_repository.dart';

/// Offline + optional remote store for verified foods published to the catalog.
///
/// Only verifier-approved submissions may be published. Nutrition values are
/// copied as-is — never invented at publish time.
class PublicCatalogRepository {
  PublicCatalogRepository(this._prefs, {SupabaseClient? client})
      : _client = client;

  static const _key = 'nutrivoya.public_catalog.v1';

  final LocalPreferences _prefs;
  final SupabaseClient? _client;

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
          .where((s) => s.status == ProductSubmissionStatus.verified)
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      return const [];
    }
  }

  List<Food> foods() => list().map((s) => s.toFood()).toList();

  Future<void> publish(ProductSubmission submission) async {
    if (submission.status != ProductSubmissionStatus.verified) {
      throw StateError('Only verified submissions can join the public catalog');
    }
    final items = list().where((s) => s.id != submission.id).toList();
    items.add(submission);
    await _persist(items);

    final client = _client;
    if (client != null) {
      await client.from('public_food_catalog').upsert({
        'id': submission.id,
        'name': submission.name,
        'brand': submission.brand,
        'barcode': submission.barcode,
        'cuisine': submission.cuisine,
        'default_serving_grams': submission.defaultServingGrams,
        'portion_name': submission.portionName,
        'energy_kcal_per_100g': submission.energyKcalPer100g,
        'protein_g_per_100g': submission.proteinGPer100g,
        'carbohydrate_g_per_100g': submission.carbohydrateGPer100g,
        'fat_g_per_100g': submission.fatGPer100g,
        'fibre_g_per_100g': submission.fibreGPer100g,
        'updated_at': submission.updatedAt.toUtc().toIso8601String(),
      });
    }
  }

  Future<void> remove(String id) async {
    await _persist(list().where((s) => s.id != id).toList());
    final client = _client;
    if (client != null) {
      await client.from('public_food_catalog').delete().eq('id', id);
    }
  }

  Future<void> _persist(List<ProductSubmission> items) {
    return _prefs.setString(
      _key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}

final publicCatalogRevisionProvider = StateProvider<int>((ref) => 0);

final publicCatalogRepositoryProvider = Provider<PublicCatalogRepository>((ref) {
  final auth = ref.watch(authControllerProvider);
  final client = SupabaseBootstrap.client;
  final useRemote = client != null &&
      auth is Authenticated &&
      auth.userId != AuthController.localUserId;
  return PublicCatalogRepository(
    ref.watch(localPreferencesSyncProvider),
    client: useRemote ? client : null,
  );
});

final publicCatalogFoodsProvider = Provider.autoDispose<List<Food>>((ref) {
  ref.watch(publicCatalogRevisionProvider);
  return ref.watch(publicCatalogRepositoryProvider).foods();
});

/// Publish a verified personal submission into the shared catalog.
final catalogPublishControllerProvider =
    Provider<CatalogPublishController>((ref) {
  return CatalogPublishController(ref);
});

class CatalogPublishController {
  CatalogPublishController(this._ref);
  final Ref _ref;

  Future<bool> publishVerified(String submissionId) async {
    final submission =
        _ref.read(productSubmissionRepositoryProvider).getById(submissionId);
    if (submission == null ||
        submission.status != ProductSubmissionStatus.verified) {
      return false;
    }
    // Guard: still userSubmitted provenance after toFood().
    final food = submission.toFood();
    if (food.source.type != FoodSourceType.userSubmitted ||
        food.source.reviewStatus != ReviewStatus.verified) {
      return false;
    }
    await _ref.read(publicCatalogRepositoryProvider).publish(submission);
    _ref.read(publicCatalogRevisionProvider.notifier).state++;
    return true;
  }
}
