import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivoya/core/database/diary_database.dart';
import 'package:nutrivoya/core/localization/generated/app_localizations.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/diary/diary_providers.dart';
import 'package:nutrivoya/features/food/food_providers.dart';
import 'package:nutrivoya/features/food/food_repository.dart';
import 'package:nutrivoya/features/food_details/food_details_screen.dart';

Widget _wrap(ProviderContainer container, Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => child,
      ),
      GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Text('Home'))),
      GoRoute(path: '/diary', builder: (context, state) => const Scaffold(body: Text('Diary'))),
    ],
  );
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      locale: const Locale('en'),
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

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = LocalPreferences(await SharedPreferences.getInstance());
  final db = DiaryDatabase.forTesting(NativeDatabase.memory());
  return ProviderContainer(
    overrides: [
      localPreferencesSyncProvider.overrideWithValue(prefs),
      foodRepositoryProvider.overrideWithValue(LocalFoodRepository()),
      diaryDatabaseProvider.overrideWithValue(db),
    ],
  );
}

void main() {
  Future<void> setLargeScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('food details screen shows name, calories and confidence',
      (tester) async {
    final container = await _container();
    await setLargeScreen(tester);
    await tester.pumpWidget(
      _wrap(container, const FoodDetailsScreen(foodId: 'roti-whole-wheat')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Roti'), findsOneWidget);
    expect(find.textContaining('Estimate confidence'), findsOneWidget);
    expect(find.textContaining('Source'), findsOneWidget);
    expect(find.text('Add to meal'), findsOneWidget);
    container.dispose();
  });

  testWidgets('food details shows no-data message for unknown food',
      (tester) async {
    final container = await _container();
    await tester.pumpWidget(
      _wrap(container, const FoodDetailsScreen(foodId: 'does-not-exist')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nutrition data unavailable'), findsOneWidget);
    container.dispose();
  });

  testWidgets('tapping add to meal opens meal picker', (tester) async {
    final container = await _container();
    await setLargeScreen(tester);
    await tester.pumpWidget(
      _wrap(container, const FoodDetailsScreen(foodId: 'roti-whole-wheat')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to meal'));
    await tester.pumpAndSettle();

    // The meal picker bottom sheet should show meal type options.
    expect(find.text('Add to which meal?'), findsOneWidget);
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    container.dispose();
  });

  testWidgets('selecting a meal logs the entry and shows snackbar',
      (tester) async {
    final container = await _container();
    await setLargeScreen(tester);
    await tester.pumpWidget(
      _wrap(container, const FoodDetailsScreen(foodId: 'roti-whole-wheat')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to meal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Breakfast'));
    await tester.pumpAndSettle();

    // Should show the "added to" snackbar.
    expect(find.textContaining('added to'), findsOneWidget);
    container.dispose();
  });
}
