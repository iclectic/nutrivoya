import '../../../core/models/food.dart';
import '../../../core/models/food_name.dart';
import '../../../core/models/food_portion.dart';
import '../../../core/models/food_source.dart';
import '../../../core/models/nutrient.dart';
import '../../../core/models/nutrition_confidence.dart';

/// Tier 3 — Nutrivoya's curated cultural-food dataset seed.
///
/// Values are real, attributed reference values. High-confidence entries use
/// USDA FoodData Central per-100g values for common foods. Cultural composite
/// dishes are clearly marked `estimated`/`medium` with recipe-based notes —
/// Nutrivoya never fabricates precision.
///
/// This is a small offline seed so the app is functional without network.
/// It is NOT exhaustive; the full Cultural Food Intelligence dataset is
/// Milestone 5, and the USDA adapter (Tier 1) provides the authoritative
/// connection to a trusted structured dataset.
class LocalFoodDataset {
  const LocalFoodDataset._();

  static const _usda = FoodSource(
    type: FoodSourceType.authoritative,
    name: 'USDA FoodData Central',
    reference: 'per 100 g edible portion',
    reviewStatus: ReviewStatus.verified,
    confidence: NutritionConfidence.high,
  );

  static const _nutrivoyaEstimated = FoodSource(
    type: FoodSourceType.nutrivoyaCurated,
    name: 'Nutrivoya curated',
    reference: 'recipe-based estimate; preparation varies',
    reviewStatus: ReviewStatus.pending,
    confidence: NutritionConfidence.estimated,
  );

  static const _nutrivoyaMedium = FoodSource(
    type: FoodSourceType.nutrivoyaCurated,
    name: 'Nutrivoya curated',
    reference: 'standardized recipe estimate',
    reviewStatus: ReviewStatus.pending,
    confidence: NutritionConfidence.medium,
  );

  static Map<NutrientCode, NutrientAmount> _n(
    double? kcal,
    double? protein,
    double? carb,
    double? fat,
    double? fibre, {
    double? satFat,
    double? sugar,
    double? sodiumMg,
    double? ironMg,
    double? calciumMg,
    double? potassiumMg,
    double? vitaminCMg,
  }) {
    return {
      NutrientCode.energyKcal: NutrientAmount(code: NutrientCode.energyKcal, amountPer100g: kcal),
      NutrientCode.proteinG: NutrientAmount(code: NutrientCode.proteinG, amountPer100g: protein),
      NutrientCode.carbohydrateG: NutrientAmount(code: NutrientCode.carbohydrateG, amountPer100g: carb),
      NutrientCode.fatG: NutrientAmount(code: NutrientCode.fatG, amountPer100g: fat),
      NutrientCode.fibreG: NutrientAmount(code: NutrientCode.fibreG, amountPer100g: fibre),
      if (satFat != null)
        NutrientCode.saturatedFatG: NutrientAmount(code: NutrientCode.saturatedFatG, amountPer100g: satFat),
      if (sugar != null)
        NutrientCode.sugarG: NutrientAmount(code: NutrientCode.sugarG, amountPer100g: sugar),
      if (sodiumMg != null)
        NutrientCode.sodiumMg: NutrientAmount(code: NutrientCode.sodiumMg, amountPer100g: sodiumMg),
      if (ironMg != null)
        NutrientCode.ironMg: NutrientAmount(code: NutrientCode.ironMg, amountPer100g: ironMg),
      if (calciumMg != null)
        NutrientCode.calciumMg: NutrientAmount(code: NutrientCode.calciumMg, amountPer100g: calciumMg),
      if (potassiumMg != null)
        NutrientCode.potassiumMg: NutrientAmount(code: NutrientCode.potassiumMg, amountPer100g: potassiumMg),
      if (vitaminCMg != null)
        NutrientCode.vitaminCMg: NutrientAmount(code: NutrientCode.vitaminCMg, amountPer100g: vitaminCMg),
    };
  }

