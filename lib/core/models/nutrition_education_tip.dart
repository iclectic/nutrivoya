import 'package:flutter/foundation.dart';

/// Structured nutrition education tip — never invents food-specific kcal.
@immutable
class NutritionEducationTip {
  const NutritionEducationTip({
    required this.id,
    required this.titleKey,
    required this.bodyKey,
    this.cuisineTags = const [],
  });

  final String id;
  final String titleKey;
  final String bodyKey;
  final List<String> cuisineTags;
}

/// Built-in tip library (l10n keys only — no fabricated numbers).
class NutritionEducationLibrary {
  const NutritionEducationLibrary._();

  static const tips = <NutritionEducationTip>[
    NutritionEducationTip(
      id: 'portions-not-ban',
      titleKey: 'educationTipPortionsTitle',
      bodyKey: 'educationTipPortionsBody',
    ),
    NutritionEducationTip(
      id: 'staple-context',
      titleKey: 'educationTipStaplesTitle',
      bodyKey: 'educationTipStaplesBody',
      cuisineTags: ['punjabi', 'nigerian', 'ethiopian', 'vietnamese', 'mexican'],
    ),
    NutritionEducationTip(
      id: 'pair-protein',
      titleKey: 'educationTipPairProteinTitle',
      bodyKey: 'educationTipPairProteinBody',
    ),
    NutritionEducationTip(
      id: 'fibre-familiar',
      titleKey: 'educationTipFibreTitle',
      bodyKey: 'educationTipFibreBody',
    ),
    NutritionEducationTip(
      id: 'missing-data',
      titleKey: 'educationTipMissingDataTitle',
      bodyKey: 'educationTipMissingDataBody',
    ),
    NutritionEducationTip(
      id: 'provenance',
      titleKey: 'educationTipProvenanceTitle',
      bodyKey: 'educationTipProvenanceBody',
    ),
  ];
}
