import 'package:flutter/foundation.dart';

import 'activity_level.dart';
import 'nutrition_goal.dart';
import 'physiological_input.dart';
import 'reproductive_context.dart';

/// User profile captured during onboarding.
///
/// Only the minimum required for personalized energy estimates is stored.
/// Optional fields (target rate, reproductive context) are opt-in.
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    required this.physiologicalInput,
    required this.activityLevel,
    required this.goal,
    this.familiarCuisines = const <String>[],
    this.displayName,
    this.targetRateKgPerWeek,
    this.reproductiveContext = ReproductiveContext.none,
  });

  /// Supabase auth user id (or a local placeholder id when offline).
  final String id;

  final int ageYears;
  final double heightCm;
  final double weightKg;
  final PhysiologicalInput physiologicalInput;
  final ActivityLevel activityLevel;
  final NutritionGoal goal;

  /// Free-text / canonical cuisine tags the user identifies with. Optional.
  final List<String> familiarCuisines;

  final String? displayName;

  /// Desired rate of weight change in kg/week (absolute value). Only used for
  /// weight-loss / weight-gain goals; guardrails cap unsafe values.
  final double? targetRateKgPerWeek;

  /// Optional opt-in life-stage context.
  final ReproductiveContext reproductiveContext;

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  /// Basic sanity guardrails. Does not perform medical validation.
  bool get isPlausible =>
      ageYears >= 13 &&
      ageYears <= 120 &&
      heightCm >= 80 &&
      heightCm <= 250 &&
      weightKg >= 20 &&
      weightKg <= 400;

  UserProfile copyWith({
    String? id,
    int? ageYears,
    double? heightCm,
    double? weightKg,
    PhysiologicalInput? physiologicalInput,
    ActivityLevel? activityLevel,
    NutritionGoal? goal,
    List<String>? familiarCuisines,
    String? displayName,
    double? targetRateKgPerWeek,
    ReproductiveContext? reproductiveContext,
  }) {
    return UserProfile(
      id: id ?? this.id,
      ageYears: ageYears ?? this.ageYears,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      physiologicalInput: physiologicalInput ?? this.physiologicalInput,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      familiarCuisines: familiarCuisines ?? this.familiarCuisines,
      displayName: displayName ?? this.displayName,
      targetRateKgPerWeek: targetRateKgPerWeek ?? this.targetRateKgPerWeek,
      reproductiveContext: reproductiveContext ?? this.reproductiveContext,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ageYears == other.ageYears &&
          heightCm == other.heightCm &&
          weightKg == other.weightKg &&
          physiologicalInput == other.physiologicalInput &&
          activityLevel == other.activityLevel &&
          goal == other.goal &&
          listEquals(familiarCuisines, other.familiarCuisines) &&
          displayName == other.displayName &&
          targetRateKgPerWeek == other.targetRateKgPerWeek &&
          reproductiveContext == other.reproductiveContext;

  @override
  int get hashCode => Object.hash(
        id,
        ageYears,
        heightCm,
        weightKg,
        physiologicalInput,
        activityLevel,
        goal,
        Object.hashAll(familiarCuisines),
        displayName,
        targetRateKgPerWeek,
        reproductiveContext,
      );
}
