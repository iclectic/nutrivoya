import 'package:flutter/foundation.dart';

/// A single body-weight log. Trends should prefer averages over day-to-day noise.
@immutable
class WeightEntry {
  const WeightEntry({
    this.id,
    required this.weightKg,
    required this.loggedAt,
    this.note,
  });

  final int? id;
  final double weightKg;
  final DateTime loggedAt;
  final String? note;

  WeightEntry copyWith({
    int? id,
    double? weightKg,
    DateTime? loggedAt,
    String? note,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      loggedAt: loggedAt ?? this.loggedAt,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightEntry &&
          id == other.id &&
          weightKg == other.weightKg &&
          loggedAt == other.loggedAt &&
          note == other.note;

  @override
  int get hashCode => Object.hash(id, weightKg, loggedAt, note);
}

/// Direction of a calm, multi-day weight trend — never a single-day verdict.
enum WeightTrendDirection { rising, falling, steady, insufficientData }

/// Computed weight trend over a window (prefer 7+ entries).
@immutable
class WeightTrend {
  const WeightTrend({
    required this.direction,
    required this.entryCount,
    this.averageKg,
    this.weeklyChangeKg,
    this.latestKg,
  });

  final WeightTrendDirection direction;
  final int entryCount;
  final double? averageKg;
  final double? weeklyChangeKg;
  final double? latestKg;

  bool get hasTrend =>
      direction != WeightTrendDirection.insufficientData &&
      averageKg != null;
}
