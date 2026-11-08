import '../../../core/models/food.dart';
import '../../../core/models/food_name.dart';
import '../../../core/models/food_portion.dart';
import '../../../core/models/food_source.dart';
import '../../../core/models/nutrient.dart';
import '../../../core/models/nutrition_confidence.dart';
import '../../../core/utils/recipe_nutrition_calculator.dart';

/// Multi-continent extension of the curated dataset (Milestone 5).
///
/// Single foods use USDA FoodData Central (SR Legacy) per-100 g values.
/// Traditional dishes are computed with [RecipeNutritionCalculator] from those
/// ingredients using a documented standard recipe and cooked yield, and are
/// labelled `recipeEstimated` / medium confidence because home recipes vary.
/// Translations and local names are unvalidated until native-speaker review.
class GlobalFoodDataset {
  const GlobalFoodDataset._();

  static const _usda = FoodSource(
    type: FoodSourceType.authoritative,
    name: 'USDA FoodData Central (SR Legacy)',
    reference: 'per 100 g edible portion',
    reviewStatus: ReviewStatus.verified,
    confidence: NutritionConfidence.high,
  );

  static FoodSource _recipe(String reference) => FoodSource(
        type: FoodSourceType.recipeEstimated,
        name: 'Nutrivoya standard recipe',
        reference: reference,
        reviewStatus: ReviewStatus.pending,
        confidence: NutritionConfidence.medium,
      );

  static Map<NutrientCode, NutrientAmount> _n(
    double kcal,
    double protein,
    double carb,
    double fat,
    double fibre,
  ) =>
      {
        for (final e in {
          NutrientCode.energyKcal: kcal,
          NutrientCode.proteinG: protein,
          NutrientCode.carbohydrateG: carb,
          NutrientCode.fatG: fat,
          NutrientCode.fibreG: fibre,
        }.entries)
          e.key: NutrientAmount(code: e.key, amountPer100g: e.value),
      };

  static FoodName _p(String n) =>
      FoodName(name: n, languageCode: 'en', nameType: NameType.primary);
  static FoodName _t(String n, String lang) =>
      FoodName(name: n, languageCode: lang, nameType: NameType.translation);
  static FoodName _a(String n, [String lang = 'en']) =>
      FoodName(name: n, languageCode: lang, nameType: NameType.alias);
  static FoodName _tr(String n, String lang) =>
      FoodName(name: n, languageCode: lang, nameType: NameType.transliteration);

  static Food _single(
    String id,
    String canonical,
    Map<NutrientCode, NutrientAmount> n, {
    required List<FoodName> names,
    List<FoodPortion> portions = const [],
    List<String> countries = const [],
    String? cuisine,
    String? region,
    String? preparation,
    double? serving,
  }) =>
      Food(
        id: id,
        canonicalName: canonical,
        foodType: FoodType.single,
        nutrientsPer100g: n,
        source: _usda,
        names: names,
        portions: portions,
        countries: countries,
        cuisine: cuisine,
        region: region,
        preparationMethod: preparation,
        defaultServingGrams: serving,
        culturalContexts: const ['everyday staple'],
      );

