import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/cultural_meal_suggestion_service.dart';
import '../../features/diary/diary_providers.dart';
import '../../features/food/data/local_food_dataset.dart';
import '../../features/profile/profile_controller.dart';
import '../add_product/add_product_providers.dart';

final culturalMealSuggestionServiceProvider =
    Provider<CulturalMealSuggestionService>((ref) {
  return const CulturalMealSuggestionService();
});

final culturalMealSuggestionsProvider =
    Provider.autoDispose<List<CulturalMealSuggestion>>((ref) {
  final profile = ref.watch(profileControllerProvider);
  final entries = ref.watch(diaryEntriesProvider).valueOrNull ?? const [];
  // Include curated + personal library foods (structured only).
  ref.watch(productSubmissionsRevisionProvider);
  final userFoods = ref.watch(publishedUserFoodsProvider);
  final catalog = [...LocalFoodDataset.all(), ...userFoods];
  return ref.watch(culturalMealSuggestionServiceProvider).suggest(
        catalog: catalog,
        profile: profile,
        todayEntries: entries,
      );
});
