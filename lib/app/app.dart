import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/generated/app_localizations.dart';
import '../core/localization/locale_controller.dart';
import '../core/storage/theme_controller.dart';
import '../features/diary/sync/diary_sync_service.dart';
import 'router.dart';
import 'theme.dart';

/// Root widget. Wires theme, locale and localization delegates to the router.
class NutrivoyaApp extends ConsumerWidget {
  const NutrivoyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off diary sync when a signed-in Supabase session is available.
    ref.watch(diaryAutoSyncProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Nutrivoya',
      debugShowCheckedModeBanner: false,
      theme: NutrivoyaTheme.light(),
      darkTheme: NutrivoyaTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