  static final water = _single('water', 'Water', _n(0, 0, 0, 0, 0),
      names: [_p('Water'), _t('eau', 'fr'), _t('agua', 'es'), _t('ماء', 'ar'), _t('पानी', 'hi')]);
  static final vegetableOil = _single(
      'vegetable-oil', 'Vegetable oil', _n(884, 0, 0, 100, 0),
      names: [_p('Vegetable oil'), _a('cooking oil'), _tr('tel', 'hi'), _t('aceite', 'es'), _t('huile', 'fr')],
      portions: const [FoodPortion(name: '1 teaspoon', grams: 4.5), FoodPortion(name: '1 tablespoon', grams: 13.6)]);
  static final onion = _single('onion-raw', 'Onion, raw', _n(40, 1.1, 9.34, 0.1, 1.7),
      names: [_p('Onion'), _tr('pyaz', 'hi'), _t('प्याज़', 'hi'), _t('cebolla', 'es'), _t('oignon', 'fr'), _t('بصل', 'ar')],
      portions: const [FoodPortion(name: '1 medium onion', grams: 110)]);
  static final tomato = _single('tomato-raw', 'Tomato, raw', _n(18, 0.88, 3.89, 0.2, 1.2),
      names: [_p('Tomato'), _tr('tamatar', 'hi'), _t('tomate', 'es'), _t('طماطم', 'ar')],
      portions: const [FoodPortion(name: '1 medium tomato', grams: 123)]);
  static final blackBeans = _single('black-beans-cooked', 'Black beans, cooked (boiled)', _n(132, 8.86, 23.71, 0.54, 8.7),
      names: [_p('Black beans'), _t('frijoles negros', 'es'), _a('feijão preto', 'pt'), _t('haricots noirs', 'fr')],
      countries: const ['MX', 'BR', 'CU', 'GT'], cuisine: 'Latin American', preparation: 'boiled',
      portions: const [FoodPortion(name: '1 cup', grams: 172), FoodPortion(name: '1 ladle', grams: 90)], serving: 172);
  static final kidneyBeans = _single('kidney-beans-cooked', 'Kidney beans, cooked (boiled)', _n(127, 8.67, 22.8, 0.5, 6.4),
      names: [_p('Kidney beans'), _tr('rajma', 'hi'), _t('राजमा', 'hi'), _a('red peas', 'en'), _t('frijoles rojos', 'es')],
      countries: const ['IN', 'JM', 'MX'], preparation: 'boiled',
      portions: const [FoodPortion(name: '1 katori', grams: 150, region: 'South Asia'), FoodPortion(name: '1 cup', grams: 177)], serving: 150);
  static final cornTortilla = _single('corn-tortilla', 'Corn tortilla', _n(218, 5.7, 44.64, 2.85, 6.3),
      names: [_p('Corn tortilla'), _t('tortilla de maíz', 'es'), _a('tortilla')],
      countries: const ['MX', 'GT', 'SV'], cuisine: 'Mexican', region: 'Mesoamerica', preparation: 'griddled',
      portions: const [FoodPortion(name: '1 tortilla', grams: 26)], serving: 52);
  static final avocado = _single('avocado', 'Avocado, raw', _n(160, 2, 8.53, 14.66, 6.7),
      names: [_p('Avocado'), _t('aguacate', 'es'), _a('palta', 'es'), _t('avocat', 'fr'), _a('pear', 'en')],
      countries: const ['MX', 'PE', 'KE', 'JM'],
      portions: const [FoodPortion(name: '½ avocado', grams: 68)], serving: 68);
  static final plantain = _single('plantain-boiled', 'Plantain, cooked (boiled)', _n(116, 0.79, 31.15, 0.18, 2.3),
      names: [_p('Plantain'), _t('plátano macho', 'es'), _t('banane plantain', 'fr'), _a('ogede', 'yo'), _a('matoke', 'sw')],
      countries: const ['NG', 'GH', 'JM', 'UG', 'CO'], preparation: 'boiled',
      portions: const [FoodPortion(name: '1 medium plantain', grams: 150), FoodPortion(name: '1 cup slices', grams: 154)], serving: 150);
  static final cassava = _single('cassava-raw', 'Cassava, raw', _n(160, 1.36, 38.06, 0.28, 1.8),
      names: [_p('Cassava'), _t('yuca', 'es'), _t('manioc', 'fr'), _a('mogo', 'en'), _a('mihogo', 'sw'), _a('akpu', 'ig')],
      countries: const ['NG', 'GH', 'CD', 'BR', 'TH'],
      portions: const [FoodPortion(name: '1 cup', grams: 206)], serving: 100);
  static final yam = _single('yam-boiled', 'Yam, cooked (boiled)', _n(116, 1.49, 27.48, 0.14, 3.9),
      names: [_p('Yam'), _t('ñame', 'es'), _t('igname', 'fr'), _a('isu', 'yo'), _a('ji', 'ig')],
      countries: const ['NG', 'GH', 'CI', 'JM'], preparation: 'boiled',
      portions: const [FoodPortion(name: '1 slice', grams: 70), FoodPortion(name: '1 cup cubes', grams: 136)], serving: 136);
  static final sweetPotato = _single('sweet-potato-baked', 'Sweet potato, baked in skin', _n(90, 2.01, 20.71, 0.15, 3.3),
      names: [_p('Sweet potato'), _t('camote', 'es'), _a('batata', 'es'), _t('patate douce', 'fr'), _tr('shakarkandi', 'hi')],
      countries: const ['US', 'NG', 'PE', 'JP', 'CN'], preparation: 'baked',
      portions: const [FoodPortion(name: '1 medium', grams: 114)], serving: 114);
  static final okra = _single('okra-boiled', 'Okra, cooked (boiled)', _n(22, 1.87, 4.51, 0.21, 2.5),
      names: [_p('Okra'), _tr('bhindi', 'hi'), _t('भिंडी', 'hi'), _a('ladies\' fingers'), _t('بامية', 'ar'), _tr('bamia', 'ar'), _a('gombo', 'fr')],
      countries: const ['IN', 'NG', 'EG', 'US'], preparation: 'boiled',
      portions: const [FoodPortion(name: '1 cup slices', grams: 160)], serving: 80);
  static final spinach = _single('spinach-raw', 'Spinach, raw', _n(23, 2.86, 3.63, 0.39, 2.2),
      names: [_p('Spinach'), _tr('palak', 'hi'), _t('पालक', 'hi'), _t('espinaca', 'es'), _t('épinards', 'fr'), _t('سبانخ', 'ar')],
      portions: const [FoodPortion(name: '1 cup', grams: 30), FoodPortion(name: '1 handful', grams: 25)], serving: 30);
  static final couscous = _single('couscous-cooked', 'Couscous, cooked', _n(112, 3.79, 23.22, 0.16, 1.4),
      names: [_p('Couscous'), _t('كسكس', 'ar'), _tr('kuskus', 'ar'), _a('seksu', 'ber')],
      countries: const ['MA', 'DZ', 'TN', 'LY'], cuisine: 'North African', region: 'Maghreb', preparation: 'steamed',
      portions: const [FoodPortion(name: '1 cup', grams: 157), FoodPortion(name: '1 plate', grams: 250)], serving: 157);
  static final pita = _single('pita-white', 'Pita bread, white', _n(275, 9.1, 55.7, 1.2, 2.2),
      names: [_p('Pita bread'), _a('pitta'), _t('خبز عربي', 'ar'), _tr('khubz', 'ar')],
      countries: const ['LB', 'SY', 'JO', 'GR', 'TR'], cuisine: 'Middle Eastern',
      portions: const [FoodPortion(name: '1 large pita (6½")', grams: 60), FoodPortion(name: '1 small pita (4")', grams: 28)], serving: 60);
  static final hummus = _single('hummus', 'Hummus (commercial)', _n(166, 7.9, 14.29, 9.6, 6),
      names: [_p('Hummus'), _a('houmous'), _t('حمص بطحينة', 'ar'), _tr('hummus bi tahini', 'ar')],
      countries: const ['LB', 'IL', 'PS', 'SY', 'JO'], cuisine: 'Middle Eastern',
      portions: const [FoodPortion(name: '1 tablespoon', grams: 15), FoodPortion(name: '¼ cup', grams: 62)], serving: 62);
  static final quinoa = _single('quinoa-cooked', 'Quinoa, cooked', _n(120, 4.4, 21.3, 1.92, 2.8),
      names: [_p('Quinoa'), _t('quinua', 'es'), _a('kinwa', 'qu')],
      countries: const ['PE', 'BO', 'EC'], cuisine: 'Andean', region: 'Andes', preparation: 'boiled',
      portions: const [FoodPortion(name: '1 cup', grams: 185)], serving: 185);
  static final teffFlour = _single('teff-uncooked', 'Teff, uncooked', _n(367, 13.3, 73.13, 2.38, 8),
      names: [_p('Teff'), _t('ጤፍ', 'am'), _tr('tef', 'am')],
      countries: const ['ET', 'ER'], cuisine: 'Ethiopian', region: 'Horn of Africa',
      portions: const [FoodPortion(name: '1 cup', grams: 193)]);
  static final millet = _single('millet-cooked', 'Millet, cooked', _n(119, 3.51, 23.67, 1, 1.3),
      names: [_p('Millet'), _tr('bajra', 'hi'), _t('बाजरा', 'hi'), _a('mawele', 'sw'), _a('mil', 'fr')],
      countries: const ['IN', 'NG', 'NE', 'ML'], preparation: 'boiled',
      portions: const [FoodPortion(name: '1 cup', grams: 174)], serving: 174);
  static final cornmeal = _single('cornmeal-whole-grain', 'Cornmeal, whole-grain', _n(362, 8.12, 76.89, 3.59, 7.3),
      names: [_p('Cornmeal'), _a('maize flour'), _a('unga wa mahindi', 'sw'), _a('mealie meal'), _t('harina de maíz', 'es')],
      countries: const ['KE', 'TZ', 'ZA', 'ZM', 'MX'],
      portions: const [FoodPortion(name: '1 cup', grams: 122)]);
  static final chickpeas = _single('chickpeas-boiled-usda', 'Chickpeas (garbanzo), cooked', _n(164, 8.86, 27.42, 2.59, 7.6),
      names: [_p('Chickpeas, cooked'), _t('garbanzos', 'es'), _t('pois chiches', 'fr'), _t('حمص', 'ar'), _tr('kabuli chana', 'hi')],
      preparation: 'boiled');
  static final riceCooked = _single('rice-white-cooked-usda', 'White rice, cooked', _n(130, 2.69, 28.17, 0.28, 0.4),
      names: [_p('White rice (plain)'), _t('arroz', 'es'), _t('riz', 'fr'), _t('أرز', 'ar'), _t('चावल', 'hi'), _t('ਚੌਲ', 'pa')],
      preparation: 'boiled');

