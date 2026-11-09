import 'package:flutter/foundation.dart';

import 'meal_type.dart';

/// One food line inside a reusable meal template.
@immutable
class MealTemplateItem {
  const MealTemplateItem({
    required this.foodId,
    required this.foodName,
    required this.foodCanonicalName,
    required this.mealType,
    required this.grams,
    this.portionName,
    this.quantity = 1,
    this.caloriesKcal,
    this.proteinG,
    this.carbohydrateG,
    this.fatG,
    this.fibreG,
    this.confidence = 'unknown',
    this.sourceName,
  });

  final String foodId;
  final String foodName;
  final String foodCanonicalName;
  final MealType mealType;
  final double grams;
  final String? portionName;
  final int quantity;
  final double? caloriesKcal;
  final double? proteinG;
  final double? carbohydrateG;
  final double? fatG;
  final double? fibreG;
  final String confidence;
  final String? sourceName;

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'foodName': foodName,
        'foodCanonicalName': foodCanonicalName,
        'mealType': mealType.id,
        'grams': grams,
        if (portionName != null) 'portionName': portionName,
        'quantity': quantity,
        if (caloriesKcal != null) 'caloriesKcal': caloriesKcal,
        if (proteinG != null) 'proteinG': proteinG,
        if (carbohydrateG != null) 'carbohydrateG': carbohydrateG,
        if (fatG != null) 'fatG': fatG,
        if (fibreG != null) 'fibreG': fibreG,
        'confidence': confidence,
        if (sourceName != null) 'sourceName': sourceName,
      };

  factory MealTemplateItem.fromJson(Map<String, dynamic> json) {
    return MealTemplateItem(
      foodId: json['foodId'] as String,
      foodName: json['foodName'] as String,
      foodCanonicalName: json['foodCanonicalName'] as String,
      mealType: MealTypeX.fromId(json['mealType'] as String),
      grams: (json['grams'] as num).toDouble(),
      portionName: json['portionName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      caloriesKcal: (json['caloriesKcal'] as num?)?.toDouble(),
      proteinG: (json['proteinG'] as num?)?.toDouble(),
      carbohydrateG: (json['carbohydrateG'] as num?)?.toDouble(),
      fatG: (json['fatG'] as num?)?.toDouble(),
      fibreG: (json['fibreG'] as num?)?.toDouble(),
      confidence: json['confidence'] as String? ?? 'unknown',
      sourceName: json['sourceName'] as String?,
    );
  }
}

/// Named reusable meal pattern (e.g. "Usual Punjabi breakfast").
@immutable
class MealTemplate {
  const MealTemplate({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final List<MealTemplateItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get itemCount => items.length;

  double? get totalKcal {
    if (items.every((i) => i.caloriesKcal == null)) return null;
    return items.fold<double>(
      0,
      (sum, i) => sum + (i.caloriesKcal ?? 0),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((i) => i.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory MealTemplate.fromJson(Map<String, dynamic> json) {
    return MealTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => MealTemplateItem.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  MealTemplate copyWith({
    String? id,
    String? name,
    List<MealTemplateItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
