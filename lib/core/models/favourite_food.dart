import 'package:flutter/foundation.dart';

/// A user-starred food for quick re-logging (offline, local).
@immutable
class FavouriteFood {
  const FavouriteFood({
    required this.foodId,
    required this.foodName,
    this.foodCanonicalName,
    this.addedAt,
  });

  final String foodId;
  final String foodName;
  final String? foodCanonicalName;
  final DateTime? addedAt;

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'foodName': foodName,
        if (foodCanonicalName != null) 'foodCanonicalName': foodCanonicalName,
        if (addedAt != null) 'addedAt': addedAt!.toIso8601String(),
      };

  factory FavouriteFood.fromJson(Map<String, dynamic> json) {
    return FavouriteFood(
      foodId: json['foodId'] as String,
      foodName: json['foodName'] as String,
      foodCanonicalName: json['foodCanonicalName'] as String?,
      addedAt: json['addedAt'] != null
          ? DateTime.tryParse(json['addedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteFood && foodId == other.foodId;

  @override
  int get hashCode => foodId.hashCode;
}
