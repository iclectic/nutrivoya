import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Initializes Supabase if credentials are configured.
///
/// Nutrivoya never hard-codes secrets. Credentials are provided via
/// `--dart-define` (see `.env.example` and README). When absent, the app runs
/// in a limited offline/demo mode so the UI and tests remain functional
/// without a backend.
class SupabaseBootstrap {
  const SupabaseBootstrap._();

  /// Initializes Supabase when [AppConfig.supabaseConfigured] is true.
  /// Returns whether Supabase is available.
  static Future<bool> init() async {
    if (!AppConfig.supabaseConfigured) {
      if (kDebugMode) {
        debugPrint(
          '[Nutrivoya] Supabase credentials not configured. '
          'Running without backend. See .env.example.',
        );
      }
      return false;
    }

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
      debug: kDebugMode,
    );
    return true;
  }

  /// The shared SupabaseClient, or `null` when not configured.
  static SupabaseClient? get client =>
      AppConfig.supabaseConfigured ? Supabase.instance.client : null;
}
