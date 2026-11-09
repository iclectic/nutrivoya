import '../models/food.dart';
import '../models/food_portion.dart';
import '../models/photo_recognition.dart';

/// Suggests a starting portion for a confirmed food after photo matching.
///
/// Estimates are never certain — the user must confirm before logging.
/// Calories still come from structured per-100 g data × confirmed grams.
class PortionEstimationService {
  const PortionEstimationService();

  /// Prefer a medium cultural portion, else default serving, else 100 g.
  PortionEstimate estimate(Food food, {PortionSizeClass? prefer}) {
    final portions = food.portions;
    FoodPortion? chosen;
    if (portions.isNotEmpty) {
      final preferred = prefer ?? PortionSizeClass.medium;
      for (final p in portions) {
        if (p.sizeClass == preferred) {
          chosen = p;
          break;
        }
      }
      if (chosen == null) {
        for (final p in portions) {
          if (p.sizeClass == PortionSizeClass.medium) {
            chosen = p;
            break;
          }
        }
      }
      chosen ??= portions.first;
    }

    final grams = chosen?.grams ?? food.defaultServingGrams ?? 100;
    return PortionEstimate(
      food: food,
      grams: grams,
      portion: chosen,
      label: chosen?.name ?? '${grams.round()} g',
      isEstimate: true,
    );
  }

  /// Alternate size options for the confirmation UI.
  List<PortionEstimate> options(Food food) {
    if (food.portions.isEmpty) {
      final base = food.defaultServingGrams ?? 100;
      return [
        PortionEstimate(
          food: food,
          grams: base * 0.75,
          label: 'smaller',
          isEstimate: true,
        ),
        PortionEstimate(
          food: food,
          grams: base,
          label: 'default',
          isEstimate: true,
        ),
        PortionEstimate(
          food: food,
          grams: base * 1.25,
          label: 'larger',
          isEstimate: true,
        ),
      ];
    }
    return food.portions
        .map(
          (p) => PortionEstimate(
            food: food,
            grams: p.grams,
            portion: p,
            label: p.name,
            isEstimate: true,
          ),
        )
        .toList();
  }
}
