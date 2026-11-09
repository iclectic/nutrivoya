import 'package:flutter/foundation.dart';

import 'diary_entry.dart';
import 'nutrition_confidence.dart';
import 'nutrition_targets.dart';
import 'user_profile.dart';

/// Recognized Ask Nutrivoya intents.
///
/// The assistant is rule-based over structured app data. It never invents
/// calorie values — food numbers come only from the food repository.
enum AssistantIntent {
  /// Cultural staple can fit goals via portion/pairing adjustments.
  culturalStapleOk,

  /// Balance today's logged meal pattern vs targets.
  mealBalance,

  /// Raise protein while keeping familiar foods.
  raiseProtein,

  /// Hunger while near calorie target — contextual, non-moralizing.
  hunger,

  /// Calorie/nutrition lookup for a named food from structured data.
  calorieLookup,

  /// Substitution / modification ideas (prefer modify over replace).
  foodSubstitute,

  /// High-risk / medical topics → professional guidance.
  medicalRedirect,

  /// Could not classify confidently.
  unknown,
}

/// Structured context assembled from profile, targets and diary.
@immutable
class AssistantContext {
  const AssistantContext({
    this.profile,
    this.targets,
    this.todayTotals,
    this.todayEntries = const [],
    this.familiarCuisines = const [],
  });

  final UserProfile? profile;
  final NutritionTargets? targets;
  final DailyTotals? todayTotals;
  final List<DiaryEntry> todayEntries;
  final List<String> familiarCuisines;
}

/// Provenance note for numbers shown in an answer.
@immutable
class AssistantCitation {
  const AssistantCitation({
    required this.label,
    this.detail,
    this.confidence,
  });

  final String label;
  final String? detail;
  final NutritionConfidence? confidence;
}

/// Structured assistant answer — UI localizes from [intent] + [facts].
@immutable
class AssistantAnswer {
  const AssistantAnswer({
    required this.intent,
    this.facts = const {},
    this.citations = const [],
    this.tipKeys = const [],
    this.showMedicalDisclaimer = false,
    this.showWellnessDisclaimer = true,
    this.matchedFoodName,
  });

  final AssistantIntent intent;

  /// Numeric / string facts used as l10n placeholders.
  ///
  /// Common keys: `foodName`, `kcal`, `proteinG`, `confidence`,
  /// `caloriesConsumed`, `calorieTarget`, `proteinConsumed`, `proteinTarget`,
  /// `proteinGap`, `cuisine`, `sourceName`.
  final Map<String, Object> facts;

  final List<AssistantCitation> citations;

  /// Localization keys for short tip bullets (resolved in UI).
  final List<String> tipKeys;

  final bool showMedicalDisclaimer;
  final bool showWellnessDisclaimer;

  /// Display name when a food lookup succeeded.
  final String? matchedFoodName;
}
