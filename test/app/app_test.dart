import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivoya/app/app.dart';
import 'package:nutrivoya/core/localization/generated/app_localizations.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';

Widget _wrappedApp(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const NutrivoyaApp(),
  );
}

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = LocalPreferences(await SharedPreferences.getInstance());
  return ProviderContainer(
    overrides: [
      localPreferencesSyncProvider.overrideWithValue(prefs),
    ],
  );
}

void main() {
  testWidgets('renders login screen when unauthenticated', (tester) async {
    final container = await _container();
    await tester.pumpWidget(_wrappedApp(container));
    await tester.pumpAndSettle();

    // No Supabase configured -> redirect to /login. The email field label
    // and the sign-in button should be present.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Sign in'), findsWidgets);
    container.dispose();
  });

  testWidgets('AppLocalizations delegate resolves English strings',
      (tester) async {
    final container = await _container();
    await tester.pumpWidget(_wrappedApp(container));
    await tester.pumpAndSettle();

    // Use a context inside the localized widget subtree (a Scaffold).
    final context = tester.element(find.byType(Scaffold).first);
    final l10n = AppLocalizations.of(context);
    expect(l10n.appName, 'Nutrivoya');
    expect(l10n.navDashboard, 'Today');
    container.dispose();
  });

  testWidgets('localization delegates include AppLocalizations', (tester) async {
    final container = await _container();
    await tester.pumpWidget(_wrappedApp(container));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
    expect(
      app.localizationsDelegates,
      contains(AppLocalizations.delegate),
    );
    expect(app.localizationsDelegates,
        contains(GlobalMaterialLocalizations.delegate));
    container.dispose();
  });
}
