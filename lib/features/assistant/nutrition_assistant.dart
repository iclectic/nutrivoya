import '../../core/models/diary_entry.dart';
import '../../core/models/food.dart';
import '../../core/models/nutrient.dart';
import '../../core/models/nutrition_targets.dart';
import '../../core/models/reproductive_context.dart';
import '../../core/models/user_profile.dart';

enum AssistantIntent { dayReview, balanceMeal, foodInsight, swapIdeas, unknown }

enum SafetyTopic { eatingDisorder, pregnancy, medication, kidney, rapidLoss, medicalCondition }

/// Neutral, factual descriptors derived from per-100 g data — never "good" or
/// "bad" labels.
enum FoodHighlight {
  highProtein,
  sourceOfProtein,
  highFibre,
  sourceOfFibre,
  energyDense,
  lowEnergyDensity,
  highSodium,
}

enum SwapReason { moreFibre, moreProtein, lighter }

class FoodInsight {
  const FoodInsight({
    required this.food,
    required this.servingGrams,
    required this.perServing,
    required this.highlights,
    required this.hasMissingValues,
  });
  final Food food;
  final double servingGrams;
  final Map<NutrientCode, double?> perServing;
  final Set<FoodHighlight> highlights;
  final bool hasMissingValues;
}

class MealBalance {
  const MealBalance({
    this.proteinGapG,
    this.fibreGapG,
    this.proteinIdeas = const [],
    this.fibreIdeas = const [],
  });
  final double? proteinGapG;
  final double? fibreGapG;
  final List<Food> proteinIdeas;
  final List<Food> fibreIdeas;
  bool get onTrack => proteinGapG == null && fibreGapG == null;
}

class SwapIdea {
  const SwapIdea(this.food, this.reason);
  final Food food;
  final SwapReason reason;
}

/// "Ask Nutrivoya": a deterministic guidance engine. Every number it surfaces
/// comes from structured food data, the diary or the targets services; it
/// never generates nutrition values. High-risk topics are referred onwards.
class NutritionAssistant {
  const NutritionAssistant();

  static const _safetyKeywords = <SafetyTopic, List<String>>{
    SafetyTopic.eatingDisorder: [
      'anorexi', 'bulimi', 'binge', 'purg', 'eating disorder', 'starv',
      'laxative', 'make myself sick', 'throw up',
    ],
    SafetyTopic.pregnancy: ['pregnan', 'breastfeed', 'breast feed'],
    SafetyTopic.medication: ['insulin', 'metformin', 'medication', 'medicine', 'pills'],
    SafetyTopic.kidney: ['kidney', 'dialysis', 'renal'],
    SafetyTopic.rapidLoss: ['crash diet', 'lose weight fast', 'rapid weight loss', 'water fast', 'stop eating'],
    SafetyTopic.medicalCondition: ['diabet', 'cancer', 'heart disease', 'blood pressure', 'prescribed diet'],
  };

  static const _intentKeywords = <AssistantIntent, List<String>>{
    AssistantIntent.swapIdeas: ['swap', 'instead', 'alternative', 'substitut', 'replace'],
    AssistantIntent.balanceMeal: ['balance', 'next meal', 'what should i eat', 'dinner', 'lunch'],
    AssistantIntent.dayReview: ['my day', 'today', 'so far', 'how am i doing'],
    AssistantIntent.foodInsight: ['about', 'what is', 'tell me', 'how much', 'nutrition'],
  };

  Set<SafetyTopic> safetyTopics(String text) {
    final t = text.toLowerCase();
    return {
      for (final e in _safetyKeywords.entries)
        if (e.value.any(t.contains)) e.key,
    };
  }

  AssistantIntent classify(String text) {
    final t = text.toLowerCase();
    for (final e in _intentKeywords.entries) {
      if (e.value.any(t.contains)) return e.key;
    }
    return AssistantIntent.unknown;
  }

