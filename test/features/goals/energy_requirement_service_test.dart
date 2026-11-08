import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/reproductive_context.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/features/goals/domain/energy_requirement_service.dart';
import 'package:nutrivoya/features/goals/domain/macro_target_service.dart';

UserProfile _profile({
  int age = 30,
  double height = 165,
  double weight = 70,
  PhysiologicalInput input = PhysiologicalInput.female,
  ActivityLevel activity = ActivityLevel.moderate,
  NutritionGoal goal = NutritionGoal.maintainWeight,
  double? rate,
  ReproductiveContext repro = ReproductiveContext.none,
}) =>
    UserProfile(
      id: 'u',
      ageYears: age,
      heightCm: height,
      weightKg: weight,
      physiologicalInput: input,
      activityLevel: activity,
      goal: goal,
      targetRateKgPerWeek: rate,
      reproductiveContext: repro,
    );

void main() {
  const service = EnergyRequirementService();
  const macros = MacroTargetService();

  group('EnergyRequirementService', () {
    test('Mifflin-St Jeor BMR for female/male/unspecified', () {
      // 10*70 + 6.25*165 - 5*30 = 1581.25
      expect(
          service.bmr(weightKg: 70, heightCm: 165, ageYears: 30, input: PhysiologicalInput.female),
          closeTo(1420.25, 0.01));
      expect(
          service.bmr(weightKg: 70, heightCm: 165, ageYears: 30, input: PhysiologicalInput.male),
          closeTo(1586.25, 0.01));
      expect(
          service.bmr(weightKg: 70, heightCm: 165, ageYears: 30, input: PhysiologicalInput.unspecified),
          closeTo(1503.25, 0.01));
    });

    test('maintenance target equals TDEE', () {
      final e = service.estimate(_profile());
      expect(e.tdeeKcal, closeTo(1420.25 * 1.55, 0.01));
      expect(e.targetKcal, e.tdeeKcal);
      expect(e.warnings, isEmpty);
      expect(e.confidence, EstimateConfidence.standard);
    });

    test('unspecified input reduces confidence', () {
      final e = service.estimate(_profile(input: PhysiologicalInput.unspecified));
      expect(e.confidence, EstimateConfidence.reduced);
      expect(e.warnings, contains(TargetWarning.neutralEquation));
    });

    test('weight loss uses requested rate', () {
      final e = service.estimate(_profile(goal: NutritionGoal.loseWeight, rate: 0.25));
      expect(e.targetKcal, closeTo(e.tdeeKcal - 275, 0.01));
    });

    test('aggressive weight-loss rate is capped and floored', () {
      final e = service.estimate(_profile(goal: NutritionGoal.loseWeight, rate: 2));
      expect(e.warnings, contains(TargetWarning.rateCapped));
      expect(e.targetKcal, greaterThanOrEqualTo(e.bmrKcal));
      expect(e.targetKcal, greaterThanOrEqualTo(EnergyRequirementService.absoluteFloorKcal));
    });

    test('no deficit during pregnancy', () {
      final e = service.estimate(_profile(
          goal: NutritionGoal.loseWeight, repro: ReproductiveContext.pregnant));
      expect(e.targetKcal, e.tdeeKcal);
      expect(e.warnings, contains(TargetWarning.pregnancyNoDeficit));
    });

    test('breastfeeding adds energy and blocks deficit', () {
      final e = service.estimate(_profile(
          goal: NutritionGoal.loseWeight, repro: ReproductiveContext.breastfeeding));
      expect(e.targetKcal, closeTo(e.tdeeKcal + 330, 0.01));
      expect(e.warnings, contains(TargetWarning.breastfeedingNoDeficit));
    });

    test('no deficit when underweight or under 18', () {
      final under = service.estimate(_profile(goal: NutritionGoal.loseWeight, weight: 45));
      expect(under.warnings, contains(TargetWarning.underweightNoDeficit));
      expect(under.targetKcal, under.tdeeKcal);
      final minor = service.estimate(_profile(goal: NutritionGoal.loseWeight, age: 16));
      expect(minor.warnings, contains(TargetWarning.minorNoDeficit));
    });

    test('muscle gain surplus is modest', () {
      final e = service.estimate(_profile(goal: NutritionGoal.buildMuscle));
      expect(e.targetKcal - e.tdeeKcal, lessThanOrEqualTo(350));
      expect(e.targetKcal, greaterThan(e.tdeeKcal));
    });

    test('custom target below floor is flagged', () {
      final e = service.estimate(_profile());
      expect(service.checkCustomTarget(900, e), contains(TargetWarning.customTargetVeryLow));
      expect(service.checkCustomTarget(2000, e), isEmpty);
    });
  });

  group('MacroTargetService', () {
    test('protein is individualized by goal and activity', () {
      expect(macros.proteinGPerKg(_profile(activity: ActivityLevel.sedentary)), 0.8);
      expect(macros.proteinGPerKg(_profile()), 1.0);
      expect(macros.proteinGPerKg(_profile(goal: NutritionGoal.loseWeight)), 1.6);
      expect(macros.proteinGPerKg(_profile(
              activity: ActivityLevel.sedentary, repro: ReproductiveContext.breastfeeding)),
          1.3);
      expect(macros.proteinGPerKg(_profile(activity: ActivityLevel.sedentary, age: 70)), 1.0);
    });

    test('high BMI uses reference weight for protein', () {
      final p = _profile(weight: 120, height: 170);
      expect(macros.referenceWeightKg(p), closeTo(25 * 1.7 * 1.7, 0.01));
    });

    test('targets add up and respect carb floor', () {
      final t = macros.targets(_profile(), 2000);
      final kcal = t.proteinTargetG! * 4 + t.carbTargetG! * 4 + t.fatTargetG! * 9;
      expect(kcal, closeTo(2000, 1));
      expect(t.fibreTargetG, closeTo(28, 0.01));
      final low = macros.targets(_profile(goal: NutritionGoal.loseWeight, weight: 90), 1300);
      expect(low.carbTargetG, greaterThanOrEqualTo(130));
      expect(low.fatTargetG! * 9 / 1300, greaterThanOrEqualTo(0.199));
    });
  });
}
