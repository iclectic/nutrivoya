import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_preferences.dart';

/// Persisted theme mode (system / light / dark).
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._prefs) : super(_prefs.getThemeMode());

  final LocalPreferences _prefs;

  void set(ThemeMode mode) {
    state = mode;
    _prefs.setThemeMode(mode);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(ref.watch(localPreferencesSyncProvider)),
);
