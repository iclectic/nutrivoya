import '../models/assistant_models.dart';
import '../models/diary_entry.dart';
import '../models/food.dart';
import '../models/nutrient.dart';
import '../models/nutrition_goal.dart';
import '../utils/nutrition_calculator.dart';

/// Ask Nutrivoya — structured nutrition guidance over app data.
///
/// Rules (from product plan):
/// - respect cultural preferences; suggest modifications before replacements
/// - never moralize foods as good/bad
/// - never invent calorie values — only cite repository / diary / targets
/// - distinguish wellness from medical advice
/// - admit uncertainty
class NutritionAssistantService {
  const NutritionAssistantService();

  static final _medicalPattern = RegExp(
    r'\b(diagnos|diabetes|insulin|kidney|eating disorder|anorexi|bulimi|'
    r'pregnant|pregnancy|breastfeed|lactat|medication|prescri|'
    r'rapid weight loss|underweight child|cancer)\b',
    caseSensitive: false,
  );

  static final _calorieLookupPattern = RegExp(
    r'(how many calories|calories in|kcal in|nutrition (?:of|for)|macros (?:of|for))\b',
    caseSensitive: false,
  );

  static final _hungerPattern = RegExp(
    r'\b(hungr|starving|still hungry|not (?:feeling )?full|appetite)\b',
    caseSensitive: false,
  );

  static final _proteinPattern = RegExp(
    r'\b(protein|higher protein|more protein|protein[- ]rich)\b',
    caseSensitive: false,
  );

  static final _balancePattern = RegExp(
    r'\b(balanc|pair with|make .+ more balanced|missing|macro)\b',
    caseSensitive: false,
  );

  static final _substitutePattern = RegExp(
    r'\b(substitut\w*|instead of|replac\w*|swap\w*|alternative\w*)\b',
    caseSensitive: false,
  );

  static final _staplePattern = RegExp(
    r'\b(rice|roti|chapati|dal|jollof|fufu|injera|yam|cassava|plantain|'
    r'couscous|biryani|pho|bread|pasta|potato|swallow|eba|amala)\b',
    caseSensitive: false,
  );

  static final _loseWeightPattern = RegExp(
    r'\b(lose weight|losing weight|weight loss|in a deficit|cut(?:ting)?)\b',
    caseSensitive: false,
  );

  /// Answer [question] using [context] and optional [foodLookup] results.
  ///
  /// [foodLookup] must return foods from structured sources only. The
  /// assistant will not fabricate nutrition for unmatched names.
  Future<AssistantAnswer> answer(
    String question, {
    required AssistantContext context,
    Future<List<Food>> Function(String query)? foodLookup,
  }) async {
    final q = question.trim();
    if (q.isEmpty) {
      return const AssistantAnswer(
        intent: AssistantIntent.unknown,
        tipKeys: [
          'assistantTipAskRice',
          'assistantTipAskBalance',
          'assistantTipAskProtein',
        ],
      );
    }

    if (_medicalPattern.hasMatch(q)) {
      return const AssistantAnswer(
        intent: AssistantIntent.medicalRedirect,
        showMedicalDisclaimer: true,
        showWellnessDisclaimer: true,
        tipKeys: ['assistantTipSeekProfessional'],
      );
    }

    if (_calorieLookupPattern.hasMatch(q) && foodLookup != null) {
      final lookupQuery = _extractFoodQuery(q);
      final foods = await foodLookup(lookupQuery);
      return _calorieLookupAnswer(lookupQuery, foods);
    }

    // Bare food-name questions like "roti calories" / "egusi soup"
    if (foodLookup != null && _looksLikeFoodQuery(q)) {
      final foods = await foodLookup(q);
      if (foods.isNotEmpty) {
        return _calorieLookupAnswer(q, foods);
      }
    }

    if (_hungerPattern.hasMatch(q)) {
      return _hungerAnswer(context);
    }

    if (_proteinPattern.hasMatch(q)) {
      return _proteinAnswer(context);
    }

    if (_substitutePattern.hasMatch(q) &&
        !_loseWeightPattern.hasMatch(q) &&
        !_staplePattern.hasMatch(q)) {
      return _substituteAnswer(context);
    }

    if (_substitutePattern.hasMatch(q) ||
        (_staplePattern.hasMatch(q) && _loseWeightPattern.hasMatch(q)) ||
        (_staplePattern.hasMatch(q) &&
            q.toLowerCase().contains('still eat'))) {
      return _culturalStapleAnswer(context, q, foodLookup);
    }

    if (_balancePattern.hasMatch(q) ||
        q.toLowerCase().contains('today') &&
            (q.toLowerCase().contains('meal') ||
                q.toLowerCase().contains('log'))) {
      return _mealBalanceAnswer(context);
    }

    if (_staplePattern.hasMatch(q)) {
      return _culturalStapleAnswer(context, q, foodLookup);
    }

    // Default: if we have diary/targets, offer balance; else unknown.
    if (context.todayTotals != null &&
        (context.todayTotals!.entryCount > 0 ||
            context.targets?.isConfigured == true)) {
      return _mealBalanceAnswer(context);
    }

    return const AssistantAnswer(
      intent: AssistantIntent.unknown,
      tipKeys: [
        'assistantTipAskRice',
        'assistantTipAskBalance',
        'assistantTipAskProtein',
        'assistantTipAskFoodLookup',
      ],
    );
  }

