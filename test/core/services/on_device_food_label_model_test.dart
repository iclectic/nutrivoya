import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/food_label_token.dart';
import 'package:nutrivoya/core/models/food_name.dart';
import 'package:nutrivoya/core/models/food_source.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/core/services/on_device_food_label_model.dart';

void main() {
  final bytes = Uint8List.fromList([1, 2, 3, 4]);
  const vocab = ['roti', 'dal', 'jollof rice', 'rice', 'chicken'];

  group('VocabularyOnDeviceFoodLabelModel', () {
    const model = VocabularyOnDeviceFoodLabelModel(defaultVocabulary: vocab);

    test('empty image yields no tokens', () async {
      final tokens = await model.analyze(
        imageBytes: Uint8List(0),
        description: 'roti and dal',
      );
      expect(tokens, isEmpty);
    });

    test('without description never invents tokens from pixels', () async {
      final tokens = await model.analyze(imageBytes: bytes);
      expect(tokens, isEmpty);
    });

    test('extracts vocabulary tokens from description', () async {
      final tokens = await model.analyze(
        imageBytes: bytes,
        description: 'roti and dal',
      );
      final values = tokens.map((t) => t.token).toSet();
      expect(values.contains('roti'), isTrue);
      expect(values.contains('dal'), isTrue);
      expect(
        tokens.every((t) => t.source == FoodLabelTokenSource.vocabulary),
        isTrue,
      );
    });

    test('unknown description yields empty rather than fabricating', () async {
      final tokens = await model.analyze(
        imageBytes: bytes,
        description: 'xyzzy-not-a-dish-999',
      );
      expect(tokens, isEmpty);
    });
  });

  group('StubPixelHistogramLabelModel', () {
    test('always returns empty — pixels are not a food database', () async {
      const stub = StubPixelHistogramLabelModel();
      final tokens = await stub.analyze(
        imageBytes: bytes,
        description: 'roti',
      );
      expect(tokens, isEmpty);
    });
  });

  group('HybridOnDeviceFoodLabelModel', () {
    test('uses vocabulary tokens and ignores empty pixel stub', () async {
      const hybrid = HybridOnDeviceFoodLabelModel(
        vocabularyModel: VocabularyOnDeviceFoodLabelModel(
          defaultVocabulary: vocab,
        ),
      );
      final tokens = await hybrid.analyze(
        imageBytes: bytes,
        description: 'jollof rice',
      );
      expect(tokens, isNotEmpty);
      expect(
        tokens.any((t) => t.token.contains('jollof') || t.token == 'rice'),
        isTrue,
      );
    });
  });

  group('CuisineBiasedOnDeviceFoodLabelModel', () {
    test('boosts tokens that match familiar cuisine foods', () async {
      final foods = [
        Food(
          id: 'roti-test',
          canonicalName: 'Roti',
          foodType: FoodType.single,
          cuisine: 'indian',
          names: [FoodName(name: 'roti', languageCode: 'en')],
          nutrientsPer100g: const {},
          source: const FoodSource(
            type: FoodSourceType.nutrivoyaCurated,
            name: 'test',
            confidence: NutritionConfidence.estimated,
          ),
        ),
      ];
      final model = CuisineBiasedOnDeviceFoodLabelModel(
        inner: const VocabularyOnDeviceFoodLabelModel(
          defaultVocabulary: vocab,
        ),
        foods: foods,
      );
      final profile = UserProfile(
        id: 'u',
        ageYears: 30,
        heightCm: 170,
        weightKg: 70,
        physiologicalInput: PhysiologicalInput.male,
        activityLevel: ActivityLevel.moderate,
        goal: NutritionGoal.maintainWeight,
        familiarCuisines: const ['indian'],
      );
      final tokens = await model.analyze(
        imageBytes: bytes,
        description: 'roti',
        profile: profile,
      );
      expect(tokens, isNotEmpty);
      expect(tokens.first.source, FoodLabelTokenSource.cuisineBias);
      expect(tokens.first.confidence, greaterThan(0.5));
    });
  });

  group('foodVocabularyFrom', () {
    test('indexes display names without inventing nutrition', () {
      final foods = [
        Food(
          id: 'dal-test',
          canonicalName: 'Dal',
          foodType: FoodType.composite,
          names: [
            FoodName(name: 'dal', languageCode: 'en'),
            FoodName(name: 'spiced lentils', languageCode: 'en'),
          ],
          nutrientsPer100g: const {},
          source: const FoodSource(
            type: FoodSourceType.nutrivoyaCurated,
            name: 'test',
            confidence: NutritionConfidence.estimated,
          ),
        ),
      ];
      final built = foodVocabularyFrom(foods);
      expect(built.contains('dal'), isTrue);
      expect(built.any((v) => v.contains('lentil')), isTrue);
    });
  });
}
