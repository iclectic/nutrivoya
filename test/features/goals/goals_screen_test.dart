import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/reproductive_context.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/features/dashboard/dashboard_screen.dart';
import 'package:nutrivoya/features/goals/goals_screen.dart';
import 'package:nutrivoya/features/goals/targets_providers.dart';

import '../../helpers/test_app.dart';

const _profile = UserProfile(
  id: 'local',
  ageYears: 30,
  heightCm: 165,
  weightKg: 70,
  physiologicalInput: PhysiologicalInput.female,
  activityLevel: ActivityLevel.moderate,
  goal: NutritionGoal.maintainWeight,
);

void main() {
  testWidgets('goals screen shows estimated targets', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer(profile: _profile);
    await tester.pumpWidget(testApp(c, const GoalsScreen()));
    await tester.pumpAndSettle();
    // 1420.25 * 1.55 = 2201
    expect(find.text('2201 kcal'), findsWidgets);
    expect(find.textContaining('estimates'), findsOneWidget);
  });

  testWidgets('pregnancy shows guardrail and no deficit', (tester) async {
    await useTallScreen(tester);
    final c = await testContainer(
      profile: _profile.copyWith(
        goal: NutritionGoal.loseWeight,
        reproductiveContext: ReproductiveContext.pregnant,
      ),
    );
    await tester.pumpWidget(testApp(c, const GoalsScreen()));
    await tester.pumpAndSettle();
    expect(find.textContaining('during pregnancy'), findsOneWidget);
    expect(c.read(nutritionTargetsProvider).calorieTargetKcal!.round(), 2201);
  });

  testWidgets('custom target is saved and very low target warns',
      (tester) async {
    await useTallScreen(tester);
    final c = await testContainer(profile: _profile);
    await tester.pumpWidget(testApp(c, const GoalsScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('goals-custom-field')), '900');
    await tester.tap(find.byKey(const Key('goals-custom-save')));
    await tester.pumpAndSettle();
    expect(c.read(customCalorieTargetProvider), 900);
    expect(find.textContaining('very low'), findsOneWidget);
  });

  testWidgets('dashboard shows consumed versus target and FAB opens search',
      (tester) async {
    await useTallScreen(tester);
    final c = await testContainer(profile: _profile);
    await tester.pumpWidget(testApp(c, const DashboardScreen()));
    await tester.pumpAndSettle();
    expect(find.text('0 / 2201 kcal'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('stub-search'), findsOneWidget);
    await settleStreams(tester);
  });
}