  /// Words left after removing intent phrases — used to find a food mention.
  String foodQuery(String text) {
    var t = text.toLowerCase();
    for (final words in _intentKeywords.values) {
      for (final w in words) {
        t = t.replaceAll(w, ' ');
      }
    }
    t = t.replaceAll(RegExp(r'\b(for|of|a|an|the|me|to|is|ideas?|food|eat|with)\b'), ' ');
    return t.replaceAll(RegExp(r'[?!.,]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Whether the profile warrants a "check with a professional" note.
  bool profileNeedsCaution(UserProfile? p) {
    if (p == null) return false;
    return p.ageYears < 18 ||
        p.bmi < 18.5 ||
        p.reproductiveContext == ReproductiveContext.pregnant ||
        p.reproductiveContext == ReproductiveContext.breastfeeding;
  }

  Set<FoodHighlight> highlights(Food food) {
    final kcal = food.nutrientPer100g(NutrientCode.energyKcal);
    final protein = food.nutrientPer100g(NutrientCode.proteinG);
    final fibre = food.nutrientPer100g(NutrientCode.fibreG);
    final sodium = food.nutrientPer100g(NutrientCode.sodiumMg);
    final out = <FoodHighlight>{};
    if (kcal != null && kcal > 0 && protein != null) {
      final share = protein * 4 / kcal;
      if (share >= 0.20) {
        out.add(FoodHighlight.highProtein);
      } else if (share >= 0.12) {
        out.add(FoodHighlight.sourceOfProtein);
      }
    }
    if (fibre != null) {
      if (fibre >= 6) {
        out.add(FoodHighlight.highFibre);
      } else if (fibre >= 3) {
        out.add(FoodHighlight.sourceOfFibre);
      }
    }
    if (kcal != null) {
      if (kcal >= 400) out.add(FoodHighlight.energyDense);
      if (kcal > 0 && kcal < 100) out.add(FoodHighlight.lowEnergyDensity);
    }
    if (sodium != null && sodium > 600) out.add(FoodHighlight.highSodium);
    return out;
  }

  FoodInsight insight(Food food) {
    final grams = food.defaultServingGrams ??
        (food.portions.isNotEmpty ? food.portions.first.grams : 100);
    const codes = [
      NutrientCode.energyKcal,
      NutrientCode.proteinG,
      NutrientCode.carbohydrateG,
      NutrientCode.fatG,
      NutrientCode.fibreG,
    ];
    final per = {
      for (final c in codes)
        c: food.nutrientPer100g(c) == null ? null : food.nutrientPer100g(c)! * grams / 100,
    };
    return FoodInsight(
      food: food,
      servingGrams: grams,
      perServing: per,
      highlights: highlights(food),
      hasMissingValues: per.values.any((v) => v == null),
    );
  }

  double? _density(Food f, NutrientCode code) {
    final kcal = f.nutrientPer100g(NutrientCode.energyKcal);
    final v = f.nutrientPer100g(code);
    if (kcal == null || kcal <= 0 || v == null) return null;
    return v / kcal * 100;
  }

  bool _familiar(Food f, UserProfile? p) =>
      p != null && f.cuisine != null && p.familiarCuisines.contains(f.cuisine);

  List<Food> _rank(List<Food> foods, NutrientCode code, UserProfile? p, double minDensity) {
    final eligible = foods
        .where((f) => (_density(f, code) ?? 0) >= minDensity && f.id != 'water')
        .toList()
      ..sort((a, b) {
        final fam = (_familiar(b, p) ? 1 : 0) - (_familiar(a, p) ? 1 : 0);
        if (fam != 0) return fam;
        return _density(b, code)!.compareTo(_density(a, code)!);
      });
    return eligible.take(3).toList();
  }

  MealBalance balance(DailyTotals totals, NutritionTargets targets, List<Food> candidates, UserProfile? p) {
    double? gap(double? target, double consumed, double min) {
      if (target == null) return null;
      final g = target - consumed;
      return g > min ? g : null;
    }

    final proteinGap = gap(targets.proteinTargetG, totals.proteinG, 10);
    final fibreGap = gap(targets.fibreTargetG, totals.fibreG, 5);
    return MealBalance(
      proteinGapG: proteinGap,
      fibreGapG: fibreGap,
      proteinIdeas: proteinGap == null ? const [] : _rank(candidates, NutrientCode.proteinG, p, 5),
      fibreIdeas: fibreGap == null ? const [] : _rank(candidates, NutrientCode.fibreG, p, 2),
    );
  }

  bool _sameTradition(Food a, Food b) =>
      (a.cuisine != null && a.cuisine == b.cuisine) ||
      (a.region != null && a.region == b.region) ||
      a.allCountries.intersection(b.allCountries).isNotEmpty;

  List<SwapIdea> swaps(Food food, List<Food> candidates) {
    final ideas = <SwapIdea>[];
    final kcal = food.nutrientPer100g(NutrientCode.energyKcal);
    for (final c in candidates) {
      if (c.id == food.id || c.id == 'water' || !_sameTradition(food, c)) continue;
      if (c.foodType != food.foodType) continue;
      final f0 = _density(food, NutrientCode.fibreG), f1 = _density(c, NutrientCode.fibreG);
      final p0 = _density(food, NutrientCode.proteinG), p1 = _density(c, NutrientCode.proteinG);
      final k1 = c.nutrientPer100g(NutrientCode.energyKcal);
      if (f0 != null && f1 != null && f1 >= f0 * 1.25 && f1 - f0 >= 0.5) {
        ideas.add(SwapIdea(c, SwapReason.moreFibre));
      } else if (p0 != null && p1 != null && p1 >= p0 * 1.25 && p1 - p0 >= 1) {
        ideas.add(SwapIdea(c, SwapReason.moreProtein));
      } else if (kcal != null && k1 != null && k1 <= kcal * 0.75) {
        ideas.add(SwapIdea(c, SwapReason.lighter));
      }
    }
    return ideas.take(3).toList();
  }
}