  AssistantAnswer _calorieLookupAnswer(String query, List<Food> foods) {
    if (foods.isEmpty) {
      return AssistantAnswer(
        intent: AssistantIntent.calorieLookup,
        facts: {'foodName': query.trim()},
        tipKeys: ['assistantTipFoodNotFound', 'assistantTipAskFoodLookup'],
        showWellnessDisclaimer: true,
      );
    }

    final food = foods.first;
    final grams = food.defaultServingGrams ?? 100;
    final portion = food.portions.isNotEmpty ? food.portions.first : null;
    final useGrams = portion?.grams ?? grams;
    final kcalPer100 = food.nutrientPer100g(NutrientCode.energyKcal);
    final proteinPer100 = food.nutrientPer100g(NutrientCode.proteinG);

    if (kcalPer100 == null) {
      return AssistantAnswer(
        intent: AssistantIntent.calorieLookup,
        facts: {
          'foodName': food.displayName,
          'sourceName': food.source.name,
        },
        citations: [
          AssistantCitation(
            label: food.displayName,
            detail: food.source.name,
            confidence: food.confidence,
          ),
        ],
        matchedFoodName: food.displayName,
        tipKeys: ['assistantTipNutritionUnavailable'],
      );
    }

    final kcal = NutritionCalculator.scale(kcalPer100, useGrams);
    final protein = NutritionCalculator.scale(proteinPer100, useGrams);

    return AssistantAnswer(
      intent: AssistantIntent.calorieLookup,
      facts: {
        'foodName': food.displayName,
        'portionName': portion?.name ?? '${useGrams.round()} g',
        'grams': useGrams.round(),
        'kcal': NutritionCalculator.roundKcal(kcal),
        'proteinG': NutritionCalculator.roundMacro(protein).round(),
        'confidence': food.confidence.name,
        'sourceName': food.source.name,
      },
      citations: [
        AssistantCitation(
          label: food.displayName,
          detail:
              '${food.source.name}'
              '${food.source.reference != null ? ' · ${food.source.reference}' : ''}',
          confidence: food.confidence,
        ),
      ],
      matchedFoodName: food.displayName,
      tipKeys: [
        'assistantTipVerifyPortion',
        'assistantTipNoMoralFood',
      ],
    );
  }

