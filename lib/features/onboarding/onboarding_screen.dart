import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/models/activity_level.dart';
import '../../core/models/nutrition_goal.dart';
import '../../core/models/physiological_input.dart';
import '../../core/models/user_profile.dart';
import '../../core/services/energy_requirement_service.dart';
import '../../core/storage/local_preferences.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/profile/profile_controller.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// Multi-step onboarding flow.
///
/// Steps: welcome -> goal -> profile -> cuisines (optional) -> language ->
/// summary. On completion the profile is persisted and onboarding flagged.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _step = 0;
  static const int _totalSteps = 6;

  NutritionGoal? _goal;
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  PhysiologicalInput _physio = PhysiologicalInput.unspecified;
  ActivityLevel _activity = ActivityLevel.sedentary;
  final List<String> _cuisines = [];

  static const _cuisineSuggestions = [
    'Punjabi', 'Nigerian', 'Ghanaian', 'Jamaican', 'Mexican',
    'Japanese', 'Vietnamese', 'Mediterranean', 'Indian', 'East African',
    'Middle Eastern', 'Caribbean', 'South East Asian', 'Ethiopian',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  bool get _profileValid =>
      _ageCtrl.text.isNotEmpty &&
      _heightCtrl.text.isNotEmpty &&
      _weightCtrl.text.isNotEmpty;

  void _next() {
    if (_step < _totalSteps - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      setState(() => _step++);
    } else {
      _complete();
    }
  }

  void _back() {
    if (_step > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      setState(() => _step--);
    }
  }

  Future<void> _complete() async {
    final authState = ref.read(authControllerProvider);
    final userId = authState is Authenticated ? authState.userId : 'local';

    final profile = UserProfile(
      id: userId,
      ageYears: int.tryParse(_ageCtrl.text) ?? 0,
      heightCm: double.tryParse(_heightCtrl.text) ?? 0,
      weightKg: double.tryParse(_weightCtrl.text) ?? 0,
      physiologicalInput: _physio,
      activityLevel: _activity,
      goal: _goal ?? NutritionGoal.trackOnly,
      familiarCuisines: List.unmodifiable(_cuisines),
    );

    await ref.read(profileControllerProvider.notifier).save(profile);
    await ref.read(localPreferencesSyncProvider).setOnboardingComplete(true);
    ref.read(onboardingCompleteProvider.notifier).state = true;
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: _step == 0 ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Text(l10n.commonGetStarted),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / _totalSteps),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _welcomeStep(l10n),
                  _goalStep(l10n),
                  _profileStep(l10n),
                  _cuisineStep(l10n),
                  _languageStep(l10n),
                  _summaryStep(l10n),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_step == _totalSteps - 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _back,
                        child: Text(l10n.commonBack),
                      ),
                    )
                  else ...[
                    if (_step > 0)
                      TextButton(
                        onPressed: _back,
                        child: Text(l10n.commonBack),
                      ),
                    if (_step == 3) // cuisines are optional
                      TextButton(
                        onPressed: _next,
                        child: Text(l10n.commonSkip),
                      ),
                  ],
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: _canProceed ? _next : null,
                      child: Text(
                        _step == _totalSteps - 1
                            ? l10n.commonGetStarted
                            : l10n.commonNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canProceed {
    switch (_step) {
      case 1:
        return _goal != null;
      case 2:
        return _profileValid;
      default:
        return true;
    }
  }

  Widget _welcomeStep(AppLocalizations l10n) {
    return _StepPadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu,
              size: 80, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(l10n.onboardingWelcomeTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(l10n.onboardingWelcomeBody,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _goalStep(AppLocalizations l10n) {
    final goals = NutritionGoal.values;
    return _StepPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onboardingGoalTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          RadioGroup<NutritionGoal>(
            groupValue: _goal,
            onChanged: (v) => setState(() => _goal = v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: goals
                  .map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RadioListTile<NutritionGoal>(
                          value: g,
                          title: Text(_goalLabel(g, l10n)),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
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

  Widget _profileStep(AppLocalizations l10n) {
    return _StepPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onboardingProfileTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(l10n.onboardingProfileSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
          const SizedBox(height: 16),
          TextField(
            controller: _ageCtrl,
            decoration: InputDecoration(labelText: l10n.onboardingAgeLabel),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _heightCtrl,
            decoration:
                InputDecoration(labelText: l10n.onboardingHeightLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightCtrl,
            decoration:
                InputDecoration(labelText: l10n.onboardingWeightLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          Text(l10n.onboardingSexLabel,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(l10n.onboardingSexHelp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
          RadioGroup<PhysiologicalInput>(
            groupValue: _physio,
            onChanged: (v) => setState(() => _physio = v ?? PhysiologicalInput.unspecified),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: PhysiologicalInput.values
                  .map((p) => RadioListTile<PhysiologicalInput>(
                        value: p,
                        title: Text(_physioLabel(p, l10n)),
                        dense: true,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.onboardingActivityLabel,
              style: Theme.of(context).textTheme.titleSmall),
          RadioGroup<ActivityLevel>(
            groupValue: _activity,
            onChanged: (v) => setState(() => _activity = v ?? ActivityLevel.sedentary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ActivityLevel.values
                  .map((a) => RadioListTile<ActivityLevel>(
                        value: a,
                        title: Text(_activityLabel(a, l10n)),
                        dense: true,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
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

  Widget _cuisineStep(AppLocalizations l10n) {
    return _StepPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onboardingCuisineTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(l10n.onboardingCuisineSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cuisineSuggestions.map((c) {
              final selected = _cuisines.contains(c);
              return FilterChip(
                label: Text(c),
                selected: selected,
                onSelected: (sel) => setState(() {
                  if (sel) {
                    _cuisines.add(c);
                  } else {
                    _cuisines.remove(c);
                  }
                }),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _languageStep(AppLocalizations l10n) {
    final current = ref.watch(localeProvider) ?? const Locale('en');
    final options = <(Locale, String)>[
      (const Locale('en'), l10n.settingsLanguageEn),
      (const Locale('fr'), l10n.settingsLanguageFr),
      (const Locale('es'), l10n.settingsLanguageEs),
      (const Locale('hi'), l10n.settingsLanguageHi),
      (const Locale('pa'), l10n.settingsLanguagePa),
      (const Locale('ar'), l10n.settingsLanguageAr),
    ];

    return _StepPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onboardingLanguageTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(l10n.onboardingLanguageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
          const SizedBox(height: 16),
          RadioGroup<String>(
            groupValue: current.languageCode,
            onChanged: (code) {
              if (code != null) {
                ref.read(localeProvider.notifier).set(Locale(code));
              }
            },
            child: Column(
              children: options
                  .map(
                    (opt) => RadioListTile<String>(
                      value: opt.$1.languageCode,
                      title: Text(opt.$2),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryStep(AppLocalizations l10n) {
    final previewProfile = UserProfile(
      id: 'preview',
      ageYears: int.tryParse(_ageCtrl.text) ?? 0,
      heightCm: double.tryParse(_heightCtrl.text) ?? 0,
      weightKg: double.tryParse(_weightCtrl.text) ?? 0,
      physiologicalInput: _physio,
      activityLevel: _activity,
      goal: _goal ?? NutritionGoal.trackOnly,
      familiarCuisines: List.unmodifiable(_cuisines),
    );

    final estimate = previewProfile.isPlausible
        ? const EnergyRequirementService().estimate(previewProfile)
        : null;

    return _StepPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onboardingSummaryTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(l10n.onboardingSummaryBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: estimate == null
                  ? Text(l10n.onboardingSummaryComingSoon)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingSummaryMaintenance(
                            estimate.tdeeKcal.round(),
                          ),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.onboardingSummaryTarget(
                            estimate.calorieTargetKcal?.round() ?? 0,
                          ),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.onboardingSummaryMacros(
                            estimate.targets.proteinTargetG?.round() ?? 0,
                            estimate.targets.carbTargetG?.round() ?? 0,
                            estimate.targets.fatTargetG?.round() ?? 0,
                            estimate.targets.fibreTargetG?.round() ?? 0,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.goalsEstimateDisclaimer,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPadding extends StatelessWidget {
  const _StepPadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
