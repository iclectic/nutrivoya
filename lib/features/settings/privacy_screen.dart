import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// In-app privacy and safety notice for store readiness.
///
/// Explains what stays on device, what can sync, and that nutrition numbers
/// are never invented. Account deletion itself lives in Settings so this
/// screen can be read without a destructive control.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            Text(l10n.privacyIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),
            _Section(title: l10n.privacySafetyTitle, body: l10n.privacySafetyBody),
            _Section(title: l10n.privacyDataTitle, body: l10n.privacyDataBody),
            _Section(
              title: l10n.privacySourcesTitle,
              body: l10n.privacySourcesBody,
            ),
            _Section(title: l10n.privacyPhotosTitle, body: l10n.privacyPhotosBody),
            _Section(title: l10n.privacyDeleteTitle, body: l10n.privacyDeleteBody),
            const SizedBox(height: 8),
            Text(
              l10n.privacyVersion(AppConfig.appVersion),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