  AssistantAnswer _hungerAnswer(AssistantContext context) {
    final totals = context.todayTotals ?? const DailyTotals();
    final targets = context.targets;
    final facts = <String, Object>{
      'caloriesConsumed': totals.caloriesRounded,
      'proteinConsumed': totals.proteinG.round(),
      'fibreConsumed': totals.fibreG.round(),
      'entryCount': totals.entryCount,
    };
    if (targets?.calorieTargetKcal != null) {
      facts['calorieTarget'] = targets!.calorieTargetKcal!.round();
    }
    if (targets?.proteinTargetG != null) {
      facts['proteinTarget'] = targets!.proteinTargetG!.round();
      facts['proteinGap'] =
          (targets.proteinTargetG! - totals.proteinG).clamp(0, 999).round();
    }

    return AssistantAnswer(
      intent: AssistantIntent.hunger,
      facts: facts,
      citations: [
        AssistantCitation(
          label: 'Today\'s diary',
          detail:
              '${totals.caloriesRounded} kcal · ${totals.entryCount} entries',
        ),
        if (targets?.isConfigured == true)
          AssistantCitation(
            label: 'Your targets',
            detail:
                '${targets!.calorieTargetKcal?.round() ?? '—'} kcal · '
                'protein ${targets.proteinTargetG?.round() ?? '—'} g',
          ),
      ],
      tipKeys: [
        'assistantTipHungerProteinFibre',
        'assistantTipHungerPace',
        'assistantTipNoMoralFood',
      ],
    );
  }

  AssistantAnswer _proteinAnswer(AssistantContext context) {
    final totals = context.todayTotals ?? const DailyTotals();
    final targets = context.targets;
    final cuisines = context.familiarCuisines;
    final cuisine = cuisines.isNotEmpty ? cuisines.first : 'your usual';

    final facts = <String, Object>{
      'proteinConsumed': totals.proteinG.round(),
      'cuisine': cuisine,
    };
    if (targets?.proteinTargetG != null) {
      facts['proteinTarget'] = targets!.proteinTargetG!.round();
      facts['proteinGap'] =
          (targets.proteinTargetG! - totals.proteinG).clamp(0, 999).round();
    }

    return AssistantAnswer(
      intent: AssistantIntent.raiseProtein,
      facts: facts,
      citations: [
        AssistantCitation(
          label: 'Today\'s diary',
          detail: 'protein ${totals.proteinG.round()} g',
        ),
      ],
      tipKeys: [
        'assistantTipProteinPairDal',
        'assistantTipProteinPairYoghurt',
        'assistantTipProteinPairEgg',
        'assistantTipModifyNotReplace',
      ],
    );
  }

  AssistantAnswer _substituteAnswer(AssistantContext context) {
    final cuisines = context.familiarCuisines;
    final cuisine = cuisines.isNotEmpty ? cuisines.first : 'your cuisine';
    return AssistantAnswer(
      intent: AssistantIntent.foodSubstitute,
      facts: {'cuisine': cuisine},
      tipKeys: [
        'assistantTipModifyNotReplace',
        'assistantTipModifyPortion',
        'assistantTipAddVegetables',
        'assistantTipAddProteinSide',
        'assistantTipNoMoralFood',
      ],
    );
  }

  Future<AssistantAnswer> _culturalStapleAnswer(
    AssistantContext context,
    String question,
    Future<List<Food>> Function(String query)? foodLookup,
  ) async {
    final staple = _findStapleMention(question) ?? 'familiar staple foods';
    final cuisines = context.familiarCuisines;
    final cuisine = cuisines.isNotEmpty ? cuisines.first : 'your cuisine';
    final goal = context.profile?.goal ?? NutritionGoal.trackOnly;

    final facts = <String, Object>{
      'staple': staple,
      'cuisine': cuisine,
      'goal': goal.name,
    };

    final citations = <AssistantCitation>[];
    if (foodLookup != null) {
      final foods = await foodLookup(staple);
      if (foods.isNotEmpty) {
        final food = foods.first;
        final grams = food.defaultServingGrams ?? 100;
        final kcal = NutritionCalculator.scale(
          food.nutrientPer100g(NutrientCode.energyKcal),
          grams,
        );
        if (kcal != null) {
          facts['foodName'] = food.displayName;
          facts['kcal'] = NutritionCalculator.roundKcal(kcal);
          facts['portionName'] = food.portions.isNotEmpty
              ? food.portions.first.name
              : '${grams.round()} g';
          facts['confidence'] = food.confidence.name;
          facts['sourceName'] = food.source.name;
          citations.add(
            AssistantCitation(
              label: food.displayName,
              detail:
                  '≈ ${NutritionCalculator.roundKcal(kcal)} kcal per '
                  '${facts['portionName']} · ${food.source.name}',
              confidence: food.confidence,
            ),
          );
        }
      }
    }

    return AssistantAnswer(
      intent: AssistantIntent.culturalStapleOk,
      facts: facts,
      citations: citations,
      tipKeys: [
        'assistantTipModifyPortion',
        'assistantTipAddVegetables',
        'assistantTipAddProteinSide',
        'assistantTipModifyNotReplace',
        'assistantTipNoMoralFood',
      ],
      matchedFoodName: facts['foodName'] as String?,
    );
  }

