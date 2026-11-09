import 'dart:typed_data';

import '../models/food.dart';
import '../models/photo_recognition.dart';
import '../models/user_profile.dart';

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

/// Test / future plug-in recognizer that maps a description token list to
/// queries, still requiring structured lookup and never inventing kcal.
class QueryTokenPhotoRecognizer implements FoodPhotoRecognizer {
  const QueryTokenPhotoRecognizer({this.tokens = const []});

  /// Tokens a future on-device model might emit (e.g. "rice", "dal").
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
