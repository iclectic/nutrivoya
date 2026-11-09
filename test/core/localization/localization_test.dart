import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/localization/generated/app_localizations.dart';
import 'package:nutrivoya/core/models/food_name.dart';
import 'package:nutrivoya/features/food/data/local_food_dataset.dart';
import 'package:nutrivoya/features/food/food_search_service.dart';

void main() {
  group('AppLocalizations coverage', () {
    const locales = [
      Locale('en'),
      Locale('fr'),
      Locale('es'),
      Locale('hi'),
      Locale('pa'),
      Locale('ar'),
    ];

    for (final locale in locales) {
      testWidgets('loads $locale without falling back for core strings',
          (tester) async {
        late AppLocalizations l10n;
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(l10n.appName, isNotEmpty);
        expect(l10n.navDashboard, isNotEmpty);
        expect(l10n.authLoginButton, isNotEmpty);
        expect(l10n.dashboardCalories, isNotEmpty);
        expect(l10n.recipesTitle, isNotEmpty);
        expect(l10n.assistantTitle, isNotEmpty);
        expect(l10n.progressTitle, isNotEmpty);
        expect(l10n.templatesTitle, isNotEmpty);
        expect(l10n.photoTitle, isNotEmpty);
        expect(l10n.addProductTitle, isNotEmpty);
        expect(l10n.mySubmissionsTitle, isNotEmpty);
        expect(l10n.goalsEstimateDisclaimer, isNotEmpty);

        // Locale-specific smoke checks — not English fallbacks for key locales.
        if (locale.languageCode == 'fr') {
          expect(l10n.navDashboard, 'Aujourd\'hui');
          expect(l10n.commonSave, 'Enregistrer');
        }
        if (locale.languageCode == 'es') {
          expect(l10n.navDashboard, 'Hoy');
          expect(l10n.commonSave, 'Guardar');
        }
        if (locale.languageCode == 'hi') {
          expect(l10n.navDashboard, 'आज');
        }
        if (locale.languageCode == 'pa') {
          expect(l10n.navDashboard, 'ਅੱਜ');
        }
        if (locale.languageCode == 'ar') {
          expect(l10n.navDashboard, 'اليوم');
          expect(l10n.appName, 'نوتريفويا');
        }
      });
    }
  });

  group('Arabic RTL layout', () {
    testWidgets('MaterialApp resolves RTL text direction for ar',
        (tester) async {
      late TextDirection direction;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              direction = Directionality.of(context);
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context).settingsTitle),
                ),
                body: Text(AppLocalizations.of(context).navDashboard),
              );
            },
          ),
        ),
      );

      expect(direction, TextDirection.rtl);
      expect(find.text('اليوم'), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);
    });

    testWidgets('English remains LTR', (tester) async {
      late TextDirection direction;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              direction = Directionality.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(direction, TextDirection.ltr);
    });
  });

  group('multilingual food search', () {
    const search = FoodSearchService();

    test('finds foods by Devanagari script aliases', () {
      final results = search.search('रोटी', LocalFoodDataset.all());
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'roti-whole-wheat');
    });

    test('finds foods by Arabic script aliases', () {
      final results = search.search('فول', LocalFoodDataset.all());
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'ful-medames');
    });

    test('finds foods by French translation', () {
      final results = search.search('pois chiches', LocalFoodDataset.all());
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'chickpeas-cooked');
    });

    test('finds foods by Punjabi script aliases', () {
      final results = search.search('ਰੋਟੀ', LocalFoodDataset.all());
      expect(results, isNotEmpty);
      expect(results.first.food.id, 'roti-whole-wheat');
    });

    test('folds Latin diacritics in queries', () {
      expect(FoodName.normalize('café'), 'cafe');
      expect(FoodName.normalize('élève'), 'eleve');
      final results = search.search('riz jollof', LocalFoodDataset.all());
      expect(results.first.food.id, 'jollof-rice');
    });

    test('preserves Arabic letters during normalize', () {
      expect(FoodName.normalize('كسكس'), 'كسكس');
    });
  });
}