  AssistantAnswer _mealBalanceAnswer(AssistantContext context) {
    final totals = context.todayTotals ?? const DailyTotals();
    final targets = context.targets;
    final facts = <String, Object>{
      'caloriesConsumed': totals.caloriesRounded,
      'proteinConsumed': totals.proteinG.round(),
      'carbConsumed': totals.carbohydrateG.round(),
      'fatConsumed': totals.fatG.round(),
      'fibreConsumed': totals.fibreG.round(),
      'entryCount': totals.entryCount,
    };

    if (targets?.calorieTargetKcal != null) {
      facts['calorieTarget'] = targets!.calorieTargetKcal!.round();
      facts['caloriesRemaining'] =
          (targets.calorieTargetKcal! - totals.caloriesKcal).round();
    }
    if (targets?.proteinTargetG != null) {
      facts['proteinTarget'] = targets!.proteinTargetG!.round();
      facts['proteinGap'] =
          (targets.proteinTargetG! - totals.proteinG).clamp(0, 999).round();
    }

    final tips = <String>['assistantTipNoMoralFood'];
    final proteinGap = (facts['proteinGap'] as int?) ?? 0;
    final fibre = totals.fibreG;
    if (proteinGap >= 15) {
      tips.insert(0, 'assistantTipAddProteinSide');
    }
    if (fibre < 15) {
      tips.insert(0, 'assistantTipAddVegetables');
    }
    if (totals.entryCount == 0) {
      tips.insert(0, 'assistantTipLogSomething');
    } else {
      tips.insert(0, 'assistantTipModifyNotReplace');
    }

    return AssistantAnswer(
      intent: AssistantIntent.mealBalance,
      facts: facts,
      citations: [
        AssistantCitation(
          label: 'Today\'s diary',
          detail:
              '${totals.caloriesRounded} kcal · P ${totals.proteinG.round()} g · '
              'C ${totals.carbohydrateG.round()} g · F ${totals.fatG.round()} g',
        ),
        if (targets?.isConfigured == true)
          AssistantCitation(
            label: 'Your targets',
            detail:
                '${targets!.calorieTargetKcal?.round() ?? '—'} kcal · '
                'protein ${targets.proteinTargetG?.round() ?? '—'} g',
          ),
      ],
      tipKeys: tips,
    );
  }

  String _extractFoodQuery(String question) {
    var q = question.trim();
    q = q.replaceAll(_calorieLookupPattern, ' ');
    q = q.replaceAll(RegExp(r'[?!.]'), ' ');
    q = q.replaceAll(
      RegExp(
        r'\b(a|an|the|please|tell me|what|is|are|in|of|for|about|how|many|'
        r'much|does|do|per)\b',
        caseSensitive: false,
      ),
      ' ',
    );
    return q.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _looksLikeFoodQuery(String q) {
    final words = q.trim().split(RegExp(r'\s+'));
    if (words.length > 6) return false;
    if (_medicalPattern.hasMatch(q)) return false;
    return _staplePattern.hasMatch(q) ||
        RegExp(r'^[a-zA-Z\u0900-\u097F\u0A00-\u0A7F\u0600-\u06FF\s\-]+$')
            .hasMatch(q);
  }

  String? _findStapleMention(String question) {
    final match = _staplePattern.firstMatch(question);
    return match?.group(0);
  }
}
