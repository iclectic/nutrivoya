import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/config/app_config.dart';
import 'package:nutrivoya/features/settings/privacy_screen.dart';
import 'package:nutrivoya/shared/extensions/app_localizations_x.dart';

void main() {
  testWidgets('privacy screen states safety, sources, and version', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizationsX.localizationsDelegates,
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
          Locale('es'),
          Locale('hi'),
          Locale('pa'),
          Locale('ar'),
        ],
        locale: const Locale('en'),
        home: const PrivacyScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Privacy and safety'), findsWidgets);
    expect(find.textContaining('does not diagnose'), findsOneWidget);

    final scrollable = find.byType(Scrollable);
    await tester.scrollUntilVisible(
      find.textContaining('does not invent calories'),
      400,
      scrollable: scrollable,
    );
    expect(find.textContaining('does not invent calories'), findsOneWidget);
    expect(find.textContaining('Missing values stay unavailable'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Version ${AppConfig.appVersion}'),
      400,
      scrollable: scrollable,
    );
    expect(find.text('Version ${AppConfig.appVersion}'), findsOneWidget);
  });
}
