import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/activity_level.dart';
import '../../core/models/nutrition_goal.dart';
import '../../core/models/physiological_input.dart';
import '../../features/profile/profile_controller.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// Profile screen — shows onboarding-captured data (read-only shell in M1).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: profile == null
            ? Center(child: Text(l10n.settingsComingSoon))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _row(l10n.onboardingAgeLabel, '${profile.ageYears}'),
                  _row(l10n.onboardingHeightLabel, '${profile.heightCm} cm'),
                  _row(l10n.onboardingWeightLabel, '${profile.weightKg} kg'),
                  _row(l10n.onboardingSexLabel,
                      _physioLabel(profile.physiologicalInput, l10n)),
                  _row(l10n.onboardingActivityLabel,
                      _activityLabel(profile.activityLevel, l10n)),
                  _row(l10n.profileGoal, _goalLabel(profile.goal, l10n)),
                  if (profile.familiarCuisines.isNotEmpty)
                    _row(l10n.profileCuisines,
                        profile.familiarCuisines.join(', ')),
                ],
              ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value,
          style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  String _physioLabel(PhysiologicalInput p, AppLocalizations l10n) {
    switch (p.l10nKey) {
      case 'onboardingSexFemale':
        return l10n.onboardingSexFemale;
      case 'onboardingSexMale':
        return l10n.onboardingSexMale;
      default:
        return l10n.onboardingSexPreferNotToSay;
    }
  }

  String _activityLabel(ActivityLevel a, AppLocalizations l10n) {
    switch (a.l10nKey) {
      case 'onboardingActivitySedentary':
        return l10n.onboardingActivitySedentary;
      case 'onboardingActivityLight':
        return l10n.onboardingActivityLight;
      case 'onboardingActivityModerate':
        return l10n.onboardingActivityModerate;
      case 'onboardingActivityActive':
        return l10n.onboardingActivityActive;
      default:
        return l10n.onboardingActivityExtra;
    }
  }

  String _goalLabel(NutritionGoal g, AppLocalizations l10n) {
    switch (g.l10nKey) {
      case 'onboardingGoalMaintain':
        return l10n.onboardingGoalMaintain;
      case 'onboardingGoalLose':
        return l10n.onboardingGoalLose;
      case 'onboardingGoalGain':
        return l10n.onboardingGoalGain;
      case 'onboardingGoalBuildMuscle':
        return l10n.onboardingGoalBuildMuscle;
      case 'onboardingGoalImprove':
        return l10n.onboardingGoalImprove;
      default:
        return l10n.onboardingGoalTrack;
    }
  }
}
