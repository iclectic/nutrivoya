import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/database/diary_database.dart';
import 'package:nutrivoya/core/errors/app_error.dart';
import 'package:nutrivoya/core/models/activity_level.dart';
import 'package:nutrivoya/core/models/diary_entry.dart';
import 'package:nutrivoya/core/models/meal_type.dart';
import 'package:nutrivoya/core/models/nutrition_confidence.dart';
import 'package:nutrivoya/core/models/nutrition_goal.dart';
import 'package:nutrivoya/core/models/physiological_input.dart';
import 'package:nutrivoya/core/models/reproductive_context.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/account/account_deletion_service.dart';
import 'package:nutrivoya/features/auth/auth_repository.dart';
import 'package:nutrivoya/features/diary/diary_repository.dart';
import 'package:nutrivoya/features/profile/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuth implements AuthRepository {
  _FakeAuth({this.failRemote = false});

  final bool failRemote;
  int remoteDeletes = 0;

  @override
  Future<void> deleteRemoteAccount() async {
    remoteDeletes++;
    if (failRemote) {
      throw const AuthError('accountDeleteFailed');
    }
  }

  @override
  bool get isConfigured => true;

  @override
  String? get currentUserId => 'user';

  @override
  String? get currentUserEmail => 'a@b.com';

  @override
  Stream<bool> get authStateChanges => const Stream.empty();

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword({required String email}) {
    throw UnimplementedError();
  }
}

UserProfile _profile(ReproductiveContext reproductive) {
  return UserProfile(
    id: 'local',
    ageYears: 30,
    heightCm: 165,
    weightKg: 62,
    physiologicalInput: PhysiologicalInput.female,
    activityLevel: ActivityLevel.moderate,
    goal: NutritionGoal.loseWeight,
    familiarCuisines: const ['Punjabi'],
    reproductiveContext: reproductive,
  );
}

DiaryEntry _entry() {
  return DiaryEntry(
    foodId: 'roti',
    foodName: 'Roti',
    foodCanonicalName: 'Whole wheat flatbread',
    mealType: MealType.breakfast,
    grams: 40,
    caloriesKcal: 120,
    confidence: NutritionConfidence.medium,
    sourceName: 'Nutrivoya curated',
    loggedAt: DateTime(2024, 6, 15, 8),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences raw;
  late LocalPreferences prefs;
  late DiaryDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    raw = await SharedPreferences.getInstance();
    await raw.clear();
    prefs = LocalPreferences(raw);
    db = DiaryDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('profile without reproductive context loads as not applicable', () async {
    await raw.setString(
      'nutrivoya.profile',
      jsonEncode({
        'id': 'local',
        'ageYears': 30,
        'heightCm': 165,
        'weightKg': 62,
        'physiologicalInput': 'female',
        'activityLevel': 'moderate',
        'goal': 'loseWeight',
        'familiarCuisines': <String>['Punjabi'],
      }),
    );
    final profile = ProfileRepository(prefs).get();
    expect(profile, isNotNull);
    expect(profile!.reproductiveContext, ReproductiveContext.none);
  });

  test('reproductive opt-in round-trips in the profile store', () async {
    final repo = ProfileRepository(prefs);
    await repo.save(_profile(ReproductiveContext.pregnant));
    expect(repo.get()!.reproductiveContext, ReproductiveContext.pregnant);
  });

  test('remote failure keeps on-device diary and profile', () async {
    await ProfileRepository(prefs).save(_profile(ReproductiveContext.pregnant));
    await raw.setString('nutrivoya.themeMode', 'dark');
    await DiaryRepository(db).add(_entry());
    final auth = _FakeAuth(failRemote: true);
    final service = AccountDeletionService(
      auth: auth,
      prefs: prefs,
      database: db,
    );

    expect(
      () => service.deleteAccount(hasRemoteAccount: true),
      throwsA(isA<AuthError>()),
    );
    expect(auth.remoteDeletes, 1);
    expect(ProfileRepository(prefs).get(), isNotNull);
    expect(
      await DiaryRepository(db).entriesForDate(DateTime(2024, 6, 15)),
      isNotEmpty,
    );
    expect(raw.getString('nutrivoya.themeMode'), 'dark');
  });

  test('successful deletion clears user data and keeps theme', () async {
    await ProfileRepository(prefs)
        .save(_profile(ReproductiveContext.breastfeeding));
    await raw.setString('nutrivoya.themeMode', 'dark');
    await raw.setString('nutrivoya.locale', 'ar');
    await raw.setString('nutrivoya.recipes.v1', '[]');
    await raw.setBool('nutrivoya.onboardingComplete', true);
    await DiaryRepository(db).add(_entry());
    final auth = _FakeAuth();
    final service = AccountDeletionService(
      auth: auth,
      prefs: prefs,
      database: db,
    );

    await service.deleteAccount(hasRemoteAccount: true);

    expect(auth.remoteDeletes, 1);
    expect(ProfileRepository(prefs).get(), isNull);
    expect(raw.getString('nutrivoya.recipes.v1'), isNull);
    expect(raw.getBool('nutrivoya.onboardingComplete'), isNull);
    expect(raw.getString('nutrivoya.themeMode'), 'dark');
    expect(raw.getString('nutrivoya.locale'), 'ar');
    expect(
      await DiaryRepository(db).entriesForDate(DateTime(2024, 6, 15)),
      isEmpty,
    );
  });

  test('local-only deletion does not call the remote account API', () async {
    await ProfileRepository(prefs).save(_profile(ReproductiveContext.none));
    await DiaryRepository(db).add(_entry());
    final auth = _FakeAuth();
    final service = AccountDeletionService(
      auth: auth,
      prefs: prefs,
      database: db,
    );

    await service.deleteAccount(hasRemoteAccount: false);

    expect(auth.remoteDeletes, 0);
    expect(ProfileRepository(prefs).get(), isNull);
    expect(
      await DiaryRepository(db).entriesForDate(DateTime(2024, 6, 15)),
      isEmpty,
    );
  });
}
