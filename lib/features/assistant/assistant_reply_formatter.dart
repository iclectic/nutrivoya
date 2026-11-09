import '../../core/models/assistant_models.dart';
import '../../core/models/nutrition_confidence.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// Formats a structured [AssistantAnswer] into localized UI copy.
class AssistantReplyFormatter {
  const AssistantReplyFormatter(this.l10n);

  final AppLocalizations l10n;

  String headline(AssistantAnswer answer) {
    switch (answer.intent) {
      case AssistantIntent.culturalStapleOk:
        return l10n.assistantHeadlineCultural(
          _str(answer, 'staple'),
        );
      case AssistantIntent.mealBalance:
        return l10n.assistantHeadlineBalance;
      case AssistantIntent.raiseProtein:
        return l10n.assistantHeadlineProtein;
      case AssistantIntent.hunger:
        return l10n.assistantHeadlineHunger;
      case AssistantIntent.calorieLookup:
        if (answer.facts.containsKey('kcal')) {
          return l10n.assistantHeadlineLookupFound(
            _str(answer, 'foodName'),
          );
        }
        return l10n.assistantHeadlineLookupMissing(
          _str(answer, 'foodName'),
        );
      case AssistantIntent.foodSubstitute:
        return l10n.assistantHeadlineSubstitute;
      case AssistantIntent.medicalRedirect:
        return l10n.assistantHeadlineMedical;
      case AssistantIntent.unknown:
        return l10n.assistantHeadlineUnknown;
    }
  }

  String body(AssistantAnswer answer) {
    switch (answer.intent) {
      case AssistantIntent.culturalStapleOk:
        final hasKcal = answer.facts['kcal'] != null;
        if (hasKcal) {
          return l10n.assistantBodyCulturalWithData(
            _str(answer, 'staple'),
            _str(answer, 'foodName'),
            _str(answer, 'portionName'),
            _int(answer, 'kcal'),
            _str(answer, 'sourceName'),
          );
        }
        return l10n.assistantBodyCultural(
          _str(answer, 'staple'),
          _str(answer, 'cuisine'),
        );
      case AssistantIntent.mealBalance:
        if (answer.facts['calorieTarget'] != null) {
          return l10n.assistantBodyBalanceWithTargets(
            _int(answer, 'caloriesConsumed'),
            _int(answer, 'calorieTarget'),
            _int(answer, 'proteinConsumed'),
            _int(answer, 'proteinTarget'),
            _int(answer, 'entryCount'),
          );
        }
        return l10n.assistantBodyBalanceNoTargets(
          _int(answer, 'caloriesConsumed'),
          _int(answer, 'proteinConsumed'),
          _int(answer, 'entryCount'),
        );
      case AssistantIntent.raiseProtein:
        if (answer.facts['proteinTarget'] != null) {
          return l10n.assistantBodyProteinWithTargets(
            _int(answer, 'proteinConsumed'),
            _int(answer, 'proteinTarget'),
            _int(answer, 'proteinGap'),
            _str(answer, 'cuisine'),
          );
        }
        return l10n.assistantBodyProtein(
          _int(answer, 'proteinConsumed'),
          _str(answer, 'cuisine'),
        );
      case AssistantIntent.hunger:
        if (answer.facts['calorieTarget'] != null) {
          return l10n.assistantBodyHungerWithTargets(
            _int(answer, 'caloriesConsumed'),
            _int(answer, 'calorieTarget'),
            _int(answer, 'proteinConsumed'),
            _int(answer, 'fibreConsumed'),
          );
        }
        return l10n.assistantBodyHunger(
          _int(answer, 'caloriesConsumed'),
          _int(answer, 'proteinConsumed'),
          _int(answer, 'fibreConsumed'),
        );
      case AssistantIntent.calorieLookup:
        if (answer.facts['kcal'] != null) {
          return l10n.assistantBodyLookupFound(
            _str(answer, 'foodName'),
            _str(answer, 'portionName'),
            _int(answer, 'kcal'),
            _int(answer, 'proteinG'),
            _str(answer, 'sourceName'),
            _confidenceLabel(_str(answer, 'confidence')),
          );
        }
        if (answer.facts['sourceName'] != null) {
          return l10n.assistantBodyLookupNoNutrition(
            _str(answer, 'foodName'),
            _str(answer, 'sourceName'),
          );
        }
        return l10n.assistantBodyLookupMissing(_str(answer, 'foodName'));
      case AssistantIntent.foodSubstitute:
        return l10n.assistantBodySubstitute;
      case AssistantIntent.medicalRedirect:
        return l10n.assistantBodyMedical;
      case AssistantIntent.unknown:
        return l10n.assistantBodyUnknown;
    }
  }

