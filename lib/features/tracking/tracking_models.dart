import 'package:flutter/foundation.dart';

import '../../core/models/meal_type.dart';

@immutable
class WeightEntry {
  const WeightEntry(this.date, this.kg);
  factory WeightEntry.fromJson(Map<String, dynamic> j) =>
      WeightEntry(DateTime.parse(j['date'] as String), (j['kg'] as num).toDouble());
  final DateTime date;
  final double kg;
  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'kg': kg};
}

@immutable
class MeasurementEntry {
  const MeasurementEntry(this.date, {this.waistCm, this.hipCm});
  factory MeasurementEntry.fromJson(Map<String, dynamic> j) => MeasurementEntry(
        DateTime.parse(j['date'] as String),
        waistCm: (j['waistCm'] as num?)?.toDouble(),
        hipCm: (j['hipCm'] as num?)?.toDouble(),
      );
  final DateTime date;
  final double? waistCm;
  final double? hipCm;
  Map<String, dynamic> toJson() =>
      {'date': date.toIso8601String(), 'waistCm': waistCm, 'hipCm': hipCm};
}

@immutable
class TemplateItem {
  const TemplateItem(this.foodId, this.foodName, this.grams);
  factory TemplateItem.fromJson(Map<String, dynamic> j) => TemplateItem(
      j['foodId'] as String, j['foodName'] as String, (j['grams'] as num).toDouble());
  final String foodId;
  final String foodName;
  final double grams;
  Map<String, dynamic> toJson() => {'foodId': foodId, 'foodName': foodName, 'grams': grams};
}

/// A meal the user eats often, re-loggable in one tap.
@immutable
class MealTemplate {
  const MealTemplate({required this.id, required this.name, required this.mealType, required this.items});
  factory MealTemplate.fromJson(Map<String, dynamic> j) => MealTemplate(
        id: j['id'] as String,
        name: j['name'] as String,
        mealType: MealType.values.byName(j['mealType'] as String),
        items: [for (final i in j['items'] as List) TemplateItem.fromJson(i as Map<String, dynamic>)],
      );
  final String id;
  final String name;
  final MealType mealType;
  final List<TemplateItem> items;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mealType': mealType.name,
        'items': [for (final i in items) i.toJson()],
      };
}

class WeightTrend {
  const WeightTrend({required this.recentAverageKg, this.changeKgPerWeek});
  final double recentAverageKg;

  /// Least-squares slope, only when entries span at least a week.
  final double? changeKgPerWeek;
}

/// Smooths day-to-day fluctuation: average of the latest 7 entries and the
/// overall weekly rate of change.
WeightTrend? weightTrend(List<WeightEntry> entries) {
  if (entries.isEmpty) return null;
  final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
  final recent = sorted.length > 7 ? sorted.sublist(sorted.length - 7) : sorted;
  final avg = recent.fold<double>(0, (s, e) => s + e.kg) / recent.length;
  final spanDays = sorted.last.date.difference(sorted.first.date).inHours / 24;
  if (spanDays < 7 || sorted.length < 2) return WeightTrend(recentAverageKg: avg);
  final t0 = sorted.first.date;
  final xs = [for (final e in sorted) e.date.difference(t0).inHours / 24];
  final ys = [for (final e in sorted) e.kg];
  final mx = xs.reduce((a, b) => a + b) / xs.length;
  final my = ys.reduce((a, b) => a + b) / ys.length;
  var num = 0.0, den = 0.0;
  for (var i = 0; i < xs.length; i++) {
    num += (xs[i] - mx) * (ys[i] - my);
    den += (xs[i] - mx) * (xs[i] - mx);
  }
  return WeightTrend(recentAverageKg: avg, changeKgPerWeek: den == 0 ? null : num / den * 7);
}
