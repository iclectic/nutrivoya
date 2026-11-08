import '../../../core/models/activity_level.dart';
import '../../../core/models/nutrition_goal.dart';
import '../../../core/models/nutrition_targets.dart';
import '../../../core/models/reproductive_context.dart';
import '../../../core/models/user_profile.dart';

/// Turns an energy target into protein / carbohydrate / fat / fibre targets.
///
/// Evidence-informed defaults, individualized by body weight, goal, training
/// and life stage — not bodybuilding extremes:
/// - Protein: 0.8 g/kg (RDA) sedentary → 1.0 g/kg active; 1.6 g/kg when in a
///   deficit or building muscle; 1.1 g/kg minimum in pregnancy, 1.3 g/kg while
///   breastfeeding, 1.0 g/kg minimum from age 65. With BMI > 30 the weight at
///   BMI 25 is used so targets are not inflated.
/// - Fat: 30% of energy (within the 20–35% acceptable range).
/// - Fibre: 14 g per 1,000 kcal.
/// - Carbohydrate: the remainder, never below 130 g/day.
class MacroTargetService {
  const MacroTargetService();

  static const double fatEnergyFraction = 0.30;
  static const double minFatEnergyFraction = 0.20;
  static const double fibrePer1000Kcal = 14;
  static const double minCarbG = 130;

  double proteinGPerKg(UserProfile p) {
    double perKg;
    switch (p.goal) {
      case NutritionGoal.loseWeight:
      case NutritionGoal.buildMuscle:
        perKg = 1.6;
      case NutritionGoal.gainWeight:
        perKg = 1.4;
      case NutritionGoal.maintainWeight:
      case NutritionGoal.improveNutrition:
      case NutritionGoal.trackOnly:
        perKg = p.activityLevel == ActivityLevel.sedentary ? 0.8 : 1.0;
    }
    if (p.reproductiveContext == ReproductiveContext.pregnant && perKg < 1.1) {
      perKg = 1.1;
    }
    if (p.reproductiveContext == ReproductiveContext.breastfeeding &&
        perKg < 1.3) {
      perKg = 1.3;
    }
    if (p.ageYears >= 65 && perKg < 1.0) perKg = 1.0;
    return perKg;
  }

  /// Weight used for protein calculations.
  double referenceWeightKg(UserProfile p) {
    if (p.bmi <= 30) return p.weightKg;
    final h = p.heightCm / 100;
    return 25 * h * h;
  }

  NutritionTargets targets(UserProfile p, double calorieTargetKcal) {
    final protein = proteinGPerKg(p) * referenceWeightKg(p);
    var fat = calorieTargetKcal * fatEnergyFraction / 9;
    var carbs = (calorieTargetKcal - protein * 4 - fat * 9) / 4;
    if (carbs < minCarbG) {
      final minFat = calorieTargetKcal * minFatEnergyFraction / 9;
      final shortfallKcal = (minCarbG - carbs) * 4;
      final reducibleFat = fat - minFat;
      final fatReduction =
          (shortfallKcal / 9).clamp(0, reducibleFat).toDouble();
      fat -= fatReduction;
      carbs += fatReduction * 9 / 4;
      if (carbs < minCarbG) carbs = minCarbG;
    }
    final fibre = calorieTargetKcal / 1000 * fibrePer1000Kcal;
    return NutritionTargets(
      calorieTargetKcal: calorieTargetKcal,
      proteinTargetG: protein,
      carbTargetG: carbs,
      fatTargetG: fat,
      fibreTargetG: fibre,
      goal: p.goal,
    );
  }
}
