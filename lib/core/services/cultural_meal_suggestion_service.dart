import '../models/diary_entry.dart';
import '../models/food.dart';
import '../models/nutrient.dart';
import '../models/user_profile.dart';

/// A cuisine-aware meal suggestion backed by structured food data only.
class CulturalMealSuggestion {
  const CulturalMealSuggestion({
    required this.food,
    required this.reasonKey,
    this.matchedCuisine,
  });

  final Food food;
  final String reasonKey;
  final String? matchedCuisine;
}

/// Suggests familiar-cuisine foods from a structured catalog.
///
/// Never invents nutrition — only returns [Food] records that already exist.
/// Prefers same-cuisine options and complementary protein/fibre when today's
/// diary is light on those macros.
class CulturalMealSuggestionService {
  const CulturalMealSuggestionService();

  List<CulturalMealSuggestion> suggest({
    required List<Food> catalog,
    UserProfile? profile,
    List<DiaryEntry> todayEntries = const [],
    int limit = 8,
  }) {
    if (catalog.isEmpty) return const [];

    final loggedIds = todayEntries.map((e) => e.foodId).toSet();
    final cuisines = profile?.familiarCuisines
            .map((c) => c.trim().toLowerCase())
            .where((c) => c.isNotEmpty)
            .toSet() ??
        {};

    final totals = DailyTotals.fromEntries(todayEntries);
    final wantProtein = totals.proteinG < 40;
    final wantFibre = totals.fibreG < 15;

    final scored = <({Food food, int score, String reason, String? cuisine})>[];

    for (final food in catalog) {
      if (loggedIds.contains(food.id)) continue;
      final cuisine = food.cuisine?.trim();
      final cuisineLower = cuisine?.toLowerCase();
      final cuisineMatch = cuisineLower != null &&
          cuisines.any(
            (c) => cuisineLower.contains(c) || c.contains(cuisineLower),
          );

      var score = 0;
      var reason = 'culturalSuggestReasonExplore';
      if (cuisineMatch) {
        score += 50;
        reason = 'culturalSuggestReasonFamiliarCuisine';
      }

      final protein = food.nutrientPer100g(NutrientCode.proteinG) ?? 0;
      final fibre = food.nutrientPer100g(NutrientCode.fibreG) ?? 0;
      if (wantProtein && protein >= 8) {
        score += 20;
        reason = cuisineMatch
            ? 'culturalSuggestReasonProteinFamiliar'
            : 'culturalSuggestReasonProtein';
      }
      if (wantFibre && fibre >= 4) {
        score += 15;
        if (reason == 'culturalSuggestReasonExplore' ||
            reason == 'culturalSuggestReasonFamiliarCuisine') {
          reason = cuisineMatch
              ? 'culturalSuggestReasonFibreFamiliar'
              : 'culturalSuggestReasonFibre';
        }
      }

      // Prefer curated / authoritative sources slightly.
      score += switch (food.source.type.name) {
        'authoritative' => 5,
        'nutrivoyaCurated' => 4,
        _ => 0,
      };

      if (score == 0 && cuisines.isNotEmpty && !cuisineMatch) {
        // Skip unrelated foods when the user named familiar cuisines.
        continue;
      }

      scored.add((
        food: food,
        score: score,
        reason: reason,
        cuisine: cuisine,
      ));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return [
      for (final s in scored.take(limit))
        CulturalMealSuggestion(
          food: s.food,
          reasonKey: s.reason,
          matchedCuisine: s.cuisine,
        ),
    ];
  }
}
