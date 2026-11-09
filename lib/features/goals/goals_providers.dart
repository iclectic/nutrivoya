import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/energy_requirement.dart';
import '../../core/services/energy_requirement_service.dart';
import '../profile/profile_controller.dart';

/// Singleton domain service — pure calculation, no I/O.
final energyRequirementServiceProvider =
    Provider<EnergyRequirementService>((ref) {
  return const EnergyRequirementService();
});

/// Live energy estimate derived from the current user profile.
///
/// Returns `null` when the profile is missing or not plausible enough to
/// compute a meaningful estimate.
final energyRequirementProvider = Provider<EnergyRequirementResult?>((ref) {
  final profile = ref.watch(profileControllerProvider);
  if (profile == null || !profile.isPlausible) return null;
  return ref.watch(energyRequirementServiceProvider).estimate(profile);
});

/// Convenience: nutrition targets only.
final nutritionTargetsProvider = Provider((ref) {
  return ref.watch(energyRequirementProvider)?.targets;
});
