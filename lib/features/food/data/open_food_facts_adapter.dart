import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/models/food.dart';
import '../../../core/models/food_name.dart';
import '../../../core/models/food_portion.dart';
import '../../../core/models/food_source.dart';
import '../../../core/models/nutrient.dart';
import '../../../core/models/nutrition_confidence.dart';
import 'packaged_food_repository.dart';

/// Open Food Facts adapter for barcode / packaged-food lookup.
///
/// Real HTTP client against the public OFF API. Crowdsourced data is mapped
/// with medium/estimated confidence and never presented as authoritative.
///
/// Docs: https://openfoodfacts.github.io/openfoodfacts-server/api/
class OpenFoodFactsAdapter implements PackagedFoodRepository {
  OpenFoodFactsAdapter({Dio? dio, this.userAgent = defaultUserAgent})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 12),
                headers: {
                  'User-Agent': userAgent,
                  'Accept': 'application/json',
                },
              ),
            );

  final Dio _dio;
  final String userAgent;

  /// OFF asks clients to identify themselves.
  static const defaultUserAgent =
      'Nutrivoya/1.0 (https://github.com/iclectic/nutrivoya)';

  static const _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';

  final Map<String, Food> _cache = {};

  @override
  Future<Food?> lookupBarcode(String barcode) async {
    final code = normalizeBarcode(barcode);
    if (code == null) return null;

    final cached = _cache['off:$code'];
    if (cached != null) return cached;

    try {
      final res = await _dio.get('$_baseUrl/$code.json');
      final data = res.data;
      if (data is! Map) return null;

      final status = data['status'];
      // v2 uses status == 0 / "failure" when missing; v0 used status == 0.
      if (status == 0 || status == 'failure') return null;

      final product = data['product'];
      if (product is! Map) return null;

      final food = _mapProduct(code, product.cast<String, dynamic>());
      if (food != null) {
        _cache[food.id] = food;
      }
      return food;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      if (kDebugMode) {
        debugPrint('[OpenFoodFacts] lookup error: ${e.message}');
      }
      throw NetworkError('barcodeNetworkError', detail: e.message);
    }
  }

  /// Test / offline helper: seed the in-memory cache.
  void cacheForTesting(Food food) => _cache[food.id] = food;

  Food? _mapProduct(String barcode, Map<String, dynamic> product) {
    final name = _firstNonEmpty([
      product['product_name'],
      product['product_name_en'],
      product['generic_name'],
      product['generic_name_en'],
    ]);
    if (name == null) return null;

    final brands = product['brands'] as String?;
    final displayName = (brands != null && brands.trim().isNotEmpty)
        ? '$name ($brands)'
        : name;

    final nutriments = (product['nutriments'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final nutrients = _mapNutrients(nutriments);
    if (nutrients[NutrientCode.energyKcal]?.amountPer100g == null &&
        nutrients[NutrientCode.proteinG]?.amountPer100g == null) {
      // No usable nutrition — still return the product so the user can see
      // it was found, with unknown confidence.
    }

    final portions = _mapPortions(product, nutriments);
    final quantityHint = product['quantity'] as String?;

    return Food(
      id: 'off:$barcode',
      canonicalName: displayName,
      foodType: FoodType.single,
      defaultServingGrams:
          portions.isNotEmpty ? portions.first.grams : 100,
      names: [
        FoodName(
          name: displayName,
          languageCode: 'en',
          nameType: NameType.primary,
        ),
        if (brands != null && brands.trim().isNotEmpty)
          FoodName(
            name: brands.trim(),
            languageCode: 'en',
            nameType: NameType.alias,
          ),
        FoodName(
          name: barcode,
          languageCode: 'en',
          nameType: NameType.alias,
        ),
      ],
      portions: portions,
      nutrientsPer100g: nutrients,
      source: FoodSource(
        type: FoodSourceType.packaged,
        name: 'Open Food Facts',
        reference: barcode,
        reviewStatus: ReviewStatus.unverified,
        confidence: _confidenceFor(nutrients),
        updatedAt: DateTime.now().toUtc(),
      ),
      // Stash quantity text via region field for UI notes when useful.
      region: quantityHint,
    );
  }

  NutritionConfidence _confidenceFor(
    Map<NutrientCode, NutrientAmount> nutrients,
  ) {
    final kcal = nutrients[NutrientCode.energyKcal]?.amountPer100g;
    final protein = nutrients[NutrientCode.proteinG]?.amountPer100g;
    if (kcal == null && protein == null) {
      return NutritionConfidence.unknown;
    }
    // Crowdsourced packaged data: never "high".
    return NutritionConfidence.medium;
  }

  Map<NutrientCode, NutrientAmount> _mapNutrients(
    Map<String, dynamic> nutriments,
  ) {
    double? read(String key) {
      final v = nutriments[key];
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    // Prefer explicit kcal; fall back from kJ when needed.
    var kcal = read('energy-kcal_100g') ?? read('energy-kcal');
    if (kcal == null) {
      final kj = read('energy_100g') ?? read('energy');
      if (kj != null) kcal = kj / 4.184;
    }

    return {
      NutrientCode.energyKcal: NutrientAmount(
        code: NutrientCode.energyKcal,
        amountPer100g: kcal,
      ),
      NutrientCode.proteinG: NutrientAmount(
        code: NutrientCode.proteinG,
        amountPer100g: read('proteins_100g'),
      ),
      NutrientCode.carbohydrateG: NutrientAmount(
        code: NutrientCode.carbohydrateG,
        amountPer100g: read('carbohydrates_100g'),
      ),
      NutrientCode.fatG: NutrientAmount(
        code: NutrientCode.fatG,
        amountPer100g: read('fat_100g'),
      ),
      NutrientCode.fibreG: NutrientAmount(
        code: NutrientCode.fibreG,
        amountPer100g: read('fiber_100g'),
      ),
      NutrientCode.saturatedFatG: NutrientAmount(
        code: NutrientCode.saturatedFatG,
        amountPer100g: read('saturated-fat_100g'),
      ),
      NutrientCode.sugarG: NutrientAmount(
        code: NutrientCode.sugarG,
        amountPer100g: read('sugars_100g'),
      ),
      NutrientCode.sodiumMg: NutrientAmount(
        code: NutrientCode.sodiumMg,
        amountPer100g: () {
          final sodiumG = read('sodium_100g');
          if (sodiumG != null) return sodiumG * 1000;
          final saltG = read('salt_100g');
          if (saltG != null) return (saltG / 2.5) * 1000;
          return null;
        }(),
      ),
    };
  }

  List<FoodPortion> _mapPortions(
    Map<String, dynamic> product,
    Map<String, dynamic> nutriments,
  ) {
    final portions = <FoodPortion>[];

    double? servingGrams;
    final servingQuantity = product['serving_quantity'];
    if (servingQuantity is num) {
      servingGrams = servingQuantity.toDouble();
    } else if (servingQuantity is String) {
      servingGrams = double.tryParse(servingQuantity);
    }
    servingGrams ??= _parseGrams(product['serving_size'] as String?);

    if (servingGrams != null && servingGrams > 0 && servingGrams < 2000) {
      final label = (product['serving_size'] as String?)?.trim();
      portions.add(
        FoodPortion(
          name: (label != null && label.isNotEmpty)
              ? label
              : '1 serving',
          grams: servingGrams,
          sizeClass: PortionSizeClass.medium,
        ),
      );
    }

    portions.add(
      const FoodPortion(
        name: '100 g',
        grams: 100,
        sizeClass: PortionSizeClass.medium,
      ),
    );
    return portions;
  }

  double? _parseGrams(String? servingSize) {
    if (servingSize == null) return null;
    final match = RegExp(
      r'(\d+(?:[.,]\d+)?)\s*g\b',
      caseSensitive: false,
    ).firstMatch(servingSize);
    if (match == null) return null;
    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }

  String? _firstNonEmpty(List<dynamic> values) {
    for (final v in values) {
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}