  static Food _dish({
    required String id,
    required String canonical,
    required List<FoodName> names,
    required List<RecipeIngredient> recipe,
    required double cookedYield,
    required String reference,
    required List<FoodPortion> portions,
    required String cuisine,
    required String region,
    required List<String> countries,
    required List<String> contexts,
    required String preparation,
    required double serving,
  }) =>
      Food(
        id: id,
        canonicalName: canonical,
        foodType: FoodType.composite,
        nutrientsPer100g: RecipeNutritionCalculator.per100g(recipe, cookedYieldGrams: cookedYield),
        source: _recipe(reference),
        names: names,
        portions: portions,
        cuisine: cuisine,
        region: region,
        countryCode: countries.first,
        countries: countries.skip(1).toList(),
        culturalContexts: contexts,
        preparationMethod: preparation,
        defaultServingGrams: serving,
        ingredients: [for (final r in recipe) '${r.food.canonicalName} ${r.grams.round()} g'],
      );

  static List<Food> dishes() => [
        _dish(
          id: 'ugali',
          canonical: 'Ugali (stiff maize porridge)',
          names: [_p('Ugali'), _a('sima', 'sw'), _a('nshima', 'bem'), _a('sadza', 'sn'), _a('pap', 'af'), _a('posho')],
          recipe: [RecipeIngredient(cornmeal, 250), RecipeIngredient(water, 750)],
          cookedYield: 900,
          reference: '250 g maize meal + 750 g water, cooked yield 900 g',
          portions: const [
            FoodPortion(name: '1 small mound', grams: 150, sizeClass: PortionSizeClass.small, region: 'East Africa'),
            FoodPortion(name: '1 medium mound', grams: 250, sizeClass: PortionSizeClass.medium, region: 'East Africa'),
            FoodPortion(name: '1 hand-rolled ball', grams: 40, region: 'East Africa'),
          ],
          cuisine: 'East African',
          region: 'East Africa',
          countries: const ['KE', 'TZ', 'UG', 'ZM', 'MW', 'ZW'],
          contexts: const ['everyday staple', 'eaten by hand with stew or greens'],
          preparation: 'boiled and stirred',
          serving: 250,
        ),
        _dish(
          id: 'injera',
          canonical: 'Injera (teff flatbread)',
          names: [_p('Injera'), _t('እንጀራ', 'am'), _a('enjera'), _a('taita', 'ti')],
          recipe: [RecipeIngredient(teffFlour, 100), RecipeIngredient(water, 150)],
          cookedYield: 200,
          reference: '100 g teff flour + 150 g water, fermented, cooked yield 200 g',
          portions: const [
            FoodPortion(name: '1 injera (full round)', grams: 140, region: 'Horn of Africa'),
            FoodPortion(name: '½ injera', grams: 70, region: 'Horn of Africa'),
          ],
          cuisine: 'Ethiopian',
          region: 'Horn of Africa',
          countries: const ['ET', 'ER'],
          contexts: const ['everyday staple', 'shared platter base'],
          preparation: 'fermented, griddle-baked',
          serving: 140,
        ),
        _dish(
          id: 'chana-masala',
          canonical: 'Chana masala (spiced chickpea curry)',
          names: [_p('Chana masala'), _t('छोले', 'hi'), _tr('chole', 'hi'), _t('ਛੋਲੇ', 'pa'), _a('chickpea curry')],
          recipe: [
            RecipeIngredient(chickpeas, 240),
            RecipeIngredient(onion, 100),
            RecipeIngredient(tomato, 150),
            RecipeIngredient(vegetableOil, 15),
            RecipeIngredient(water, 100),
          ],
          cookedYield: 550,
          reference: 'chickpeas 240 g, onion 100 g, tomato 150 g, oil 15 g, water 100 g; yield 550 g',
          portions: const [
            FoodPortion(name: '1 katori', grams: 150, region: 'South Asia'),
            FoodPortion(name: '1 ladle', grams: 90, region: 'South Asia'),
            FoodPortion(name: '1 bowl', grams: 250),
          ],
          cuisine: 'Punjabi',
          region: 'Punjab',
          countries: const ['IN', 'PK'],
          contexts: const ['everyday meal', 'street food (chole bhature)'],
          preparation: 'simmered',
          serving: 150,
        ),
        _dish(
          id: 'arroz-con-frijoles',
          canonical: 'Rice and black beans',
          names: [_p('Rice and beans'), _t('arroz con frijoles', 'es'), _a('moros y cristianos', 'es'), _a('gallo pinto', 'es')],
          recipe: [
            RecipeIngredient(riceCooked, 150),
            RecipeIngredient(blackBeans, 100),
            RecipeIngredient(onion, 15),
            RecipeIngredient(vegetableOil, 5),
          ],
          cookedYield: 270,
          reference: 'cooked rice 150 g, black beans 100 g, onion 15 g, oil 5 g',
          portions: const [
            FoodPortion(name: '1 cup', grams: 180),
            FoodPortion(name: '1 plate', grams: 300),
          ],
          cuisine: 'Latin American',
          region: 'Latin America & Caribbean',
          countries: const ['CU', 'CR', 'NI', 'MX', 'PR'],
          contexts: const ['everyday staple'],
          preparation: 'simmered',
          serving: 180,
        ),
      ];

  /// Searchable foods. `chickpeas` and `riceCooked` are recipe ingredients
  /// only; the searchable versions live in [LocalFoodDataset].
  static List<Food> all() => [
        blackBeans, kidneyBeans, cornTortilla, avocado, plantain, cassava, yam,
        sweetPotato, okra, spinach, couscous, pita, hummus, quinoa, teffFlour,
        millet, cornmeal, onion, tomato, vegetableOil, water,
        ...dishes(),
      ];
}
