import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_preferences.dart';

/// Persisted app locale. `null` means follow the system locale.
///
/// Relies on [localPreferencesSyncProvider], which is overridden in
/// `bootstrap.dart` with a ready [LocalPreferences] instance before the app
/// runs.
class LocaleController extends StateNotifier<Locale?> {
  LocaleController(this._prefs) : super(_prefs.getLocale());

  final LocalPreferences _prefs;

  void set(Locale? locale) {
    state = locale;
    if (locale == null) {
      _prefs.setLocale(const Locale('en'));
    } else {
      _prefs.setLocale(locale);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleController, Locale?>(
  (ref) => LocaleController(ref.watch(localPreferencesSyncProvider)),
);