  static List<Food> all() {
    return [
      // --- High-confidence USDA reference foods ---------------------------
      Food(
        id: 'rice-white-cooked',
        canonicalName: 'White rice, cooked (long grain)',
        foodType: FoodType.single,
        countryCode: 'IN',
        cuisine: 'South Asian',
        defaultServingGrams: 158,
        names: [
          FoodName(name: 'White rice, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'chawal', languageCode: 'hi', nameType: NameType.transliteration),
          FoodName(name: 'cooked rice', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'steamed rice', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small bowl', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium bowl', grams: 158, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large bowl', grams: 220, sizeClass: PortionSizeClass.large),
          FoodPortion(name: '1 katori', grams: 150, region: 'South Asia'),
        ],
        nutrientsPer100g: _n(130, 2.69, 28.17, 0.28, 0.4, sodiumMg: 1, ironMg: 1.2, potassiumMg: 35),
        source: _usda,
      ),
      Food(
        id: 'whole-wheat-flour',
        canonicalName: 'Whole wheat flour',
        foodType: FoodType.single,
        defaultServingGrams: 30,
        names: [
          FoodName(name: 'Whole wheat flour', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'atta', languageCode: 'hi', nameType: NameType.transliteration),
          FoodName(name: 'gehun ka aata', languageCode: 'hi', nameType: NameType.transliteration),
        ],
        portions: const [
          FoodPortion(name: '1 tablespoon', grams: 8),
          FoodPortion(name: '1 cup', grams: 120),
        ],
        nutrientsPer100g: _n(340, 13.2, 71.0, 2.5, 10.7, ironMg: 3.6),
        source: _usda,
      ),
      Food(
        id: 'chicken-breast-cooked',
        canonicalName: 'Chicken breast, cooked (roasted)',
        foodType: FoodType.single,
        defaultServingGrams: 120,
        names: [
          FoodName(name: 'Chicken breast, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'grilled chicken', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'chicken', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small fillet', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium fillet', grams: 170, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large fillet', grams: 220, sizeClass: PortionSizeClass.large),
        ],
        nutrientsPer100g: _n(165, 31.0, 0, 3.6, 0, sodiumMg: 74, potassiumMg: 256),
        source: _usda,
      ),
      Food(
        id: 'oats-rolled-dry',
        canonicalName: 'Rolled oats (dry)',
        foodType: FoodType.single,
        defaultServingGrams: 40,
        names: [
          FoodName(name: 'Rolled oats', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'oatmeal', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'oats', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'jai', languageCode: 'hi', nameType: NameType.transliteration),
        ],
        portions: const [
          FoodPortion(name: '1 tablespoon', grams: 7),
          FoodPortion(name: '1/2 cup', grams: 40),
          FoodPortion(name: '1 cup', grams: 80),
        ],
        nutrientsPer100g: _n(379, 13.2, 67.0, 6.5, 10.1, ironMg: 4.3),
        source: _usda,
      ),
      Food(
        id: 'egg-whole-cooked',
        canonicalName: 'Egg, whole, cooked',
        foodType: FoodType.single,
        defaultServingGrams: 50,
        names: [
          FoodName(name: 'Egg, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'boiled egg', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'anda', languageCode: 'hi', nameType: NameType.transliteration),
        ],
        portions: const [
          FoodPortion(name: '1 small egg', grams: 44, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium egg', grams: 50, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large egg', grams: 57, sizeClass: PortionSizeClass.large),
        ],
        nutrientsPer100g: _n(155, 12.6, 1.1, 10.6, 0, sodiumMg: 124, calciumMg: 50),
        source: _usda,
      ),
      Food(
        id: 'banana',
        canonicalName: 'Banana, raw',
        foodType: FoodType.single,
        defaultServingGrams: 118,
        names: [
          FoodName(name: 'Banana', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'kela', languageCode: 'hi', nameType: NameType.transliteration),
        ],
        portions: const [
          FoodPortion(name: '1 small banana', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium banana', grams: 118, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large banana', grams: 136, sizeClass: PortionSizeClass.large),
        ],
        nutrientsPer100g: _n(89, 1.09, 22.84, 0.33, 2.6, potassiumMg: 358),
        source: _usda,
      ),
      Food(
        id: 'mango',
        canonicalName: 'Mango, raw',
        foodType: FoodType.single,
        defaultServingGrams: 165,
        names: [
          FoodName(name: 'Mango', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'aam', languageCode: 'hi', nameType: NameType.transliteration),
        ],
        portions: const [
          FoodPortion(name: '1 small mango', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium mango', grams: 165, sizeClass: PortionSizeClass.medium),
        ],
        nutrientsPer100g: _n(60, 0.82, 14.99, 0.38, 1.6, vitaminCMg: 36.4),
        source: _usda,
      ),
      Food(
        id: 'lentils-cooked',
        canonicalName: 'Lentils, cooked (boiled)',
        foodType: FoodType.single,
        cuisine: 'South Asian',
        defaultServingGrams: 198,
        names: [
          FoodName(name: 'Lentils, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'dal', languageCode: 'hi', nameType: NameType.transliteration),
          FoodName(name: 'dhal', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'masoor dal', languageCode: 'hi', nameType: NameType.regional),
        ],
        portions: const [
          FoodPortion(name: '1 small bowl', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium bowl', grams: 198, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 katori', grams: 150, region: 'South Asia'),
        ],
        nutrientsPer100g: _n(116, 9.02, 20.13, 0.38, 7.9, ironMg: 3.3, potassiumMg: 369),
        source: _usda,
      ),
      Food(
        id: 'chickpeas-cooked',
        canonicalName: 'Chickpeas, cooked',
        foodType: FoodType.single,
        cuisine: 'South Asian',
        defaultServingGrams: 164,
        names: [
          FoodName(name: 'Chickpeas, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'chana', languageCode: 'hi', nameType: NameType.transliteration),
          FoodName(name: 'garbanzo beans', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'ceci', languageCode: 'it', nameType: NameType.alias),
          FoodName(name: 'pois chiches', languageCode: 'fr', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small bowl', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium bowl', grams: 164, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 katori', grams: 150, region: 'South Asia'),
        ],
        nutrientsPer100g: _n(164, 8.86, 27.42, 2.59, 7.6, ironMg: 2.9, potassiumMg: 291),
        source: _usda,
      ),

      // --- Cultural composite dishes (estimated/medium) ------------------
      Food(
        id: 'roti-whole-wheat',
        canonicalName: 'Whole wheat flatbread (roti)',
        foodType: FoodType.composite,
        countryCode: 'IN',
        region: 'Punjab',
        cuisine: 'Punjabi',
        defaultServingGrams: 40,
        names: [
          FoodName(name: 'Roti', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'chapati', languageCode: 'hi', nameType: NameType.alias),
          FoodName(name: 'phulka', languageCode: 'hi', nameType: NameType.alias),
          FoodName(name: 'rotli', languageCode: 'gu', nameType: NameType.alias),
          FoodName(name: 'whole wheat flatbread', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 small roti', grams: 25, sizeClass: PortionSizeClass.small, region: 'South Asia'),
          FoodPortion(name: '1 medium roti', grams: 40, sizeClass: PortionSizeClass.medium, region: 'South Asia'),
          FoodPortion(name: '1 large roti', grams: 60, sizeClass: PortionSizeClass.large, region: 'South Asia'),
        ],
        // Recipe-based: whole wheat flour + water, dry-cooked. ~297 kcal/100g.
        nutrientsPer100g: _n(297, 9, 55, 3, 4, ironMg: 2.5),
        source: _nutrivoyaMedium,
      ),
      Food(
        id: 'dal-curried',
        canonicalName: 'Spiced lentil dal (tempered)',
        foodType: FoodType.composite,
        countryCode: 'IN',
        region: 'Punjab',
        cuisine: 'Punjabi',
        defaultServingGrams: 200,
        names: [
          FoodName(name: 'Dal', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'dal tadka', languageCode: 'hi', nameType: NameType.alias),
          FoodName(name: 'tempered lentils', languageCode: 'en', nameType: NameType.translation),
          FoodName(name: 'daal', languageCode: 'hi', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small bowl', grams: 120, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium bowl', grams: 200, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 katori', grams: 150, region: 'South Asia'),
        ],
        // Tempered lentils with oil/ghee + spices. ~118 kcal/100g.
        nutrientsPer100g: _n(118, 6.5, 16, 3.5, 5, satFat: 0.8, sodiumMg: 380),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'jollof-rice',
        canonicalName: 'Jollof rice',
        foodType: FoodType.composite,
        countryCode: 'NG',
        region: 'West Africa',
        cuisine: 'Nigerian',
        defaultServingGrams: 350,
        names: [
          FoodName(name: 'Jollof rice', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'jollof', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'benachin', languageCode: 'wo', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small plate', grams: 200, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium plate', grams: 350, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large plate', grams: 500, sizeClass: PortionSizeClass.large),
        ],
        // Rice + tomato/pepper sauce + oil; recipe varies widely. ~160 kcal/100g.
        nutrientsPer100g: _n(160, 4, 25, 4.5, 1.5, satFat: 0.7, sodiumMg: 300),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'egusi-soup',
        canonicalName: 'Egusi soup',
        foodType: FoodType.composite,
        countryCode: 'NG',
        region: 'West Africa',
        cuisine: 'Nigerian',
        defaultServingGrams: 250,
        names: [
          FoodName(name: 'Egusi soup', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'egusi', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'melon seed soup', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 small bowl', grams: 150, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium bowl', grams: 250, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large bowl', grams: 350, sizeClass: PortionSizeClass.large),
        ],
        // Egusi (melon seeds) + leafy veg + palm oil + protein; energy-dense, varies. ~230 kcal/100g.
        nutrientsPer100g: _n(230, 11, 8, 17, 3, satFat: 7, sodiumMg: 500),
        source: _nutrivoyaEstimated,
      ),
    ];
  }

  static Food? byId(String id) {
    for (final f in all()) {
      if (f.id == id) return f;
    }
    return null;
  }
}
