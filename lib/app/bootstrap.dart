import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/supabase_bootstrap.dart';
import '../core/storage/local_preferences.dart';

/// Application bootstrap.
///
/// Performs async initialization (Supabase, SharedPreferences) before the app
/// starts, then overrides the synchronous preferences provider so controllers
/// can read it without awaiting.
Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseBootstrap.init();

  final sharedPreferences = await SharedPreferences.getInstance();
  final localPreferences = LocalPreferences(sharedPreferences);

  return ProviderContainer(
    overrides: [
      localPreferencesSyncProvider.overrideWithValue(localPreferences),
    ],
  );
}
