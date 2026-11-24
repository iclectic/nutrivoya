import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/diary_database.dart';
import '../../core/storage/local_preferences.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_repository.dart';
import '../diary/diary_providers.dart';

/// Deletes a signed-in account, then the on-device copy of user data.
///
/// Remote deletion runs first. If it fails, local data is left in place so
/// the person can retry. Theme and language preferences are kept.
class AccountDeletionService {
  AccountDeletionService({
    required AuthRepository auth,
    required LocalPreferences prefs,
    required DiaryDatabase database,
  })  : _auth = auth,
        _prefs = prefs,
        _database = database;

  final AuthRepository _auth;
  final LocalPreferences _prefs;
  final DiaryDatabase _database;

  Future<void> deleteAccount({required bool hasRemoteAccount}) async {
    if (hasRemoteAccount) {
      await _auth.deleteRemoteAccount();
    }
    await _database.clearUserData();
    await _prefs.clearUserData();
  }
}

final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  return AccountDeletionService(
    auth: ref.watch(authRepositoryProvider),
    prefs: ref.watch(localPreferencesSyncProvider),
    database: ref.watch(diaryDatabaseProvider),
  );
});
