import 'package:flutter/foundation.dart';

/// One water intake event (ml).
@immutable
class WaterLog {
  const WaterLog({
    this.id,
    required this.amountMl,
    required this.loggedAt,
  });

  final int? id;
  final int amountMl;
  final DateTime loggedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLog &&
          id == other.id &&
          amountMl == other.amountMl &&
          loggedAt == other.loggedAt;

  @override
  int get hashCode => Object.hash(id, amountMl, loggedAt);
}

/// Aggregated water for a calendar day.
@immutable
class DailyWater {
  const DailyWater({
    required this.date,
    this.totalMl = 0,
    this.entryCount = 0,
    this.goalMl = 2000,
  });

  final DateTime date;
  final int totalMl;
  final int entryCount;
  final int goalMl;

  double get progress =>
      goalMl <= 0 ? 0 : (totalMl / goalMl).clamp(0.0, 1.5);

  DailyWater copyWith({
    DateTime? date,
    int? totalMl,
    int? entryCount,
    int? goalMl,
  }) {
    return DailyWater(
      date: date ?? this.date,
      totalMl: totalMl ?? this.totalMl,
      entryCount: entryCount ?? this.entryCount,
      goalMl: goalMl ?? this.goalMl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyWater &&
          date == other.date &&
          totalMl == other.totalMl &&
          entryCount == other.entryCount &&
          goalMl == other.goalMl;

  @override
  int get hashCode => Object.hash(date, totalMl, entryCount, goalMl);
}
