import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/nutrition_targets.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/user_profile.dart';

void main() {
  group('NutritionGoal', () {
    test('id round-trips through fromId', () {
      for (final goal in NutritionGoal.values) {
        expect(NutritionGoalX.fromId(goal.id), goal);
      }
    });

    test('unknown id falls back to trackOnly', () {
      expect(NutritionGoalX.fromId('does-not-exist'),
          NutritionGoal.trackOnly);
    });

    test('every goal has a distinct l10n key', () {
      final keys = NutritionGoal.values.map((g) => g.l10nKey).toSet();
      expect(keys.length, NutritionGoal.values.length);
    });
  });

  group('ActivityLevel', () {
    test('id round-trips through fromId', () {
      for (final level in ActivityLevel.values) {
        expect(ActivityLevelX.fromId(level.id), level);
      }
    });

    test('unknown id falls back to sedentary', () {
      expect(ActivityLevelX.fromId('x'), ActivityLevel.sedentary);
    });
  });

  group('PhysiologicalInput', () {
    test('id round-trips through fromId', () {
      for (final input in PhysiologicalInput.values) {
        expect(PhysiologicalInputX.fromId(input.id), input);
      }
    });

    test('unknown id falls back to unspecified', () {
      expect(PhysiologicalInputX.fromId('x'),
          PhysiologicalInput.unspecified);
    });
  });

  group('MealType', () {
    test('displayOrder contains all meals in expected order', () {
      expect(mealTypeDisplayOrder, [
        MealType.breakfast,
        MealType.lunch,
        MealType.dinner,
        MealType.snacks,
      ]);
    });

    test('id round-trips through fromId', () {
      for (final meal in MealType.values) {
        expect(MealTypeX.fromId(meal.id), meal);
      }
    });
  });

  group('UserProfile', () {
    final base = UserProfile(
      id: 'u1',
      ageYears: 30,
      heightCm: 175,
      weightKg: 70,
      physiologicalInput: PhysiologicalInput.male,
      activityLevel: ActivityLevel.moderate,
      goal: NutritionGoal.maintainWeight,
      familiarCuisines: const ['Punjabi'],
      displayName: 'Aisha',
    );

    test('isPlausible is true for sane values', () {
      expect(base.isPlausible, isTrue);
    });

    test('isPlausible is false for out-of-range values', () {
      final young = base.copyWith(ageYears: 5);
      expect(young.isPlausible, isFalse);
      final light = base.copyWith(weightKg: 5);
      expect(light.isPlausible, isFalse);
    });

    test('copyWith preserves unchanged fields and updates given ones', () {
      final updated = base.copyWith(weightKg: 72, goal: NutritionGoal.loseWeight);
      expect(updated.weightKg, 72);
      expect(updated.goal, NutritionGoal.loseWeight);
      expect(updated.ageYears, base.ageYears);
      expect(updated.heightCm, base.heightCm);
      expect(updated.id, base.id);
    });

    test('equality respects all fields', () {
      expect(base, base.copyWith());
      expect(base == base.copyWith(displayName: 'Other'), isFalse);
    });
  });

  group('NutritionTargets', () {
    test('isConfigured is false when calorie target is null', () {
      const targets = NutritionTargets();
      expect(targets.isConfigured, isFalse);
    });

    test('isConfigured is true when calorie target is set', () {
      const targets = NutritionTargets(calorieTargetKcal: 2000);
      expect(targets.isConfigured, isTrue);
    });

    test('isEstimate defaults to true', () {
      const targets = NutritionTargets(calorieTargetKcal: 2000);
      expect(targets.isEstimate, isTrue);
    });

    test('copyWith updates only provided fields', () {
      const targets = NutritionTargets(calorieTargetKcal: 2000);
      final updated = targets.copyWith(proteinTargetG: 120);
      expect(updated.calorieTargetKcal, 2000);
      expect(updated.proteinTargetG, 120);
    });
  });
}
