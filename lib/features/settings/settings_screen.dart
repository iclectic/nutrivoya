import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/storage/local_preferences.dart';
import '../../core/storage/theme_controller.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/profile/profile_controller.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// Settings screen — appearance, language, account, about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            _SectionHeader(l10n.settingsAppearance),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(l10n.settingsTheme),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox(),
                onChanged: (m) {
                  if (m != null) ref.read(themeModeProvider.notifier).set(m);
                },
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.settingsThemeSystem),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.settingsThemeLight),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.settingsThemeDark),
                  ),
                ],
              ),
            ),
            _SectionHeader(l10n.settingsLanguage),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.settingsLanguage),
              trailing: DropdownButton<Locale?>(
                value: locale,
                underline: const SizedBox(),
                onChanged: (l) => ref.read(localeProvider.notifier).set(l),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(l10n.settingsLanguageEn),
                  ),
                  DropdownMenuItem(
                    value: const Locale('fr'),
                    child: Text(l10n.settingsLanguageFr),
                  ),
                  DropdownMenuItem(
                    value: const Locale('es'),
                    child: Text(l10n.settingsLanguageEs),
                  ),
                  DropdownMenuItem(
                    value: const Locale('hi'),
                    child: Text(l10n.settingsLanguageHi),
                  ),
                  DropdownMenuItem(
                    value: const Locale('pa'),
                    child: Text(l10n.settingsLanguagePa),
                  ),
                  DropdownMenuItem(
                    value: const Locale('ar'),
                    child: Text(l10n.settingsLanguageAr),
                  ),
                ],
              ),
            ),
            _SectionHeader(l10n.settingsAccount),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.settingsProfile),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.settingsGoals),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/goals'),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(l10n.recipesTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/recipes'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.settingsSignOut),
              onTap: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                await ref.read(profileControllerProvider.notifier).clear();
                await ref
                    .read(localPreferencesSyncProvider)
                    .setOnboardingComplete(false);
                ref.read(onboardingCompleteProvider.notifier).state = false;
                if (context.mounted) context.go('/login');
              },
            ),
            _SectionHeader(l10n.settingsAbout),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsAbout),
              subtitle: Text(l10n.settingsAboutBody),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
