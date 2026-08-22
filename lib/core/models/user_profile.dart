import 'package:flutter/foundation.dart';

import 'activity_level.dart';
import 'nutrition_goal.dart';
import 'physiological_input.dart';

/// User profile captured during onboarding.
///
/// Only the minimum required for personalized energy estimates is stored.
/// Optional fields (e.g. reproductive context) are intentionally absent in
/// Milestone 1 and will be added behind explicit opt-in later.
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
          displayName == other.displayName;

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
      );
}
