import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

/// Thin wrapper over `SharedPreferences` for persisted user preferences.
///
/// Keeps Riverpod providers free of direct async I/O and centralizes keys.
/// The synchronous provider [localPreferencesSyncProvider] is overridden in
/// `bootstrap.dart` with a ready instance before the app runs.
class LocalPreferences {
  LocalPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _keyThemeMode = 'nutrivoya.themeMode';
  static const _keyLocale = 'nutrivoya.locale';
  static const _keyOnboardingComplete = 'nutrivoya.onboardingComplete';

  // Theme -----------------------------------------------------------------
  ThemeMode getThemeMode() {
    final raw = _prefs.getString(_keyThemeMode);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_keyThemeMode, mode.name);

  // Locale ----------------------------------------------------------------
  Locale? getLocale() {
    final code = _prefs.getString(_keyLocale);
    if (code == null) return null;
    return _parseLocale(code);
  }

  Future<void> setLocale(Locale locale) =>
      _prefs.setString(_keyLocale, locale.toLanguageTag());

  // Onboarding ------------------------------------------------------------
  bool isOnboardingComplete() => _prefs.getBool(_keyOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_keyOnboardingComplete, value);

  // Generic accessors used by repositories --------------------------------
  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  Future<void> remove(String key) => _prefs.remove(key);

  static Locale _parseLocale(String code) {
    final parts = code.split('-');
    if (parts.length == 1) return Locale(parts[0]);
    return Locale(parts[0], parts[1]);
  }

  /// Serializes a list of strings (e.g. familiar cuisines) to JSON.
  static String encodeList(List<String> values) => jsonEncode(values);

  static List<String> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // ignore malformed legacy data
    }
    return const [];
  }
}

/// Synchronous accessor for a ready [LocalPreferences]. Overridden in
/// `bootstrap.dart` with an initialized instance before the app runs.
final localPreferencesSyncProvider = Provider<LocalPreferences>((ref) {
  throw StateError(
    'localPreferencesSyncProvider must be overridden in bootstrap() '
    'with an initialized LocalPreferences instance.',
  );
});

/// List of locales Nutrivoya supports, derived from [AppConfig].
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return AppConfig.supportedLocaleCodes.map(Locale.new).toList();
});
