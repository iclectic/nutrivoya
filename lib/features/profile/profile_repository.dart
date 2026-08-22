import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/activity_level.dart';
import '../../core/models/nutrition_goal.dart';
import '../../core/models/physiological_input.dart';
import '../../core/models/user_profile.dart';
import '../../core/storage/local_preferences.dart';

/// Persists the user profile locally (offline-first).
///
/// In a later milestone this syncs with Supabase; for Milestone 1 it is stored
/// in SharedPreferences as JSON so onboarding survives app restarts.
class ProfileRepository {
  ProfileRepository(this._prefs);

  final LocalPreferences _prefs;

  static const _keyProfile = 'nutrivoya.profile';

  UserProfile? get() {
    final raw = _prefs.getString(_keyProfile);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile(
        id: json['id'] as String? ?? '',
        ageYears: (json['ageYears'] as num).toInt(),
        heightCm: (json['heightCm'] as num).toDouble(),
        weightKg: (json['weightKg'] as num).toDouble(),
        physiologicalInput:
            PhysiologicalInputX.fromId(json['physiologicalInput'] as String? ?? ''),
        activityLevel:
            ActivityLevelX.fromId(json['activityLevel'] as String? ?? ''),
        goal: NutritionGoalX.fromId(json['goal'] as String? ?? ''),
        familiarCuisines:
            (json['familiarCuisines'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
                const <String>[],
        displayName: json['displayName'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(UserProfile profile) async {
    final json = jsonEncode({
      'id': profile.id,
      'ageYears': profile.ageYears,
      'heightCm': profile.heightCm,
      'weightKg': profile.weightKg,
      'physiologicalInput': profile.physiologicalInput.id,
      'activityLevel': profile.activityLevel.id,
      'goal': profile.goal.id,
      'familiarCuisines': profile.familiarCuisines,
      'displayName': profile.displayName,
    });
    await _prefs.setString(_keyProfile, json);
  }

  Future<void> clear() => _prefs.remove(_keyProfile);
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(localPreferencesSyncProvider)),
);
