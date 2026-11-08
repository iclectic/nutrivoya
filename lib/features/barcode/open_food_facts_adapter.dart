import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../../core/models/food_name.dart';
import '../../core/models/food_portion.dart';
import '../../core/models/food_source.dart';
import '../../core/models/nutrient.dart';
import '../../core/storage/local_preferences.dart';
import '../../core/utils/confidence_scorer.dart';

/// A packaged product found by barcode: the mapped [food] plus the raw
/// provider record (cached so the product works offline later).
class PackagedProduct {
  const PackagedProduct({required this.barcode, required this.food, required this.raw});
  final String barcode;
  final Food food;
  final Map<String, dynamic> raw;
}

/// Packaged-food lookup by barcode (Tier 2 in the plan's data architecture).
abstract class PackagedFoodRepository {
  /// Returns null when the product is unknown. Throws on network failure.
  Future<PackagedProduct?> lookup(String barcode);
}

/// Validates an EAN-8 / UPC-A / EAN-13 / GTIN-14 check digit.
bool isValidGtin(String code) {
  if (!RegExp(r'^\d+$').hasMatch(code)) return false;
  if (![8, 12, 13, 14].contains(code.length)) return false;
  final digits = code.split('').map(int.parse).toList();
  final check = digits.removeLast();
  var sum = 0;
  for (var i = 0; i < digits.length; i++) {
    final fromRight = digits.length - 1 - i;
    sum += digits[i] * (fromRight.isEven ? 3 : 1);
  }
  return (10 - sum % 10) % 10 == check;
}

/// Open Food Facts adapter. Community data: mapped as `packaged` and
/// unverified; values absent from the record stay null.
///
/// API docs: https://openfoodfacts.github.io/openfoodfacts-server/api/
class OpenFoodFactsAdapter implements PackagedFoodRepository {
  OpenFoodFactsAdapter({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 12),
              headers: {'User-Agent': 'Nutrivoya/1.0 (https://github.com/iclectic/nutrivoya)'},
            ));

  final Dio _dio;
  static const _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';
  static const _fields =
      'code,product_name,brands,nutriments,serving_size,serving_quantity';

  @override
  Future<PackagedProduct?> lookup(String barcode) async {
    final res = await _dio.get<dynamic>(
      '$_baseUrl/$barcode.json',
      queryParameters: {'fields': _fields},
      options: Options(validateStatus: (s) => s != null && s < 500),
    );
    final data = res.data is String ? jsonDecode(res.data as String) : res.data;
    if (data is! Map<String, dynamic> || data['status'] != 1) return null;
    final product = data['product'];
    if (product is! Map<String, dynamic>) return null;
    return PackagedProduct(barcode: barcode, food: foodFromProduct(barcode, product), raw: product);
  }

  static double? _num(Object? v) => switch (v) {
        num n => n.toDouble(),
        String s => double.tryParse(s),
        _ => null,
      };

  /// Maps an Open Food Facts product record to a [Food].
  static Food foodFromProduct(
    String barcode,
    Map<String, dynamic> product, {
    bool checkedByUser = false,
  }) {
    final n = (product['nutriments'] as Map?)?.cast<String, dynamic>() ?? const {};
    var kcal = _num(n['energy-kcal_100g']);
    final kj = _num(n['energy-kj_100g']) ?? _num(n['energy_100g']);
    if (kcal == null && kj != null) kcal = kj / 4.184;
    final sodiumG = _num(n['sodium_100g']);
    final values = <NutrientCode, double?>{
      NutrientCode.energyKcal: kcal,
      NutrientCode.proteinG: _num(n['proteins_100g']),
      NutrientCode.carbohydrateG: _num(n['carbohydrates_100g']),
      NutrientCode.fatG: _num(n['fat_100g']),
      NutrientCode.fibreG: _num(n['fiber_100g']),
      NutrientCode.saturatedFatG: _num(n['saturated-fat_100g']),
      NutrientCode.sugarG: _num(n['sugars_100g']),
      NutrientCode.sodiumMg: sodiumG == null ? null : sodiumG * 1000,
    };
    final nutrients = {
      for (final e in values.entries) e.key: NutrientAmount(code: e.key, amountPer100g: e.value),
    };
    final rawName = (product['product_name'] as String?)?.trim();
    final name = rawName == null || rawName.isEmpty ? 'Barcode $barcode' : rawName;
    final brand = (product['brands'] as String?)?.split(',').first.trim();
    final servingG = _num(product['serving_quantity']);
    final servingLabel = product['serving_size'] as String?;
    final review = checkedByUser ? ReviewStatus.pending : ReviewStatus.unverified;
    return Food(
      id: 'off:$barcode',
      canonicalName: brand == null || brand.isEmpty ? name : '$name ($brand)',
      foodType: FoodType.single,
      defaultServingGrams: servingG ?? 100,
      names: [
        FoodName(name: name, languageCode: 'und', nameType: NameType.primary),
        if (brand != null && brand.isNotEmpty) FoodName(name: brand, nameType: NameType.alias),
      ],
      portions: [
        if (servingG != null && servingG > 0)
          FoodPortion(
            name: servingLabel == null ? '1 serving' : '1 serving ($servingLabel)',
            grams: servingG,
            source: 'Open Food Facts',
          ),
      ],
      nutrientsPer100g: nutrients,
      source: FoodSource(
        type: FoodSourceType.packaged,
        name: 'Open Food Facts',
        reference: checkedByUser ? 'barcode $barcode · label checked by user' : 'barcode $barcode',
        reviewStatus: review,
        confidence: ConfidenceScorer.score(
          type: FoodSourceType.packaged,
          review: review,
          nutrients: nutrients,
        ),
      ),
    );
  }
}

