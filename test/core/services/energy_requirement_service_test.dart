import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/energy_requirement.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/core/services/energy_requirement_service.dart';

void main() {
  const service = EnergyRequirementService();

  UserProfile profile({
    int age = 30,
    double height = 170,
    double weight = 70,
    PhysiologicalInput physio = PhysiologicalInput.female,
    ActivityLevel activity = ActivityLevel.moderate,
    NutritionGoal goal = NutritionGoal.maintainWeight,
  }) {
    return UserProfile(
      id: 'test',
      ageYears: age,
      heightCm: height,
      weightKg: weight,
      physiologicalInput: physio,
      activityLevel: activity,
      goal: goal,
    );
  }

  group('EnergyRequirementService BMR / TDEE', () {
    test('Mifflin–St Jeor female BMR is within expected range', () {
      // 10*70 + 6.25*170 - 5*30 - 161 = 700 + 1062.5 - 150 - 161 = 1451.5
      final result = service.estimate(profile());
      expect(result.bmrKcal, closeTo(1450, 20));
      expect(result.tdeeKcal, greaterThan(result.bmrKcal));
      // Moderate activity 1.55 → ~2250
      expect(result.tdeeKcal, closeTo(2250, 40));
    });

    test('male BMR is higher than female for same anthropometrics', () {
      final female = service.estimate(profile());
      final male = service.estimate(
        profile(physio: PhysiologicalInput.male),
      );
      expect(male.bmrKcal, greaterThan(female.bmrKcal));
    });

    test('unspecified physio averages male/female and lowers confidence', () {
      final result = service.estimate(
        profile(physio: PhysiologicalInput.unspecified),
      );
      expect(
        result.confidence,
        EnergyEstimateConfidence.reduced,
      );
      expect(
        result.warningCodes,
        contains(EnergyWarningCode.physiologicalUnspecified),
      );
    });

    test('higher activity increases TDEE', () {
      final sedentary = service.estimate(
        profile(activity: ActivityLevel.sedentary),
      );
      final extra = service.estimate(
        profile(activity: ActivityLevel.extra),
      );
      expect(extra.tdeeKcal, greaterThan(sedentary.tdeeKcal));
    });
  });

  group('goal adjustments & guardrails', () {
    test('maintain uses TDEE as calorie target', () {
      final result = service.estimate(profile());
      expect(result.calorieTargetKcal, result.tdeeKcal);
      expect(result.appliedDeficitKcal, isNull);
    });

    test('lose weight applies a modest deficit', () {
      final result = service.estimate(
        profile(goal: NutritionGoal.loseWeight),
      );
      expect(result.calorieTargetKcal!, lessThan(result.tdeeKcal));
      expect(result.appliedDeficitKcal, greaterThan(0));
      expect(result.appliedDeficitKcal! <= 750, isTrue);
    });

    test('gain weight applies a surplus', () {
      final result = service.estimate(
        profile(goal: NutritionGoal.gainWeight),
      );
      expect(result.calorieTargetKcal!, greaterThan(result.tdeeKcal));
      expect(result.appliedSurplusKcal, greaterThan(0));
    });

    test('build muscle applies a smaller surplus than pure gain', () {
      final gain = service.estimate(
        profile(goal: NutritionGoal.gainWeight),
      );
      final muscle = service.estimate(
        profile(goal: NutritionGoal.buildMuscle),
      );
      expect(muscle.appliedSurplusKcal!, lessThan(gain.appliedSurplusKcal!));
    });

    test('calorie floor prevents extreme restriction', () {
      // Small, sedentary female with large implied deficit relative to TDEE.
      final result = service.estimate(
        profile(
          age: 25,
          height: 155,
          weight: 45,
          activity: ActivityLevel.sedentary,
          goal: NutritionGoal.loseWeight,
          physio: PhysiologicalInput.female,
        ),
      );
      expect(
        result.calorieTargetKcal!,
        greaterThanOrEqualTo(EnergyRequirementService.minCaloriesFemale),
      );
      expect(
        result.warningCodes,
        anyOf(
          contains(EnergyWarningCode.floorApplied),
          contains(EnergyWarningCode.deficitCapped),
          contains(EnergyWarningCode.loseWhileLowWeight),
        ),
      );
    });

    test('lose while low BMI raises a warning', () {
      final result = service.estimate(
        profile(
          height: 170,
          weight: 48, // BMI ~16.6
          goal: NutritionGoal.loseWeight,
        ),
      );
      expect(
        result.warningCodes,
        contains(EnergyWarningCode.loseWhileLowWeight),
      );
    });

    test('age outside adult range lowers confidence', () {
      final result = service.estimate(profile(age: 15));
      expect(result.confidence, EnergyEstimateConfidence.limited);
      expect(
        result.warningCodes,
        contains(EnergyWarningCode.ageOutsideAdultRange),
      );
    });
  });

  group('macros', () {
    test('targets are configured with rounded macros', () {
      final result = service.estimate(profile());
      final t = result.targets;
      expect(t.isConfigured, isTrue);
      expect(t.isEstimate, isTrue);
      expect(t.proteinTargetG, greaterThan(0));
      expect(t.carbTargetG, greaterThan(0));
      expect(t.fatTargetG, greaterThan(0));
      expect(t.fibreTargetG, greaterThanOrEqualTo(25));
      // Calories rounded to nearest 10.
      expect(t.calorieTargetKcal! % 10, 0);
    });

    test('protein is higher for loss than track-only', () {
      final loss = service.estimate(
        profile(goal: NutritionGoal.loseWeight),
      );
      final track = service.estimate(
        profile(goal: NutritionGoal.trackOnly),
      );
      expect(
        loss.targets.proteinTargetG!,
        greaterThan(track.targets.proteinTargetG!),
      );
    });

    test('macro energy roughly reconciles to calorie target', () {
      final result = service.estimate(profile());
      final t = result.targets;
      final energy = (t.proteinTargetG! * 4) +
          (t.carbTargetG! * 4) +
          (t.fatTargetG! * 9);
      expect(energy, closeTo(t.calorieTargetKcal!, 20));
    });
  });
}
