import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/localization/generated/app_localizations.dart';
import 'package:nutrivoya/core/models/assistant_models.dart';
import 'package:nutrivoya/features/assistant/assistant_reply_formatter.dart';

void main() {
  group('AssistantReplyFormatter', () {
    late AppLocalizations l10n;
    late AssistantReplyFormatter formatter;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
      formatter = AssistantReplyFormatter(l10n);
    });

    test('formats calorie lookup with structured facts', () {
      const answer = AssistantAnswer(
        intent: AssistantIntent.calorieLookup,
        facts: {
          'foodName': 'Roti',
          'portionName': '1 medium roti',
          'kcal': 120,
          'proteinG': 4,
          'sourceName': 'Nutrivoya curated',
          'confidence': 'medium',
        },
        tipKeys: ['assistantTipVerifyPortion', 'assistantTipNoMoralFood'],
      );

      expect(formatter.headline(answer), contains('Roti'));
      expect(formatter.body(answer), contains('120'));
      expect(formatter.body(answer), contains('Nutrivoya curated'));
      expect(formatter.tips(answer), hasLength(2));
    });

    test('medical redirect surfaces professional guidance copy', () {
      const answer = AssistantAnswer(
        intent: AssistantIntent.medicalRedirect,
        showMedicalDisclaimer: true,
        tipKeys: ['assistantTipSeekProfessional'],
      );
      expect(formatter.headline(answer), contains('professional'));
      expect(formatter.body(answer), contains('cannot advise'));
      expect(formatter.tips(answer).single, contains('qualified'));
    });

    test('unknown tip keys are dropped', () {
      const answer = AssistantAnswer(
        intent: AssistantIntent.unknown,
        tipKeys: ['assistantTipAskRice', 'notARealTip'],
      );
      final tips = formatter.tips(answer);
      expect(tips, hasLength(1));
      expect(tips.single, isNotEmpty);
    });
  });
}