/// Possible problems in packaged nutrition data, shown before logging.
enum LabelIssue { missingEnergy, missingMacros, energyMismatch, implausibleValue }

/// Deterministic sanity checks for packaged nutrition (verification step).
Set<LabelIssue> checkLabel(Food food) {
  final issues = <LabelIssue>{};
  final kcal = food.nutrientPer100g(NutrientCode.energyKcal);
  final p = food.nutrientPer100g(NutrientCode.proteinG);
  final c = food.nutrientPer100g(NutrientCode.carbohydrateG);
  final f = food.nutrientPer100g(NutrientCode.fatG);
  if (kcal == null) issues.add(LabelIssue.missingEnergy);
  if (p == null || c == null || f == null) issues.add(LabelIssue.missingMacros);
  final grams = [p, c, f, food.nutrientPer100g(NutrientCode.fibreG), food.nutrientPer100g(NutrientCode.sugarG)]
      .whereType<double>();
  if ((kcal != null && (kcal < 0 || kcal > 900)) || grams.any((g) => g < 0 || g > 100) ||
      (p ?? 0) + (c ?? 0) + (f ?? 0) > 105) {
    issues.add(LabelIssue.implausibleValue);
  }
  if (kcal != null && p != null && c != null && f != null) {
    final estimate = 4 * p + 4 * c + 9 * f;
    final diff = (estimate - kcal).abs();
    final base = estimate > kcal ? estimate : kcal;
    if (diff > 40 && base > 0 && diff / base > 0.25) issues.add(LabelIssue.energyMismatch);
  }
  return issues;
}

/// On-device cache of products the user has checked and chosen to use.
class PackagedFoodCache {
  PackagedFoodCache(this._prefs);
  final LocalPreferences _prefs;
  static const _prefix = 'nutrivoya.packaged.';

  Future<void> save(PackagedProduct product) =>
      _prefs.setString('$_prefix${product.barcode}', jsonEncode(product.raw));

  Food? byFoodId(String foodId) {
    if (!foodId.startsWith('off:')) return null;
    final barcode = foodId.substring(4);
    final raw = _prefs.getString('$_prefix$barcode');
    if (raw == null) return null;
    return OpenFoodFactsAdapter.foodFromProduct(
      barcode,
      jsonDecode(raw) as Map<String, dynamic>,
      checkedByUser: true,
    );
  }
}

final packagedFoodRepositoryProvider =
    Provider<PackagedFoodRepository>((ref) => OpenFoodFactsAdapter());

final packagedFoodCacheProvider = Provider<PackagedFoodCache>(
  (ref) => PackagedFoodCache(ref.watch(localPreferencesSyncProvider)),
);
