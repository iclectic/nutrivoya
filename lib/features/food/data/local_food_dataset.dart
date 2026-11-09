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
          FoodName(name: 'चावल', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਚੌਲ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'أرز', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'riz cuit', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'arroz cocido', languageCode: 'es', nameType: NameType.translation),
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
          FoodName(name: 'केला', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਕੇਲਾ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'موز', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'banane', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'plátano', languageCode: 'es', nameType: NameType.alias),
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
          FoodName(name: 'आम', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਅੰਬ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'مانجو', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'mangue', languageCode: 'fr', nameType: NameType.translation),
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
          FoodName(name: 'चना', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਚਣਾ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'حمص', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'garbanzo beans', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'garbanzos', languageCode: 'es', nameType: NameType.alias),
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
          FoodName(name: 'रोटी', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'चपाती', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਰੋਟੀ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'روٹی', languageCode: 'ur', nameType: NameType.translation),
          FoodName(name: 'خبز هندي', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'rotli', languageCode: 'gu', nameType: NameType.alias),
          FoodName(name: 'whole wheat flatbread', languageCode: 'en', nameType: NameType.translation),
          FoodName(name: 'pain plat complet', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'pan plano integral', languageCode: 'es', nameType: NameType.translation),
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
          FoodName(name: 'दाल', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਦਾਲ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'دال', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'lentilles épicées', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'lentejas especiadas', languageCode: 'es', nameType: NameType.translation),
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
          FoodName(name: 'riz jollof', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'arroz jollof', languageCode: 'es', nameType: NameType.translation),
          FoodName(name: 'أرز جولوف', languageCode: 'ar', nameType: NameType.translation),
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

      // --- Additional staples (USDA-aligned reference values) -------------
      Food(
        id: 'plantain-cooked',
        canonicalName: 'Plantain, cooked',
        foodType: FoodType.single,
        countryCode: 'NG',
        region: 'West Africa',
        cuisine: 'West African',
        defaultServingGrams: 150,
        names: [
          FoodName(name: 'Plantain, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'plantain', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'dodo', languageCode: 'yo', nameType: NameType.alias),
          FoodName(name: 'plátano', languageCode: 'es', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 small plantain', grams: 100, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium plantain', grams: 150, sizeClass: PortionSizeClass.medium),
        ],
        nutrientsPer100g: _n(116, 0.8, 31, 0.2, 2.3, potassiumMg: 465, vitaminCMg: 11),
        source: _usda,
      ),
      Food(
        id: 'cassava-cooked',
        canonicalName: 'Cassava, cooked',
        foodType: FoodType.single,
        countryCode: 'NG',
        cuisine: 'West African',
        defaultServingGrams: 150,
        names: [
          FoodName(name: 'Cassava, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'yuca', languageCode: 'es', nameType: NameType.alias),
          FoodName(name: 'manioc', languageCode: 'fr', nameType: NameType.alias),
          FoodName(name: 'tapioca root', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 cup cubed', grams: 150),
        ],
        nutrientsPer100g: _n(125, 0.8, 30, 0.2, 1.5),
        source: _usda,
      ),
      Food(
        id: 'yogurt-plain',
        canonicalName: 'Yogurt, plain, whole milk',
        foodType: FoodType.single,
        cuisine: 'Global',
        defaultServingGrams: 170,
        names: [
          FoodName(name: 'Yogurt, plain', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'yoghurt', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'dahi', languageCode: 'hi', nameType: NameType.alias),
          FoodName(name: 'दही', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਦਹੀ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'laban', languageCode: 'ar', nameType: NameType.alias),
          FoodName(name: 'لبن', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'زبادي', languageCode: 'ar', nameType: NameType.alias),
          FoodName(name: 'yaourt nature', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'yogur natural', languageCode: 'es', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 small pot', grams: 125, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 cup', grams: 245, sizeClass: PortionSizeClass.medium),
        ],
        nutrientsPer100g: _n(61, 3.5, 4.7, 3.3, 0, sugar: 4.7, calciumMg: 121),
        source: _usda,
      ),
      Food(
        id: 'black-beans-cooked',
        canonicalName: 'Black beans, cooked',
        foodType: FoodType.single,
        countryCode: 'MX',
        cuisine: 'Latin American',
        defaultServingGrams: 130,
        names: [
          FoodName(name: 'Black beans, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'frijoles negros', languageCode: 'es', nameType: NameType.translation),
          FoodName(name: 'feijão preto', languageCode: 'pt', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1/2 cup', grams: 90),
          FoodPortion(name: '1 cup', grams: 180),
        ],
        nutrientsPer100g: _n(132, 8.9, 23.7, 0.5, 8.7, ironMg: 2.1, potassiumMg: 355),
        source: _usda,
      ),
      Food(
        id: 'tofu-firm',
        canonicalName: 'Tofu, firm',
        foodType: FoodType.single,
        countryCode: 'CN',
        cuisine: 'East Asian',
        defaultServingGrams: 100,
        names: [
          FoodName(name: 'Tofu, firm', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'bean curd', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: '豆腐', languageCode: 'zh', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1/4 block', grams: 80),
          FoodPortion(name: '100 g', grams: 100),
        ],
        nutrientsPer100g: _n(144, 17.3, 2.8, 8.7, 2.3, calciumMg: 350),
        source: _usda,
      ),

      // --- Multi-continent cultural dishes (estimated) --------------------
      Food(
        id: 'fufu',
        canonicalName: 'Fufu (cassava/plantain swallow)',
        foodType: FoodType.composite,
        countryCode: 'GH',
        region: 'West Africa',
        cuisine: 'Ghanaian',
        defaultServingGrams: 200,
        names: [
          FoodName(name: 'Fufu', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'foofoo', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'foutou', languageCode: 'fr', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small ball', grams: 120, sizeClass: PortionSizeClass.small, region: 'West Africa'),
          FoodPortion(name: '1 medium ball', grams: 200, sizeClass: PortionSizeClass.medium, region: 'West Africa'),
          FoodPortion(name: '1 large ball', grams: 300, sizeClass: PortionSizeClass.large, region: 'West Africa'),
        ],
        nutrientsPer100g: _n(135, 1, 32, 0.3, 1.5),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'injera',
        canonicalName: 'Injera (teff flatbread)',
        foodType: FoodType.composite,
        countryCode: 'ET',
        region: 'East Africa',
        cuisine: 'Ethiopian',
        defaultServingGrams: 100,
        names: [
          FoodName(name: 'Injera', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'enjera', languageCode: 'am', nameType: NameType.alias),
          FoodName(name: 'teff flatbread', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 piece', grams: 100, region: 'East Africa'),
          FoodPortion(name: '1 large injera', grams: 180, sizeClass: PortionSizeClass.large),
        ],
        nutrientsPer100g: _n(155, 5, 32, 1, 4, ironMg: 3.5),
        source: _nutrivoyaMedium,
      ),
      Food(
        id: 'doro-wat',
        canonicalName: 'Doro wat (Ethiopian chicken stew)',
        foodType: FoodType.composite,
        countryCode: 'ET',
        cuisine: 'Ethiopian',
        defaultServingGrams: 250,
        names: [
          FoodName(name: 'Doro wat', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'doro wot', languageCode: 'am', nameType: NameType.alias),
          FoodName(name: 'Ethiopian chicken stew', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 bowl', grams: 250),
          FoodPortion(name: '1 serving with egg', grams: 300),
        ],
        nutrientsPer100g: _n(165, 14, 6, 9, 1.5, satFat: 2.5, sodiumMg: 420),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'chicken-biryani',
        canonicalName: 'Chicken biryani',
        foodType: FoodType.composite,
        countryCode: 'IN',
        region: 'Hyderabad',
        cuisine: 'South Asian',
        defaultServingGrams: 420,
        names: [
          FoodName(name: 'Chicken biryani', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'biryani', languageCode: 'hi', nameType: NameType.alias),
          FoodName(name: 'बिरयानी', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਬਿਰਿਆਨੀ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'برياني', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'biryani au poulet', languageCode: 'fr', nameType: NameType.translation),
          FoodName(name: 'biryani de pollo', languageCode: 'es', nameType: NameType.translation),
          FoodName(name: 'chicken briyani', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 small plate', grams: 250, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 medium plate', grams: 420, sizeClass: PortionSizeClass.medium),
          FoodPortion(name: '1 large plate', grams: 550, sizeClass: PortionSizeClass.large),
        ],
        nutrientsPer100g: _n(162, 7.6, 22, 5, 1.2, satFat: 1.5, sodiumMg: 350),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'idli',
        canonicalName: 'Idli (steamed rice-lentil cake)',
        foodType: FoodType.composite,
        countryCode: 'IN',
        region: 'South India',
        cuisine: 'South Indian',
        defaultServingGrams: 40,
        names: [
          FoodName(name: 'Idli', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'idly', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'இட்லி', languageCode: 'ta', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 piece', grams: 40),
          FoodPortion(name: '2 pieces', grams: 80),
          FoodPortion(name: '3 pieces', grams: 120),
        ],
        nutrientsPer100g: _n(100, 3.5, 20, 0.5, 1.5),
        source: _nutrivoyaMedium,
      ),
      Food(
        id: 'dosa',
        canonicalName: 'Dosa (fermented rice-lentil crepe)',
        foodType: FoodType.composite,
        countryCode: 'IN',
        region: 'South India',
        cuisine: 'South Indian',
        defaultServingGrams: 80,
        names: [
          FoodName(name: 'Dosa', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'dosai', languageCode: 'ta', nameType: NameType.alias),
          FoodName(name: 'plain dosa', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 plain dosa', grams: 80),
          FoodPortion(name: '1 masala dosa', grams: 180),
        ],
        nutrientsPer100g: _n(168, 4, 28, 4, 1.5),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'pho-bo',
        canonicalName: 'Pho bo (Vietnamese beef noodle soup)',
        foodType: FoodType.composite,
        countryCode: 'VN',
        cuisine: 'Vietnamese',
        defaultServingGrams: 500,
        names: [
          FoodName(name: 'Pho bo', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'pho', languageCode: 'vi', nameType: NameType.alias),
          FoodName(name: 'phở bò', languageCode: 'vi', nameType: NameType.translation),
          FoodName(name: 'Vietnamese beef noodle soup', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 small bowl', grams: 350, sizeClass: PortionSizeClass.small),
          FoodPortion(name: '1 regular bowl', grams: 500, sizeClass: PortionSizeClass.medium),
        ],
        nutrientsPer100g: _n(55, 4, 6.5, 1.2, 0.5, sodiumMg: 320),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'bibimbap',
        canonicalName: 'Bibimbap',
        foodType: FoodType.composite,
        countryCode: 'KR',
        cuisine: 'Korean',
        defaultServingGrams: 450,
        names: [
          FoodName(name: 'Bibimbap', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: '비빔밥', languageCode: 'ko', nameType: NameType.translation),
          FoodName(name: 'mixed rice bowl', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 bowl', grams: 450),
        ],
        nutrientsPer100g: _n(120, 5.5, 17, 3.5, 2, sodiumMg: 380),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'nasi-goreng',
        canonicalName: 'Nasi goreng',
        foodType: FoodType.composite,
        countryCode: 'ID',
        cuisine: 'Indonesian',
        defaultServingGrams: 300,
        names: [
          FoodName(name: 'Nasi goreng', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'Indonesian fried rice', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 plate', grams: 300),
        ],
        nutrientsPer100g: _n(168, 5, 22, 6, 1.2, sodiumMg: 450),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'chicken-adobo',
        canonicalName: 'Chicken adobo',
        foodType: FoodType.composite,
        countryCode: 'PH',
        cuisine: 'Filipino',
        defaultServingGrams: 200,
        names: [
          FoodName(name: 'Chicken adobo', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'adobo', languageCode: 'tl', nameType: NameType.alias),
          FoodName(name: 'adobong manok', languageCode: 'tl', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 serving', grams: 200),
          FoodPortion(name: '1 thigh piece', grams: 120),
        ],
        nutrientsPer100g: _n(180, 18, 3, 10, 0.2, sodiumMg: 600),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'pozole',
        canonicalName: 'Pozole (hominy stew)',
        foodType: FoodType.composite,
        countryCode: 'MX',
        cuisine: 'Mexican',
        defaultServingGrams: 400,
        names: [
          FoodName(name: 'Pozole', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'posole', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'hominy stew', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 bowl', grams: 400),
        ],
        nutrientsPer100g: _n(95, 7, 10, 3, 2, sodiumMg: 400),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'arepas',
        canonicalName: 'Arepa (cornmeal cake)',
        foodType: FoodType.composite,
        countryCode: 'CO',
        cuisine: 'Latin American',
        defaultServingGrams: 80,
        names: [
          FoodName(name: 'Arepa', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'arepas', languageCode: 'es', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 arepa', grams: 80),
          FoodPortion(name: '1 filled arepa', grams: 150),
        ],
        nutrientsPer100g: _n(220, 5, 38, 5, 3),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'callaloo',
        canonicalName: 'Callaloo',
        foodType: FoodType.composite,
        countryCode: 'JM',
        cuisine: 'Caribbean',
        defaultServingGrams: 150,
        names: [
          FoodName(name: 'Callaloo', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'kalalu', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 side serving', grams: 150),
        ],
        nutrientsPer100g: _n(55, 3, 6, 2.5, 3, ironMg: 2.5, vitaminCMg: 20),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'ackee-saltfish',
        canonicalName: 'Ackee and saltfish',
        foodType: FoodType.composite,
        countryCode: 'JM',
        cuisine: 'Jamaican',
        defaultServingGrams: 200,
        names: [
          FoodName(name: 'Ackee and saltfish', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'ackee and salt fish', languageCode: 'en', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '1 serving', grams: 200),
        ],
        nutrientsPer100g: _n(160, 12, 4, 11, 2, satFat: 2, sodiumMg: 700),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'couscous-cooked',
        canonicalName: 'Couscous, cooked',
        foodType: FoodType.single,
        countryCode: 'MA',
        cuisine: 'North African',
        defaultServingGrams: 160,
        names: [
          FoodName(name: 'Couscous, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'couscous', languageCode: 'fr', nameType: NameType.alias),
          FoodName(name: 'كسكس', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'كُسْكُس', languageCode: 'ar', nameType: NameType.alias),
          FoodName(name: 'cuscús', languageCode: 'es', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 cup', grams: 160),
          FoodPortion(name: '1 plate', grams: 250),
        ],
        nutrientsPer100g: _n(112, 3.8, 23, 0.2, 1.4),
        source: _usda,
      ),
      Food(
        id: 'ful-medames',
        canonicalName: 'Ful medames',
        foodType: FoodType.composite,
        countryCode: 'EG',
        cuisine: 'Middle Eastern',
        defaultServingGrams: 200,
        names: [
          FoodName(name: 'Ful medames', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'foul', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'فول مدمس', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'فول', languageCode: 'ar', nameType: NameType.alias),
          FoodName(name: 'foul medames', languageCode: 'fr', nameType: NameType.alias),
          FoodName(name: 'habas estofadas', languageCode: 'es', nameType: NameType.translation),
          FoodName(name: 'fava bean stew', languageCode: 'en', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 bowl', grams: 200),
          FoodPortion(name: '1 sandwich filling', grams: 120),
        ],
        nutrientsPer100g: _n(110, 7, 14, 3.5, 5, ironMg: 2, sodiumMg: 300),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'pierogi',
        canonicalName: 'Pierogi (potato-cheese filled)',
        foodType: FoodType.composite,
        countryCode: 'PL',
        cuisine: 'Eastern European',
        defaultServingGrams: 150,
        names: [
          FoodName(name: 'Pierogi', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'pirogi', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'varenyky', languageCode: 'uk', nameType: NameType.alias),
        ],
        portions: const [
          FoodPortion(name: '3 pieces', grams: 90),
          FoodPortion(name: '6 pieces', grams: 180),
        ],
        nutrientsPer100g: _n(200, 6, 28, 7, 1.5),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'borscht',
        canonicalName: 'Borscht (beet soup)',
        foodType: FoodType.composite,
        countryCode: 'UA',
        cuisine: 'Eastern European',
        defaultServingGrams: 350,
        names: [
          FoodName(name: 'Borscht', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'borsch', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'борщ', languageCode: 'uk', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 bowl', grams: 350),
        ],
        nutrientsPer100g: _n(45, 2, 6, 1.5, 1.5, vitaminCMg: 8),
        source: _nutrivoyaEstimated,
      ),
      Food(
        id: 'aubergine-cooked',
        canonicalName: 'Eggplant, cooked',
        foodType: FoodType.single,
        cuisine: 'Global',
        defaultServingGrams: 100,
        names: [
          FoodName(name: 'Eggplant, cooked', languageCode: 'en', nameType: NameType.primary),
          FoodName(name: 'aubergine', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'brinjal', languageCode: 'en', nameType: NameType.alias),
          FoodName(name: 'baingan', languageCode: 'hi', nameType: NameType.alias),
          FoodName(name: 'बैंगन', languageCode: 'hi', nameType: NameType.translation),
          FoodName(name: 'ਬੈਂਗਣ', languageCode: 'pa', nameType: NameType.translation),
          FoodName(name: 'باذنجان', languageCode: 'ar', nameType: NameType.translation),
          FoodName(name: 'berenjena', languageCode: 'es', nameType: NameType.translation),
        ],
        portions: const [
          FoodPortion(name: '1 cup cubed', grams: 100),
        ],
        nutrientsPer100g: _n(35, 0.8, 8.7, 0.2, 2.5),
        source: _usda,
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
