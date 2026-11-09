import 'package:flutter/foundation.dart';

/// A food ranked by how often it appears in the diary.
@immutable
class FrequentFood {
  const FrequentFood({
    required this.foodId,
    required this.foodName,
    required this.logCount,
    this.lastLoggedAt,
  });

  final String foodId;
  final String foodName;
  final int logCount;
  final DateTime? lastLoggedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequentFood &&
          foodId == other.foodId &&
          logCount == other.logCount;

  @override
  int get hashCode => Object.hash(foodId, logCount);
}
