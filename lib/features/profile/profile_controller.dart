import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_profile.dart';
import '../../core/storage/local_preferences.dart';
import 'profile_repository.dart';

class ProfileController extends StateNotifier<UserProfile?> {
  ProfileController(this._repo) : super(_repo.get());

  final ProfileRepository _repo;

  Future<void> save(UserProfile profile) async {
    await _repo.save(profile);
    state = profile;
  }

  Future<void> clear() async {
    await _repo.clear();
    state = null;
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, UserProfile?>(
  (ref) => ProfileController(ref.watch(profileRepositoryProvider)),
);

/// Whether onboarding has been completed.
final onboardingCompleteProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(localPreferencesSyncProvider);
  return prefs.isOnboardingComplete();
});
