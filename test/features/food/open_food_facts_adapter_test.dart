import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrient.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/features/food/data/open_food_facts_adapter.dart';
import 'package:nutrivoya/features/food/data/packaged_food_repository.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }
}

void main() {
  group('normalizeBarcode / looksLikeBarcode', () {
    test('accepts common EAN lengths', () {
      expect(normalizeBarcode('3017620422003'), '3017620422003');
      expect(normalizeBarcode(' 3017-6204-2200-3 '), '3017620422003');
      expect(normalizeBarcode('123'), isNull);
    });

    test('looksLikeBarcode requires digit-only query', () {
      expect(looksLikeBarcode('3017620422003'), isTrue);
      expect(looksLikeBarcode('roti'), isFalse);
      expect(looksLikeBarcode('3017620422003 roti'), isFalse);
    });
  });

  group('OpenFoodFactsAdapter', () {
    test('maps a successful product payload to Food', () async {
      RequestOptions? seen;
      final dio = Dio();
      dio.httpClientAdapter = _FakeAdapter((options) async {
        seen = options;
        return ResponseBody.fromString(
          jsonEncode({
            'status': 1,
            'product': {
              'product_name': 'Nutella',
              'brands': 'Ferrero',
              'serving_size': '15 g',
              'serving_quantity': 15,
              'nutriments': {
                'energy-kcal_100g': 539,
                'proteins_100g': 6.3,
                'carbohydrates_100g': 57.5,
                'fat_100g': 30.9,
                'fiber_100g': 0,
                'saturated-fat_100g': 10.6,
                'sugars_100g': 56.3,
                'salt_100g': 0.107,
              },
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final adapter = OpenFoodFactsAdapter(dio: dio);
      final food = await adapter.lookupBarcode('3017620422003');

      expect(seen?.uri.toString(), contains('3017620422003'));
      expect(food, isNotNull);
      expect(food!.id, 'off:3017620422003');
      expect(food.canonicalName, contains('Nutella'));
      expect(food.source.type, FoodSourceType.packaged);
      expect(food.source.name, 'Open Food Facts');
      expect(food.source.reference, '3017620422003');
      expect(food.confidence, NutritionConfidence.medium);
      expect(food.nutrientPer100g(NutrientCode.energyKcal), 539);
      expect(food.nutrientPer100g(NutrientCode.proteinG), 6.3);
      expect(food.portions.any((p) => p.grams == 15), isTrue);
    });

    test('returns null when product is missing', () async {
      final dio = Dio();
      dio.httpClientAdapter = _FakeAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode({'status': 0, 'status_verbose': 'product not found'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final adapter = OpenFoodFactsAdapter(dio: dio);
      expect(await adapter.lookupBarcode('0000000000000'), isNull);
    });

    test('serves cached results without a second network call', () async {
      var calls = 0;
      final dio = Dio();
      dio.httpClientAdapter = _FakeAdapter((options) async {
        calls++;
        return ResponseBody.fromString(
          jsonEncode({
            'status': 1,
            'product': {
              'product_name': 'Test Bar',
              'nutriments': {'energy-kcal_100g': 100, 'proteins_100g': 1},
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final adapter = OpenFoodFactsAdapter(dio: dio);
      final first = await adapter.lookupBarcode('12345678');
      final second = await adapter.lookupBarcode('12345678');
      expect(first?.id, second?.id);
      expect(calls, 1);
    });
  });
}
