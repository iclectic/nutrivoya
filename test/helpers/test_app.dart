import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivoya/core/database/diary_database.dart';
import 'package:nutrivoya/core/localization/generated/app_localizations.dart';
import 'package:nutrivoya/core/models/user_profile.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/diary/diary_providers.dart';
import 'package:nutrivoya/features/food/food_providers.dart';
import 'package:nutrivoya/features/food/food_repository.dart';
import 'package:nutrivoya/features/profile/profile_repository.dart';

/// Builds a container with in-memory storage and the local food dataset.
Future<ProviderContainer> testContainer({
  UserProfile? profile,
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = LocalPreferences(await SharedPreferences.getInstance());
  if (profile != null) await ProfileRepository(prefs).save(profile);
  final db = DiaryDatabase.forTesting(NativeDatabase.memory());
  final container = ProviderContainer(
    overrides: [
      localPreferencesSyncProvider.overrideWithValue(prefs),
      foodRepositoryProvider.overrideWithValue(LocalFoodRepository()),
      diaryDatabaseProvider.overrideWithValue(db),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Wraps [child] at `/` with stub routes for common navigation targets.
Widget testApp(
  ProviderContainer container,
  Widget child, {
  Locale locale = const Locale('en'),
  List<RouteBase> extraRoutes = const [],
}) {
  Widget stub(String label) => Scaffold(body: Text(label));
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => child),
      for (final p in ['home', 'diary', 'search', 'goals', 'settings'])
        GoRoute(path: '/$p', builder: (context, state) => stub('stub-$p')),
      ...extraRoutes,
    ],
  );
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    ),
  );
}

Future<void> useTallScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Lets drift stream-cancellation timers fire before the test ends.
Future<void> settleStreams(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
}
