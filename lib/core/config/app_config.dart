/// Application-wide configuration constants for Nutrivoya.
class AppConfig {
  const AppConfig._();

  /// Supabase project URL. Provide via env (see .env.example).
  /// In production this is injected at build time; for local dev it can be
  /// read from the environment in `bootstrap.dart`.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Supabase anonymous public key.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Whether Supabase credentials have been configured.
  static bool get supabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// App display name.
  static const String appName = 'Nutrivoya';

  /// Supported locale codes (BCP-47-ish). Keep in sync with ARB files.
  static const List<String> supportedLocaleCodes = [
    'en',
    'fr',
    'es',
    'hi',
    'pa',
    'ar',
  ];
}
