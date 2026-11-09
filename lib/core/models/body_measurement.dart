import 'package:flutter/foundation.dart';

/// Optional body measurements (cm). Logged by date — not used for calorie math.
@immutable
class BodyMeasurement {
  const BodyMeasurement({
    this.id,
    required this.loggedAt,
    this.waistCm,
    this.hipCm,
    this.note,
  });

  final int? id;
  final DateTime loggedAt;
  final double? waistCm;
  final double? hipCm;
  final String? note;

  bool get hasAnyValue => waistCm != null || hipCm != null;

  BodyMeasurement copyWith({
    int? id,
    DateTime? loggedAt,
    double? waistCm,
    double? hipCm,
    String? note,
  }) {
    return BodyMeasurement(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      waistCm: waistCm ?? this.waistCm,
      hipCm: hipCm ?? this.hipCm,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyMeasurement &&
          id == other.id &&
          loggedAt == other.loggedAt &&
          waistCm == other.waistCm &&
          hipCm == other.hipCm &&
          note == other.note;

  @override
  int get hashCode => Object.hash(id, loggedAt, waistCm, hipCm, note);
}