  List<String> tips(AssistantAnswer answer) {
    return answer.tipKeys.map(_tipText).where((t) => t.isNotEmpty).toList();
  }

  String _tipText(String key) {
    switch (key) {
      case 'assistantTipAskRice':
        return l10n.assistantTipAskRice;
      case 'assistantTipAskBalance':
        return l10n.assistantTipAskBalance;
      case 'assistantTipAskProtein':
        return l10n.assistantTipAskProtein;
      case 'assistantTipAskFoodLookup':
        return l10n.assistantTipAskFoodLookup;
      case 'assistantTipSeekProfessional':
        return l10n.assistantTipSeekProfessional;
      case 'assistantTipFoodNotFound':
        return l10n.assistantTipFoodNotFound;
      case 'assistantTipNutritionUnavailable':
        return l10n.assistantTipNutritionUnavailable;
      case 'assistantTipVerifyPortion':
        return l10n.assistantTipVerifyPortion;
      case 'assistantTipNoMoralFood':
        return l10n.assistantTipNoMoralFood;
      case 'assistantTipHungerProteinFibre':
        return l10n.assistantTipHungerProteinFibre;
      case 'assistantTipHungerPace':
        return l10n.assistantTipHungerPace;
      case 'assistantTipProteinPairDal':
        return l10n.assistantTipProteinPairDal;
      case 'assistantTipProteinPairYoghurt':
        return l10n.assistantTipProteinPairYoghurt;
      case 'assistantTipProteinPairEgg':
        return l10n.assistantTipProteinPairEgg;
      case 'assistantTipModifyNotReplace':
        return l10n.assistantTipModifyNotReplace;
      case 'assistantTipModifyPortion':
        return l10n.assistantTipModifyPortion;
      case 'assistantTipAddVegetables':
        return l10n.assistantTipAddVegetables;
      case 'assistantTipAddProteinSide':
        return l10n.assistantTipAddProteinSide;
      case 'assistantTipLogSomething':
        return l10n.assistantTipLogSomething;
      default:
        return '';
    }
  }

  String _confidenceLabel(String raw) {
    switch (raw) {
      case 'high':
        return l10n.confidenceHigh;
      case 'medium':
        return l10n.confidenceMedium;
      case 'estimated':
        return l10n.confidenceEstimated;
      default:
        return l10n.confidenceUnknown;
    }
  }

  String confidenceNote(NutritionConfidence? c) {
    if (c == null) return '';
    switch (c) {
      case NutritionConfidence.high:
        return l10n.confidenceHighNote;
      case NutritionConfidence.medium:
        return l10n.confidenceMediumNote;
      case NutritionConfidence.estimated:
        return l10n.confidenceEstimatedNote;
      case NutritionConfidence.unknown:
        return l10n.confidenceUnknown;
    }
  }

  String _str(AssistantAnswer a, String key) =>
      a.facts[key]?.toString() ?? '';

  int _int(AssistantAnswer a, String key) {
    final v = a.facts[key];
    if (v is int) return v;
    if (v is num) return v.round();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
