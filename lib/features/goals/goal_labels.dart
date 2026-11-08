import 'package:flutter/material.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/models/reproductive_context.dart';
import 'domain/energy_requirement_service.dart';

String targetWarningText(TargetWarning w, AppLocalizations l10n) {
  switch (w) {
    case TargetWarning.rateCapped:
      return l10n.goalsWarningRateCapped;
    case TargetWarning.floorApplied:
      return l10n.goalsWarningFloor;
    case TargetWarning.pregnancyNoDeficit:
      return l10n.goalsWarningPregnancy;
    case TargetWarning.breastfeedingNoDeficit:
      return l10n.goalsWarningBreastfeeding;
    case TargetWarning.underweightNoDeficit:
      return l10n.goalsWarningUnderweight;
    case TargetWarning.minorNoDeficit:
      return l10n.goalsWarningMinor;
    case TargetWarning.neutralEquation:
      return l10n.goalsWarningNeutral;
    case TargetWarning.customTargetVeryLow:
      return l10n.goalsWarningCustomLow;
  }
}

String reproductiveContextLabel(ReproductiveContext c, AppLocalizations l10n) {
  switch (c) {
    case ReproductiveContext.none:
      return l10n.goalsLifeStageNone;
    case ReproductiveContext.pregnant:
      return l10n.goalsLifeStagePregnant;
    case ReproductiveContext.breastfeeding:
      return l10n.goalsLifeStageBreastfeeding;
    case ReproductiveContext.postpartum:
      return l10n.goalsLifeStagePostpartum;
    case ReproductiveContext.perimenopause:
      return l10n.goalsLifeStagePerimenopause;
    case ReproductiveContext.menopause:
      return l10n.goalsLifeStageMenopause;
  }
}

/// Calm, non-alarming notice card for guardrail messages.
class TargetWarningCard extends StatelessWidget {
  const TargetWarningCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: ListTile(
        leading: Icon(Icons.info_outline, color: scheme.onSecondaryContainer),
        title: Text(text,
            style: TextStyle(color: scheme.onSecondaryContainer)),
      ),
    );
  }
}
