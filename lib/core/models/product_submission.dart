import 'package:flutter/foundation.dart';

import 'food.dart';
import 'food_name.dart';
import 'food_portion.dart';
import 'food_source.dart';
import 'nutrient.dart';
import 'nutrition_confidence.dart';

/// Lifecycle of a user-contributed food submission.
///
/// Submitted values are never treated as authoritative until reviewed.
enum ProductSubmissionStatus {
  /// Saved locally, not yet marked for personal library use.
  draft,

  /// User submitted; awaiting review (local queue until remote review exists).
  pendingReview,

  /// Accepted into the personal offline library as `userSubmitted`.
  publishedLocally,

  /// Rejected / withdrawn by the user.
  withdrawn,
}

extension ProductSubmissionStatusX on ProductSubmissionStatus {
  String get id => name;

  static ProductSubmissionStatus fromId(String id) {
    return ProductSubmissionStatus.values.firstWhere(
      (e) => e.id == id,
      orElse: () => ProductSubmissionStatus.draft,
    );
  }
}

/// A user-contributed food / packaged product awaiting review.
///
/// Missing nutrition stays null — Nutrivoya never invents values to fill gaps.
@immutable
class ProductSubmission {
  const ProductSubmission({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.status = ProductSubmissionStatus.draft,
    this.brand,
    this.barcode,
    this.cuisine,
    this.defaultServingGrams,
    this.portionName,
    this.energyKcalPer100g,
    this.proteinGPer100g,
    this.carbohydrateGPer100g,
    this.fatGPer100g,
    this.fibreGPer100g,
    this.notes,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductSubmissionStatus status;
  final String? brand;
  final String? barcode;
  final String? cuisine;
  final double? defaultServingGrams;
  final String? portionName;

  /// Optional per-100 g values entered by the user. Null = unavailable.
  final double? energyKcalPer100g;
  final double? proteinGPer100g;
  final double? carbohydrateGPer100g;
  final double? fatGPer100g;
  final double? fibreGPer100g;
  final String? notes;

  bool get hasAnyNutrition =>
      energyKcalPer100g != null ||
      proteinGPer100g != null ||
      carbohydrateGPer100g != null ||
      fatGPer100g != null ||
      fibreGPer100g != null;

  /// Food id used once published into the personal library.
  String get publishedFoodId => 'user:$id';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'status': status.id,
        if (brand != null) 'brand': brand,
        if (barcode != null) 'barcode': barcode,
        if (cuisine != null) 'cuisine': cuisine,
        if (defaultServingGrams != null)
          'defaultServingGrams': defaultServingGrams,
        if (portionName != null) 'portionName': portionName,
        if (energyKcalPer100g != null) 'energyKcalPer100g': energyKcalPer100g,
        if (proteinGPer100g != null) 'proteinGPer100g': proteinGPer100g,
        if (carbohydrateGPer100g != null)
          'carbohydrateGPer100g': carbohydrateGPer100g,
        if (fatGPer100g != null) 'fatGPer100g': fatGPer100g,
        if (fibreGPer100g != null) 'fibreGPer100g': fibreGPer100g,
        if (notes != null) 'notes': notes,
      };

  factory ProductSubmission.fromJson(Map<String, dynamic> json) {
    return ProductSubmission(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: ProductSubmissionStatusX.fromId(
        json['status'] as String? ?? 'draft',
      ),
      brand: json['brand'] as String?,
      barcode: json['barcode'] as String?,
      cuisine: json['cuisine'] as String?,
      defaultServingGrams: (json['defaultServingGrams'] as num?)?.toDouble(),
      portionName: json['portionName'] as String?,
      energyKcalPer100g: (json['energyKcalPer100g'] as num?)?.toDouble(),
      proteinGPer100g: (json['proteinGPer100g'] as num?)?.toDouble(),
      carbohydrateGPer100g: (json['carbohydrateGPer100g'] as num?)?.toDouble(),
      fatGPer100g: (json['fatGPer100g'] as num?)?.toDouble(),
      fibreGPer100g: (json['fibreGPer100g'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  ProductSubmission copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProductSubmissionStatus? status,
    String? brand,
    String? barcode,
    String? cuisine,
    double? defaultServingGrams,
    String? portionName,
    double? energyKcalPer100g,
    double? proteinGPer100g,
    double? carbohydrateGPer100g,
    double? fatGPer100g,
    double? fibreGPer100g,
    String? notes,
  }) {
    return ProductSubmission(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      cuisine: cuisine ?? this.cuisine,
      defaultServingGrams: defaultServingGrams ?? this.defaultServingGrams,
      portionName: portionName ?? this.portionName,
      energyKcalPer100g: energyKcalPer100g ?? this.energyKcalPer100g,
      proteinGPer100g: proteinGPer100g ?? this.proteinGPer100g,
      carbohydrateGPer100g: carbohydrateGPer100g ?? this.carbohydrateGPer100g,
      fatGPer100g: fatGPer100g ?? this.fatGPer100g,
      fibreGPer100g: fibreGPer100g ?? this.fibreGPer100g,
      notes: notes ?? this.notes,
    );
  }

  /// Convert to a [Food] for the personal library. Never invents nutrients.
  Food toFood() {
    final nutrients = <NutrientCode, NutrientAmount>{};
    void put(NutrientCode code, double? amount) {
      if (amount == null) return;
      nutrients[code] = NutrientAmount(code: code, amountPer100g: amount);
    }

    put(NutrientCode.energyKcal, energyKcalPer100g);
    put(NutrientCode.proteinG, proteinGPer100g);
    put(NutrientCode.carbohydrateG, carbohydrateGPer100g);
    put(NutrientCode.fatG, fatGPer100g);
    put(NutrientCode.fibreG, fibreGPer100g);

    final confidence = hasAnyNutrition
        ? NutritionConfidence.estimated
        : NutritionConfidence.unknown;

    final serving = defaultServingGrams ?? 100;
    final portions = <FoodPortion>[
      FoodPortion(
        name: portionName?.trim().isNotEmpty == true
            ? portionName!.trim()
            : '1 serving',
        grams: serving,
        sizeClass: PortionSizeClass.medium,
        source: 'user-submitted',
      ),
    ];

    final display = brand != null && brand!.trim().isNotEmpty
        ? '${brand!.trim()} $name'
        : name;

    return Food(
      id: publishedFoodId,
      canonicalName: display.trim(),
      foodType: FoodType.single,
      cuisine: cuisine,
      defaultServingGrams: serving,
      names: [
        FoodName(
          name: name.trim(),
          languageCode: 'en',
          nameType: NameType.primary,
        ),
        if (brand != null && brand!.trim().isNotEmpty)
          FoodName(
            name: brand!.trim(),
            languageCode: 'en',
            nameType: NameType.alias,
          ),
        if (barcode != null && barcode!.trim().isNotEmpty)
          FoodName(
            name: barcode!.trim(),
            languageCode: 'en',
            nameType: NameType.alias,
          ),
      ],
      portions: portions,
      nutrientsPer100g: nutrients,
      source: FoodSource(
        type: FoodSourceType.userSubmitted,
        name: 'User submitted',
        reference: barcode?.trim().isNotEmpty == true
            ? 'barcode ${barcode!.trim()}'
            : 'submission $id',
        reviewStatus: ReviewStatus.pending,
        confidence: confidence,
        updatedAt: updatedAt,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
