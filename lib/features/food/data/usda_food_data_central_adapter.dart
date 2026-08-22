import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/models/food.dart';
import '../../../core/models/food_name.dart';
import '../../../core/models/food_portion.dart';
import '../../../core/models/food_source.dart';
import '../../../core/models/nutrient.dart';
import '../../../core/models/nutrition_confidence.dart';

/// Tier 1 — adapter for the USDA FoodData Central API.
///
/// This is a REAL adapter to a trusted structured nutrition dataset. It is
/// only used when an API key is provided via `--dart-define=USDA_FDC_API_KEY=`
/// (see README). It never fabricates values; unknown nutrients stay `null`.
///
/// API docs: https://fdc.nal.usda.gov/api-guide.html
class UsdaFoodDataCentralAdapter {
  UsdaFoodDataCentralAdapter({Dio? dio, String? apiKey})
      : _dio = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 8), receiveTimeout: const Duration(seconds: 12))),
        _apiKey = apiKey ?? const String.fromEnvironment('USDA_FDC_API_KEY', defaultValue: '');

  final Dio _dio;
  final String _apiKey;

  static const _baseUrl = 'https://api.nal.usda.gov/fdc/v1';

  bool get isConfigured => _apiKey.isNotEmpty;

  /// Search foods by query. Returns canonical [Food] records normalized to
  /// Nutrivoya's per-100g model.
  Future<List<Food>> search(String query, {int limit = 20}) async {
    if (!isConfigured) return const [];
    try {
      final res = await _dio.post(
        '$_baseUrl/foods/search',
        queryParameters: {'api_key': _apiKey},
        data: {
          'query': query,
          'pageSize': limit,
          'dataType': ['SR Legacy', 'Foundation'],
        },
      );
      final foods = res.data?['foods'] as List?;
      if (foods == null) return const [];
      return foods
          .map((f) => _mapFood(f as Map<String, dynamic>))
          .whereType<Food>()
          .toList();
    } on DioException catch (e) {
      if (kDebugMode) debugPrint('[USDA] search error: ${e.message}');
      throw NetworkError('commonError', detail: e.message);
    }
  }

  Future<Food?> getById(String fdcId) async {
    if (!isConfigured) return null;
    try {
      final res = await _dio.get('$_baseUrl/food/$fdcId', queryParameters: {'api_key': _apiKey});
      return _mapFood(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (kDebugMode) debugPrint('[USDA] getById error: ${e.message}');
      return null;
    }
  }

  Food? _mapFood(Map<String, dynamic> json) {
    final fdcId = json['fdcId']?.toString();
    if (fdcId == null) return null;
    final description = json['description'] as String? ?? 'Unknown';
    final nutrients = _mapNutrients(json['foodNutrients'] as List?);
    final portions = _mapPortions(json['foodPortions'] as List?);

    return Food(
      id: 'usda:$fdcId',
      canonicalName: description,
      foodType: FoodType.single,
      defaultServingGrams: portions.isNotEmpty ? portions.first.grams : 100,
      names: [
        FoodName(name: description, languageCode: 'en', nameType: NameType.primary),
        if (json['scientificName'] != null)
          FoodName(name: json['scientificName'] as String, nameType: NameType.alias),
      ],
      portions: portions,
      nutrientsPer100g: nutrients,
      source: FoodSource(
        type: FoodSourceType.authoritative,
        name: 'USDA FoodData Central',
        reference: 'FDC ID $fdcId',
        reviewStatus: ReviewStatus.verified,
        confidence: NutritionConfidence.high,
      ),
    );
  }

  Map<NutrientCode, NutrientAmount> _mapNutrients(List? raw) {
    final out = <NutrientCode, NutrientAmount>{};
    if (raw == null) return out;
    // USDA nutrient IDs (per FDC): 1008=Energy(kcal), 1003=Protein,
    // 1005=Carbohydrate, 1004=Total fat, 1079=Fiber, 1258=Saturated fat,
    // 2000=Sugar, 1093=Sodium, 1089=Iron, 1087=Calcium, 1092=Potassium.
    const idMap = <int, NutrientCode>{
      1008: NutrientCode.energyKcal,
      1003: NutrientCode.proteinG,
      1005: NutrientCode.carbohydrateG,
      1004: NutrientCode.fatG,
      1079: NutrientCode.fibreG,
      1258: NutrientCode.saturatedFatG,
      2000: NutrientCode.sugarG,
      1093: NutrientCode.sodiumMg,
      1089: NutrientCode.ironMg,
      1087: NutrientCode.calciumMg,
      1092: NutrientCode.potassiumMg,
    };
    for (final item in raw) {
      final map = item as Map<String, dynamic>;
      final nutrientId = map['nutrientId'] as int?;
      final code = idMap[nutrientId];
      if (code == null) continue;
      final amount = (map['amount'] as num?)?.toDouble();
      out[code] = NutrientAmount(code: code, amountPer100g: amount);
    }
    return out;
  }

  List<FoodPortion> _mapPortions(List? raw) {
    if (raw == null) return const [];
    return raw.map<FoodPortion?>((p) {
      final map = p as Map<String, dynamic>;
      final name = map['portionDescription'] as String? ?? map['modifier'] as String?;
      final grams = (map['gramWeight'] as num?)?.toDouble();
      if (name == null || grams == null) return null;
      return FoodPortion(name: name, grams: grams, source: 'USDA FoodData Central');
    }).whereType<FoodPortion>().toList();
  }
}
