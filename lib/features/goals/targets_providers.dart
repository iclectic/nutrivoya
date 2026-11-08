import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/nutrition_targets.dart';
import '../../core/storage/local_preferences.dart';
import '../profile/profile_controller.dart';
import 'domain/energy_requirement_service.dart';
import 'domain/macro_target_service.dart';

final energyRequirementServiceProvider =
    Provider<EnergyRequirementService>((ref) => const EnergyRequirementService());

final macroTargetServiceProvider =
    Provider<MacroTargetService>((ref) => const MacroTargetService());

/// Optional user-chosen calorie target overriding the calculated one.
class CustomCalorieTargetController extends StateNotifier<double?> {
  CustomCalorieTargetController(this._prefs)
      : super(double.tryParse(_prefs.getString(_key) ?? ''));

  final LocalPreferences _prefs;
  static const _key = 'nutrivoya.customCalorieTarget';

  Future<void> set(double? kcal) async {
    state = kcal;
    if (kcal == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, kcal.toString());
    }
  }
}

final customCalorieTargetProvider =
    StateNotifierProvider<CustomCalorieTargetController, double?>(
  (ref) => CustomCalorieTargetController(ref.watch(localPreferencesSyncProvider)),
);

/// Energy estimate for the current profile, or `null` without a valid profile.
final energyEstimateProvider = Provider<EnergyEstimate?>((ref) {
  final profile = ref.watch(profileControllerProvider);
  if (profile == null || !profile.isPlausible) return null;
  return ref.watch(energyRequirementServiceProvider).estimate(profile);
});

/// Daily targets: calculated, or derived from the custom calorie target.
final nutritionTargetsProvider = Provider<NutritionTargets>((ref) {
  final profile = ref.watch(profileControllerProvider);
  final estimate = ref.watch(energyEstimateProvider);
  if (profile == null || estimate == null) return const NutritionTargets();
  final custom = ref.watch(customCalorieTargetProvider);
  return ref
      .watch(macroTargetServiceProvider)
      .targets(profile, custom ?? estimate.targetKcal);
});
