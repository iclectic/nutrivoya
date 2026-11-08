import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map<String, dynamic>;

Set<String> _placeholders(String s) =>
    RegExp(r'\{(\w+)').allMatches(s).map((m) => m[1]!).toSet();

void main() {
  final en = _arb('en');
  final messageKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
  const core = ['navDashboard', 'navDiary', 'navSearch', 'navSettings', 'dashboardProtein', 'diaryMealBreakfast', 'searchHint', 'commonSave'];

  for (final lang in ['fr', 'es', 'hi', 'pa', 'ar']) {
    group('ARB $lang', () {
      final arb = _arb(lang);
      test('declares its locale and draft status', () {
        expect(arb['@@locale'], lang);
        expect(arb['@@x-translation-status'], isNotNull);
      });
      test('has no keys missing from the template', () {
        final keys = arb.keys.where((k) => !k.startsWith('@')).toSet();
        expect(keys.difference(messageKeys), isEmpty);
      });
      test('preserves placeholders', () {
        for (final k in arb.keys.where((k) => !k.startsWith('@'))) {
          expect(_placeholders(arb[k] as String), _placeholders(en[k] as String), reason: '$lang:$k');
        }
      });
      test('translates core navigation strings', () {
        for (final k in core) {
          expect(arb[k], isNotNull, reason: '$lang:$k');
          expect(arb[k], isNot(en[k]), reason: '$lang:$k');
        }
      });
    });
  }
}
