import 'dart:typed_data';

import '../models/food.dart';
import '../models/food_label_token.dart';
import '../models/photo_recognition.dart';
import '../models/user_profile.dart';
import 'on_device_food_label_model.dart';

/// Looks up structured foods from a photo session.
///
/// Important product rules:
/// - Never invent calorie values from pixels.
/// - Suggestions are uncertain until the user confirms a food.
/// - Nutrition comes only from [Food] records in the repository.
abstract class FoodPhotoRecognizer {
  /// Propose candidate foods for [imageBytes] using optional [description].
  ///
  /// Implementations must not attach fabricated nutrition. Returning an empty
  /// list is preferred over guessing.
  Future<List<PhotoFoodSuggestion>> suggest({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Future<List<Food>> Function(String query)? foodLookup,
  });
}

/// Default recognizer: description-assisted search over the food repository.
///
/// The image is kept for user reference only. Without a description, no
/// automatic food IDs are invented from pixels (no silent CV guesses).
class SearchAssistedPhotoRecognizer implements FoodPhotoRecognizer {
  const SearchAssistedPhotoRecognizer();

  @override
  Future<List<PhotoFoodSuggestion>> suggest({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Future<List<Food>> Function(String query)? foodLookup,
  }) async {
    // Image bytes are intentionally unused for nutrition — CV is not a
    // calorie database. Presence of bytes only proves a photo was attached.
    if (imageBytes.isEmpty) return const [];

    final query = description?.trim() ?? '';
    if (query.isEmpty || foodLookup == null) {
      return const [];
    }

    final foods = await foodLookup(query);
    if (foods.isEmpty) return const [];

    return [
      for (var i = 0; i < foods.length && i < 8; i++)
        PhotoFoodSuggestion(
          food: foods[i],
          source: PhotoSuggestionSource.userDescriptionSearch,
          matchConfidence: i == 0
              ? PhotoMatchConfidence.uncertain
              : PhotoMatchConfidence.low,
          matchedQuery: query,
          reasonKey: 'photoReasonSearchMatch',
        ),
    ];
  }
}

/// Test / plug-in recognizer that maps fixed token strings to queries,
/// still requiring structured lookup and never inventing kcal.
class QueryTokenPhotoRecognizer implements FoodPhotoRecognizer {
  const QueryTokenPhotoRecognizer({this.tokens = const []});

  /// Tokens an on-device model might emit (e.g. "rice", "dal").
  final List<String> tokens;

  @override
  Future<List<PhotoFoodSuggestion>> suggest({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Future<List<Food>> Function(String query)? foodLookup,
  }) async {
    if (foodLookup == null) return const [];

    final queries = <String>[
      if (description != null && description.trim().isNotEmpty)
        description.trim(),
      ...tokens.where((t) => t.trim().isNotEmpty),
    ];
    if (queries.isEmpty) return const [];

    final seen = <String>{};
    final out = <PhotoFoodSuggestion>[];
    for (final q in queries) {
      final foods = await foodLookup(q);
      for (final food in foods) {
        if (!seen.add(food.id)) continue;
        out.add(
          PhotoFoodSuggestion(
            food: food,
            source: tokens.isNotEmpty
                ? PhotoSuggestionSource.recognizerQuery
                : PhotoSuggestionSource.userDescriptionSearch,
            matchConfidence: PhotoMatchConfidence.uncertain,
            matchedQuery: q,
            reasonKey: tokens.isNotEmpty
                ? 'photoReasonRecognizer'
                : 'photoReasonSearchMatch',
          ),
        );
        if (out.length >= 8) return out;
      }
    }
    return out;
  }
}

/// Runs an [OnDeviceFoodLabelModel] for tokens, looks each up in structured
/// food data, and merges with a description search — never inventing kcal.
class OnDeviceAssistedPhotoRecognizer implements FoodPhotoRecognizer {
  const OnDeviceAssistedPhotoRecognizer({
    required this.labelModel,
    this.descriptionRecognizer = const SearchAssistedPhotoRecognizer(),
    this.vocabulary = const [],
  });

  final OnDeviceFoodLabelModel labelModel;
  final FoodPhotoRecognizer descriptionRecognizer;
  final List<String> vocabulary;

  @override
  Future<List<PhotoFoodSuggestion>> suggest({
    required Uint8List imageBytes,
    String? description,
    UserProfile? profile,
    Future<List<Food>> Function(String query)? foodLookup,
  }) async {
    if (imageBytes.isEmpty || foodLookup == null) return const [];

    final tokens = await labelModel.analyze(
      imageBytes: imageBytes,
      description: description,
      profile: profile,
      vocabulary: vocabulary.isEmpty ? null : vocabulary,
    );

    final seen = <String>{};
    final out = <PhotoFoodSuggestion>[];

    // Token → structured lookup (uncertain / low only).
    final sortedTokens = List<FoodLabelToken>.from(tokens)
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    for (final token in sortedTokens) {
      if (!token.isUsable) continue;
      final foods = await foodLookup(token.token);
      for (final food in foods) {
        if (!seen.add(food.id)) continue;
        out.add(
          PhotoFoodSuggestion(
            food: food,
            source: PhotoSuggestionSource.recognizerQuery,
            matchConfidence: token.confidence >= 0.75
                ? PhotoMatchConfidence.uncertain
                : PhotoMatchConfidence.low,
            matchedQuery: token.token,
            reasonKey: token.source == FoodLabelTokenSource.cuisineBias
                ? 'photoReasonCuisineToken'
                : 'photoReasonRecognizer',
          ),
        );
        if (out.length >= 8) return out;
      }
    }

    // Also merge plain description search results.
    final fromDescription = await descriptionRecognizer.suggest(
      imageBytes: imageBytes,
      description: description,
      profile: profile,
      foodLookup: foodLookup,
    );
    for (final suggestion in fromDescription) {
      if (!seen.add(suggestion.food.id)) continue;
      out.add(suggestion);
      if (out.length >= 8) break;
    }

    return out;
  }
}
