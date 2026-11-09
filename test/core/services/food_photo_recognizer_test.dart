import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food.dart';
import 'package:nutrivoya/core/models/photo_recognition.dart';
import 'package:nutrivoya/core/services/food_photo_recognizer.dart';
import 'package:nutrivoya/core/services/on_device_food_label_model.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';

void main() {
  const recognizer = SearchAssistedPhotoRecognizer();
  final bytes = Uint8List.fromList([1, 2, 3, 4]);

  Future<List<Food>> lookup(String query) async {
    final q = query.toLowerCase();
    return LocalFoodDataset.all()
        .where(
          (f) =>
              f.allDisplayNames.any((n) => n.toLowerCase().contains(q)) ||
              f.canonicalName.toLowerCase().contains(q),
        )
        .toList();
  }

  group('SearchAssistedPhotoRecognizer', () {
    test('without description returns no invented foods', () async {
      final suggestions = await recognizer.suggest(
        imageBytes: bytes,
        foodLookup: lookup,
      );
      expect(suggestions, isEmpty);
    });

    test('empty image returns empty', () async {
      final suggestions = await recognizer.suggest(
        imageBytes: Uint8List(0),
        description: 'roti',
        foodLookup: lookup,
      );
      expect(suggestions, isEmpty);
    });

    test('description searches structured foods with uncertain confidence',
        () async {
      final suggestions = await recognizer.suggest(
        imageBytes: bytes,
        description: 'roti',
        foodLookup: lookup,
      );
      expect(suggestions, isNotEmpty);
      expect(suggestions.first.matchConfidence, PhotoMatchConfidence.uncertain);
      expect(suggestions.every((s) => s.isCertain == false), isTrue);
      // Suggestions carry Food records; kcal still comes from structured data.
      expect(suggestions.first.food.nutrientsPer100g, isNotEmpty);
    });

    test('unknown description yields empty rather than fabricating', () async {
      final suggestions = await recognizer.suggest(
        imageBytes: bytes,
        description: 'xyzzy-not-a-real-dish-999',
        foodLookup: lookup,
      );
      expect(suggestions, isEmpty);
    });
  });

  group('QueryTokenPhotoRecognizer', () {
    test('token queries still require structured lookup', () async {
      const tokenRecognizer = QueryTokenPhotoRecognizer(tokens: ['dal']);
      final suggestions = await tokenRecognizer.suggest(
        imageBytes: bytes,
        foodLookup: lookup,
      );
      expect(suggestions, isNotEmpty);
      expect(
        suggestions.first.source,
        PhotoSuggestionSource.recognizerQuery,
      );
      expect(suggestions.first.isCertain, isFalse);
    });
  });

  group('OnDeviceAssistedPhotoRecognizer', () {
    test('token lookup stays uncertain and never invents kcal', () async {
      final assisted = OnDeviceAssistedPhotoRecognizer(
        labelModel: const VocabularyOnDeviceFoodLabelModel(
          defaultVocabulary: ['roti', 'dal'],
        ),
        vocabulary: const ['roti', 'dal'],
      );
      final suggestions = await assisted.suggest(
        imageBytes: bytes,
        description: 'roti with dal',
        foodLookup: lookup,
      );
      expect(suggestions, isNotEmpty);
      expect(suggestions.every((s) => s.isCertain == false), isTrue);
      expect(
        suggestions.any((s) => s.source == PhotoSuggestionSource.recognizerQuery),
        isTrue,
      );
      expect(suggestions.first.food.nutrientsPer100g, isNotEmpty);
    });

    test('without description yields empty rather than fabricating', () async {
      final assisted = OnDeviceAssistedPhotoRecognizer(
        labelModel: const VocabularyOnDeviceFoodLabelModel(
          defaultVocabulary: ['roti'],
        ),
        vocabulary: const ['roti'],
      );
      final suggestions = await assisted.suggest(
        imageBytes: bytes,
        foodLookup: lookup,
      );
      expect(suggestions, isEmpty);
    });
  });
}
