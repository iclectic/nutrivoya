import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

/// Supported UI languages with their localized display names.
List<(Locale, String)> languageOptions(AppLocalizations l10n) => [
      (const Locale('en'), l10n.settingsLanguageEn),
      (const Locale('fr'), l10n.settingsLanguageFr),
      (const Locale('es'), l10n.settingsLanguageEs),
      (const Locale('hi'), l10n.settingsLanguageHi),
      (const Locale('pa'), l10n.settingsLanguagePa),
      (const Locale('ar'), l10n.settingsLanguageAr),
    ];
