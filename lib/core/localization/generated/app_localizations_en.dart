// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nutrivoya';

  @override
  String get appTagline =>
      'Nutrition that works with your food, your culture and your life.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonGetStarted => 'Get started';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonClose => 'Close';

  @override
  String get navDashboard => 'Today';

  @override
  String get navDiary => 'Diary';

  @override
  String get navSearch => 'Search';

  @override
  String get navSettings => 'Settings';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle =>
      'Sign in to continue tracking your nutrition.';

  @override
  String get authSignupTitle => 'Create your account';

  @override
  String get authSignupSubtitle =>
      'Start your culturally intelligent nutrition journey.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authSignupButton => 'Create account';

  @override
  String get authSwitchToSignup => 'Don\'t have an account? Sign up';

  @override
  String get authSwitchToLogin => 'Already have an account? Sign in';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password.';

  @override
  String get authErrorEmailInUse => 'An account already exists for this email.';

  @override
  String get authErrorWeakPassword => 'Please choose a stronger password.';

  @override
  String get authErrorGeneric => 'Authentication failed. Please try again.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Nutrivoya';

  @override
  String get onboardingWelcomeBody =>
      'Nutrition that works with your food, your culture and your life.';

  @override
  String get onboardingGoalTitle =>
      'What would you like Nutrivoya to help with?';

  @override
  String get onboardingGoalMaintain => 'Maintain my weight';

  @override
  String get onboardingGoalLose => 'Lose weight';

  @override
  String get onboardingGoalGain => 'Gain weight';

  @override
  String get onboardingGoalBuildMuscle => 'Build muscle';

  @override
  String get onboardingGoalImprove => 'Improve my nutrition';

  @override
  String get onboardingGoalTrack => 'Just track what I eat';

  @override
  String get onboardingProfileTitle => 'Tell us about you';

  @override
  String get onboardingProfileSubtitle =>
      'We use this only to estimate your nutrition needs. You can change it later.';

  @override
  String get onboardingAgeLabel => 'Age';

  @override
  String get onboardingHeightLabel => 'Height (cm)';

  @override
  String get onboardingWeightLabel => 'Weight (kg)';

  @override
  String get onboardingSexLabel => 'Physiological calculation input';

  @override
  String get onboardingSexFemale => 'Female';

  @override
  String get onboardingSexMale => 'Male';

  @override
  String get onboardingSexPreferNotToSay => 'Prefer not to say';

  @override
  String get onboardingSexHelp =>
      'Used only for energy-requirement equations. This is separate from your gender identity.';

  @override
  String get onboardingActivityLabel => 'Activity level';

  @override
  String get onboardingActivitySedentary => 'Sedentary';

  @override
  String get onboardingActivityLight => 'Lightly active';

  @override
  String get onboardingActivityModerate => 'Moderately active';

  @override
  String get onboardingActivityActive => 'Very active';

  @override
  String get onboardingActivityExtra => 'Extra active';

  @override
  String get onboardingCuisineTitle => 'What foods feel familiar to you?';

  @override
  String get onboardingCuisineSubtitle =>
      'Optional. We use this to prioritize familiar foods in search. You can skip this.';

  @override
  String get onboardingLanguageTitle => 'Choose your language';

  @override
  String get onboardingLanguageSubtitle =>
      'You can change this anytime in settings.';

  @override
  String get onboardingSummaryTitle => 'Your estimated nutrition target';

  @override
  String get onboardingSummaryBody =>
      'This is an estimate based on standard equations. Your actual needs may vary, and we can refine this over time using your weight trend.';

  @override
  String get onboardingSummaryComingSoon =>
      'Personalized calorie and macro targets will be calculated in a later step.';

  @override
  String onboardingSummaryMaintenance(int kcal) {
    return 'Estimated maintenance: $kcal kcal/day';
  }

  @override
  String onboardingSummaryTarget(int kcal) {
    return 'Suggested daily target: $kcal kcal';
  }

  @override
  String onboardingSummaryMacros(int protein, int carbs, int fat, int fibre) {
    return 'Protein $protein g · Carbs $carbs g · Fat $fat g · Fibre $fibre g';
  }

  @override
  String get dashboardGreetingMorning => 'Good morning';

  @override
  String get dashboardGreetingAfternoon => 'Good afternoon';

  @override
  String get dashboardGreetingEvening => 'Good evening';

  @override
  String get dashboardToday => 'Today';

  @override
  String get dashboardCalories => 'Calories';

  @override
  String get dashboardProtein => 'Protein';

  @override
  String get dashboardCarbs => 'Carbohydrates';

  @override
  String get dashboardFat => 'Fat';

  @override
  String get dashboardFibre => 'Fibre';

  @override
  String get dashboardLogFood => 'Log food';

  @override
  String get dashboardEmptyTitle => 'Nothing logged yet';

  @override
  String get dashboardEmptyBody =>
      'Search for a food to start tracking your day.';

  @override
  String get dashboardTargetsPlaceholder =>
      'Targets will be set up after onboarding.';

  @override
  String dashboardCaloriesOf(int consumed, int target) {
    return '$consumed / $target kcal';
  }

  @override
  String dashboardCaloriesRemaining(int kcal) {
    return '$kcal kcal remaining';
  }

  @override
  String dashboardCaloriesOver(int kcal) {
    return '$kcal kcal over target';
  }

  @override
  String get diaryTitle => 'Diary';

  @override
  String get diaryMealBreakfast => 'Breakfast';

  @override
  String get diaryMealLunch => 'Lunch';

  @override
  String get diaryMealDinner => 'Dinner';

  @override
  String get diaryMealSnacks => 'Snacks';

  @override
  String get diaryEmpty => 'No entries yet.';

  @override
  String get diaryAddToMeal => 'Add food';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'What did you eat?';

  @override
  String get searchEmpty =>
      'Search for foods like roti, jollof rice, dal or mango.';

  @override
  String get searchNoResults =>
      'No matching foods found. Try another name, alias or spelling.';

  @override
  String get searchRecent => 'Recent';

  @override
  String get searchFrequent => 'Frequent';

  @override
  String get searchFavourites => 'Favourites';

  @override
  String get searchMyRecipes => 'My recipes';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsLanguageHi => 'हिन्दी';

  @override
  String get settingsLanguagePa => 'ਪੰਜਾਬੀ';

  @override
  String get settingsLanguageAr => 'العربية';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsAbout => 'About Nutrivoya';

  @override
  String get settingsAboutBody =>
      'Nutrivoya is a multilingual, culturally intelligent nutrition and calorie-tracking app that helps people understand and improve the food they actually eat — without telling them that health requires abandoning their culture.';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsGoals => 'Goals';

  @override
  String get settingsComingSoon => 'Coming soon';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGoal => 'Goal';

  @override
  String get profileActivity => 'Activity level';

  @override
  String get profileCuisines => 'Familiar cuisines';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get goalsTitle => 'Nutrition goals';

  @override
  String get goalsNotSet => 'Not set yet';

  @override
  String get goalsCalorieTarget => 'Calorie target';

  @override
  String get goalsProteinTarget => 'Protein target';

  @override
  String get goalsCarbTarget => 'Carbohydrate target';

  @override
  String get goalsFatTarget => 'Fat target';

  @override
  String get goalsFibreTarget => 'Fibre target';

  @override
  String get goalsBmr => 'Estimated BMR';

  @override
  String get goalsTdee => 'Estimated maintenance (TDEE)';

  @override
  String get goalsNeedProfile =>
      'Complete onboarding to see personalized targets.';

  @override
  String get goalsEstimateDisclaimer =>
      'Calculated expenditure is an estimate. Your actual needs may vary.';

  @override
  String get goalsRefineOverTime =>
      'We can refine this estimate over time using your weight trend.';

  @override
  String get energyNoteEstimateDisclaimer =>
      'Calculated expenditure is an estimate. Your actual needs may vary.';

  @override
  String get energyNotePhysiologicalUnspecified =>
      'Without a physiological calculation input, we averaged standard equations. Confidence is lower.';

  @override
  String get energyNoteAgeOutsideAdultRange =>
      'Energy equations are less reliable outside typical adult ages. Consider professional guidance.';

  @override
  String get energyNoteLoseWhileLowWeight =>
      'Your profile suggests a low body weight. Aggressive weight loss is not recommended — please seek qualified support if needed.';

  @override
  String get energyNoteDeficitCapped =>
      'We limited the calorie deficit to a safer rate. Crash dieting is not supported.';

  @override
  String get energyNoteFloorApplied =>
      'Your target was raised to a minimum energy intake for safety.';

  @override
  String get energyNoteTrackOnly =>
      'You chose to track food only. The numbers below are maintenance estimates for reference.';

  @override
  String get confidenceLabel => 'Estimate confidence';

  @override
  String get confidenceHigh => 'High';

  @override
  String get confidenceHighNote => 'Official food-composition data';

  @override
  String get confidenceMedium => 'Medium';

  @override
  String get confidenceMediumNote => 'Calculated from a standardized recipe';

  @override
  String get confidenceEstimated => 'Estimated';

  @override
  String get confidenceEstimatedNote =>
      'Based on common ingredients and portion size';

  @override
  String get confidenceUnknown => 'Unknown';

  @override
  String get sourceLabel => 'Source';

  @override
  String get sourceAuthoritative => 'Authoritative food-composition dataset';

  @override
  String get sourcePackaged => 'Packaged-food database';

  @override
  String get sourceNutrivoyaCurated => 'Nutrivoya curated dataset';

  @override
  String get sourceRecipeEstimated => 'Recipe-based estimate';

  @override
  String get sourceUserSubmitted => 'User-submitted';

  @override
  String get portionLabel => 'Portion';

  @override
  String get portionSmall => 'Small';

  @override
  String get portionMedium => 'Medium';

  @override
  String get portionLarge => 'Large';

  @override
  String get portionGrams => 'Grams';

  @override
  String get portionQuantity => 'Quantity';

  @override
  String get portionCustom => 'Custom grams';

  @override
  String get nutrientEnergyKcal => 'Calories';

  @override
  String get nutrientProteinG => 'Protein';

  @override
  String get nutrientCarbohydrateG => 'Carbohydrates';

  @override
  String get nutrientFatG => 'Fat';

  @override
  String get nutrientFibreG => 'Fibre';

  @override
  String get nutrientSaturatedFatG => 'Saturated fat';

  @override
  String get nutrientSugarG => 'Sugar';

  @override
  String get nutrientSodiumMg => 'Sodium';

  @override
  String get nutrientIronMg => 'Iron';

  @override
  String get nutrientCalciumMg => 'Calcium';

  @override
  String get nutrientPotassiumMg => 'Potassium';

  @override
  String get nutrientMagnesiumMg => 'Magnesium';

  @override
  String get nutrientZincMg => 'Zinc';

  @override
  String get nutrientVitaminAUg => 'Vitamin A';

  @override
  String get nutrientVitaminCMg => 'Vitamin C';

  @override
  String get nutrientVitaminDUg => 'Vitamin D';

  @override
  String get nutrientVitaminB12Ug => 'Vitamin B12';

  @override
  String get nutrientFolateUg => 'Folate';

  @override
  String get foodDetailsTitle => 'Food details';

  @override
  String get foodDetailsAddToMeal => 'Add to meal';

  @override
  String get foodDetailsPerPortion => 'per portion';

  @override
  String get foodDetailsPer100g => 'per 100 g';

  @override
  String get foodDetailsPreparationNote =>
      'Preparation and serving size can change the values.';

  @override
  String get foodDetailsNoData => 'Nutrition data unavailable';

  @override
  String get foodDetailsApprox => '≈';

  @override
  String get foodDetailsLoggingSoon =>
      'Food logging arrives in the next milestone.';

  @override
  String get foodDetailsMacros => 'Macros';

  @override
  String get foodDetailsMicronutrients => 'Micronutrients';

  @override
  String get foodDetailsCuisine => 'Cuisine';

  @override
  String get foodDetailsRegion => 'Region';

  @override
  String get foodDetailsAliases => 'Also known as';

  @override
  String searchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get searchTryExample => 'Try: roti, jollof rice, dal, mango';

  @override
  String get diaryAddToMealTitle => 'Add to which meal?';

  @override
  String diaryEntryAdded(String food, String meal) {
    return '$food added to $meal';
  }

  @override
  String get diaryEntryDeleted => 'Entry deleted';

  @override
  String get diaryEntryUpdated => 'Entry updated';

  @override
  String get diaryEditEntry => 'Edit entry';

  @override
  String get diaryDeleteEntry => 'Delete entry';

  @override
  String get diaryConfirmDelete => 'Remove this entry from your diary?';

  @override
  String get diaryConfirmDeleteYes => 'Remove';

  @override
  String get diaryGramsLabel => 'Grams';

  @override
  String get diaryQuantityLabel => 'Quantity';

  @override
  String get diaryNoEntriesForMeal => 'No entries yet';

  @override
  String get diaryKcalShort => 'kcal';

  @override
  String get diarySelectDate => 'Select date';

  @override
  String get diaryToday => 'Today';

  @override
  String get diaryYesterday => 'Yesterday';

  @override
  String diaryEntryCalories(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipesTitle => 'My recipes';

  @override
  String get recipesCreate => 'Create recipe';

  @override
  String get recipesEdit => 'Edit recipe';

  @override
  String get recipesEmptyTitle => 'No personal recipes yet';

  @override
  String get recipesEmptyBody =>
      'Save family recipes like Mum\'s jollof or Grandma\'s dal so you can log the versions you actually cook.';

  @override
  String get recipesNameLabel => 'Recipe name';

  @override
  String get recipesServingsLabel => 'Servings';

  @override
  String get recipesYieldLabel => 'Total yield (g)';

  @override
  String get recipesYieldHint => 'Optional — defaults to ingredient sum';

  @override
  String get recipesIngredients => 'Ingredients';

  @override
  String get recipesIngredientsEmpty =>
      'Add ingredients to calculate nutrition.';

  @override
  String get recipesAddIngredient => 'Add ingredient';

  @override
  String get recipesNotesLabel => 'Notes';

  @override
  String get recipesCalculatedNutrition => 'Calculated nutrition';

  @override
  String recipesWholeRecipeKcal(int kcal) {
    return 'Whole recipe: ≈ $kcal kcal';
  }

  @override
  String recipesPerServingKcal(int kcal) {
    return '≈ $kcal kcal per serving';
  }

  @override
  String recipesServingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String get recipesPerServingShort => 'serving';

  @override
  String get recipesCalculationNote =>
      'Calculated from your ingredients and quantities. Preparation and yield can change the values.';

  @override
  String get recipesDeleteTitle => 'Delete recipe?';

  @override
  String get recipesDeleteBody =>
      'This removes the recipe from your personal collection. Diary entries already logged are not affected.';

  @override
  String get barcodeTitle => 'Scan barcode';

  @override
  String get barcodeHint =>
      'Point your camera at a packaged-food barcode, or enter the number manually.';

  @override
  String get barcodeManualLabel => 'Barcode number';

  @override
  String get barcodeManualHint => 'e.g. 3017620422003';

  @override
  String get barcodeLookupButton => 'Look up product';

  @override
  String get barcodeCameraUnavailable =>
      'Camera unavailable on this device. Enter the barcode manually instead.';

  @override
  String get barcodeNotFoundTitle => 'Product not found';

  @override
  String barcodeNotFoundBody(String barcode) {
    return 'No packaged food matched barcode $barcode. You can try again or add the food another way.';
  }

  @override
  String get barcodeInvalid =>
      'That does not look like a valid barcode. Use 8–14 digits.';

  @override
  String get barcodeNetworkError =>
      'Could not reach the packaged-food database. Check your connection and try again.';

  @override
  String get barcodeTryAgain => 'Try again';

  @override
  String get barcodeCrowdsourcedNote =>
      'Packaged-food data comes from Open Food Facts and may be incomplete or crowdsourced. Always verify the serving size before logging.';

  @override
  String get assistantTitle => 'Ask Nutrivoya';

  @override
  String get assistantIntro =>
      'Ask about your meals, cultural staples, protein, or hunger — answers use your diary, targets, and food database. Numbers are never invented.';

  @override
  String get assistantWellnessDisclaimer =>
      'Nutrivoya offers general wellness guidance, not medical advice.';

  @override
  String get assistantMedicalDisclaimer =>
      'This sounds like a medical or high-risk topic. Please speak with a qualified health professional. Nutrivoya cannot diagnose, treat, or prescribe.';

  @override
  String get assistantTryAsking => 'Try asking';

  @override
  String get assistantSuggestions => 'Suggestions';

  @override
  String get assistantSources => 'Sources';

  @override
  String get assistantInputHint => 'Ask about rice, protein, balance…';

  @override
  String get assistantSend => 'Send';

  @override
  String get assistantClear => 'Clear chat';

  @override
  String get assistantPromptRice => 'Can I still eat rice while losing weight?';

  @override
  String get assistantPromptBalance => 'How can I balance today\'s meals?';

  @override
  String get assistantPromptProtein =>
      'How can I raise protein with familiar foods?';

  @override
  String get assistantPromptHunger =>
      'Why am I still hungry near my calorie target?';

  @override
  String get assistantPromptRoti => 'How many calories in roti?';

  @override
  String assistantHeadlineCultural(String staple) {
    return 'Yes — $staple can fit your goals';
  }

  @override
  String get assistantHeadlineBalance => 'Today\'s meal balance';

  @override
  String get assistantHeadlineProtein => 'Raising protein with familiar foods';

  @override
  String get assistantHeadlineHunger => 'Hunger near your calorie target';

  @override
  String assistantHeadlineLookupFound(String foodName) {
    return 'Nutrition for $foodName';
  }

  @override
  String assistantHeadlineLookupMissing(String foodName) {
    return 'No match for “$foodName”';
  }

  @override
  String get assistantHeadlineSubstitute => 'Modify before you replace';

  @override
  String get assistantHeadlineMedical => 'Please seek professional guidance';

  @override
  String get assistantHeadlineUnknown => 'I need a clearer question';

  @override
  String assistantBodyCultural(String staple, String cuisine) {
    return '$staple is a normal part of $cuisine eating. You do not need to abandon it — adjust portions and pairings to match your goal.';
  }

  @override
  String assistantBodyCulturalWithData(
    String staple,
    String foodName,
    String portionName,
    int kcal,
    String sourceName,
  ) {
    return '$staple can stay in your pattern. From the food database, $foodName ($portionName) is about $kcal kcal ($sourceName). Prefer a smaller portion or add vegetables and a protein side rather than cutting the staple entirely.';
  }

  @override
  String assistantBodyBalanceWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int proteinTarget,
    int entryCount,
  ) {
    return 'Today you have logged $caloriesConsumed of $calorieTarget kcal and $proteinConsumed of $proteinTarget g protein across $entryCount entries. Use familiar foods and small adjustments — not food moralising.';
  }

  @override
  String assistantBodyBalanceNoTargets(
    int caloriesConsumed,
    int proteinConsumed,
    int entryCount,
  ) {
    return 'Today you have logged $caloriesConsumed kcal and $proteinConsumed g protein across $entryCount entries. Set goals in Settings for clearer targets, or keep logging familiar meals.';
  }

  @override
  String assistantBodyProteinWithTargets(
    int proteinConsumed,
    int proteinTarget,
    int proteinGap,
    String cuisine,
  ) {
    return 'You have logged $proteinConsumed of $proteinTarget g protein today ($proteinGap g to go). Keep $cuisine staples and add protein-rich sides.';
  }

  @override
  String assistantBodyProtein(int proteinConsumed, String cuisine) {
    return 'You have logged $proteinConsumed g protein today. Raise it with familiar $cuisine pairings rather than replacing your usual meals.';
  }

  @override
  String assistantBodyHungerWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int fibreConsumed,
  ) {
    return 'You are at $caloriesConsumed of $calorieTarget kcal, with $proteinConsumed g protein and $fibreConsumed g fibre logged. Hunger can reflect protein, fibre, meal timing, or water — not a moral failure.';
  }

  @override
  String assistantBodyHunger(
    int caloriesConsumed,
    int proteinConsumed,
    int fibreConsumed,
  ) {
    return 'You have logged $caloriesConsumed kcal, $proteinConsumed g protein and $fibreConsumed g fibre today. Hunger often improves with protein, fibre, and slower eating — not by labelling foods as bad.';
  }

  @override
  String assistantBodyLookupFound(
    String foodName,
    String portionName,
    int kcal,
    int proteinG,
    String sourceName,
    String confidence,
  ) {
    return '$foodName · $portionName: ≈ $kcal kcal and $proteinG g protein. Source: $sourceName. Confidence: $confidence.';
  }

  @override
  String assistantBodyLookupNoNutrition(String foodName, String sourceName) {
    return '$foodName was found in $sourceName, but reliable calorie data is unavailable. Nutrivoya will not invent a number.';
  }

  @override
  String assistantBodyLookupMissing(String foodName) {
    return 'No structured food matched “$foodName”. Try another name, a barcode, or add a personal recipe — calories will not be guessed.';
  }

  @override
  String get assistantBodySubstitute =>
      'Start by changing portion size, adding vegetables, or pairing a protein side with the food you already eat. Replacement is optional — modification usually keeps cultural meals intact.';

  @override
  String get assistantBodyMedical =>
      'Nutrivoya cannot advise on diagnosis, medications, pregnancy complications, eating disorders, or other clinical situations. Please consult an appropriate professional.';

  @override
  String get assistantBodyUnknown =>
      'Try questions like “Can I still eat rice?”, “How do I raise protein?”, “How many calories in roti?”, or “Why am I still hungry?”';

  @override
  String get assistantTipAskRice =>
      'Ask whether a cultural staple can fit your goals';

  @override
  String get assistantTipAskBalance =>
      'Ask how today\'s logged meals look against your targets';

  @override
  String get assistantTipAskProtein =>
      'Ask how to raise protein with familiar foods';

  @override
  String get assistantTipAskFoodLookup =>
      'Ask “calories in …” for a food in the database';

  @override
  String get assistantTipSeekProfessional =>
      'Contact a doctor, dietitian, or other qualified clinician';

  @override
  String get assistantTipFoodNotFound =>
      'Try a different spelling, alias, or barcode scan';

  @override
  String get assistantTipNutritionUnavailable =>
      'Nutrition data unavailable — no invented calories';

  @override
  String get assistantTipVerifyPortion =>
      'Confirm the portion matches what you ate before logging';

  @override
  String get assistantTipNoMoralFood =>
      'No food is inherently good or bad — context and pattern matter';

  @override
  String get assistantTipHungerProteinFibre =>
      'Check protein and fibre — both support fullness';

  @override
  String get assistantTipHungerPace =>
      'Eat a little slower and include volume foods like vegetables';

  @override
  String get assistantTipProteinPairDal =>
      'Pair grains with dal, beans, or lentils';

  @override
  String get assistantTipProteinPairYoghurt =>
      'Add yoghurt, paneer, or strained dairy on the side';

  @override
  String get assistantTipProteinPairEgg =>
      'Add egg, fish, tofu, or lean meat when it fits your cuisine';

  @override
  String get assistantTipModifyNotReplace =>
      'Modify the meal you already like before replacing it';

  @override
  String get assistantTipModifyPortion =>
      'Try a smaller serving of the staple first';

  @override
  String get assistantTipAddVegetables =>
      'Add vegetables or salad for volume and fibre';

  @override
  String get assistantTipAddProteinSide =>
      'Add a protein-rich side rather than cutting the staple';

  @override
  String get assistantTipLogSomething =>
      'Log a meal so balance advice can use your real pattern';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressIntro =>
      'Track weight, water and measurements as calm trends — day-to-day changes are noise, not a verdict.';

  @override
  String get progressWater => 'Water today';

  @override
  String progressWaterTotal(int total, int goal) {
    return '$total ml of $goal ml';
  }

  @override
  String progressWaterAdd(int ml) {
    return '+$ml ml';
  }

  @override
  String get progressWeight => 'Weight';

  @override
  String get progressLogWeight => 'Log weight';

  @override
  String get progressWeightKgLabel => 'Weight (kg)';

  @override
  String progressWeightValue(String kg) {
    return '$kg kg';
  }

  @override
  String get progressWeightEmpty =>
      'No weight logs yet. Add a few over days to see a calm trend.';

  @override
  String get progressWeightInvalid =>
      'Enter a plausible weight between 20 and 400 kg.';

  @override
  String get progressTrendNote =>
      'Trends use a multi-day average. Single-day changes are expected and not judged.';

  @override
  String get progressTrendInsufficient =>
      'Log weight on a few more days to estimate a weekly trend.';

  @override
  String progressTrendSteady(String avg) {
    return 'Around $avg kg — roughly steady over recent days.';
  }

  @override
  String progressTrendRising(String avg, String delta) {
    return 'Around $avg kg — gently rising (~$delta kg/week). Focus on patterns, not one day.';
  }

  @override
  String progressTrendFalling(String avg, String delta) {
    return 'Around $avg kg — gently falling (~$delta kg/week). Focus on patterns, not one day.';
  }

  @override
  String get progressMeasurements => 'Body measurements';

  @override
  String get progressMeasurementsNote =>
      'Optional waist and hip in centimetres. These are not used for calorie targets.';

  @override
  String get progressMeasurementsEmpty => 'No measurements logged yet.';

  @override
  String get progressLogMeasurement => 'Log measurement';

  @override
  String get progressWaistLabel => 'Waist (cm)';

  @override
  String get progressHipLabel => 'Hip (cm)';

  @override
  String progressWaist(String cm) {
    return 'Waist $cm cm';
  }

  @override
  String progressHip(String cm) {
    return 'Hip $cm cm';
  }

  @override
  String get progressMeasurementInvalid => 'Enter at least one measurement.';

  @override
  String get favouritesTitle => 'Favourites';

  @override
  String get favouritesAdd => 'Add to favourites';

  @override
  String get favouritesRemove => 'Remove from favourites';

  @override
  String get frequentFoodsTitle => 'Frequent foods';

  @override
  String get frequentFoodsEmpty => 'Foods you log often will appear here.';

  @override
  String frequentFoodsCount(int count) {
    return 'Logged $count times';
  }

  @override
  String get templatesTitle => 'Meal templates';

  @override
  String get templatesIntro =>
      'Save a day\'s familiar meals and re-apply them later — useful for usual breakfasts and family patterns.';

  @override
  String get templatesEmpty =>
      'No templates yet. Log a day you like, then save it as a template.';

  @override
  String get templatesSaveFromToday => 'Save from today';

  @override
  String get templatesNameLabel => 'Template name';

  @override
  String get templatesNeedEntries =>
      'Log some foods today before saving a template.';

  @override
  String get templatesSaved => 'Template saved';

  @override
  String get templatesApply => 'Apply to today';

  @override
  String templatesApplied(int count) {
    return 'Added $count items from the template';
  }

  @override
  String templatesTodayCount(int count) {
    return '$count diary entries available to save';
  }

  @override
  String templatesItemSummary(int count, int kcal) {
    return '$count items · ≈ $kcal kcal';
  }

  @override
  String get photoTitle => 'Photo meal';

  @override
  String get photoIntro =>
      'Photograph a meal, describe what you see, then confirm a food from the database. Nutrition always comes from structured food data — never from the image alone.';

  @override
  String get photoUncertaintyDisclaimer =>
      'Photo suggestions are uncertain. Always confirm the food and portion before logging. Computer vision estimates are never treated as certain.';

  @override
  String get photoTakePhoto => 'Take photo';

  @override
  String get photoChooseGallery => 'Choose from gallery';

  @override
  String get photoRetake => 'Choose a different photo';

  @override
  String get photoClear => 'Clear photo';

  @override
  String get photoDescriptionLabel => 'What do you see?';

  @override
  String get photoDescriptionHint =>
      'e.g. roti and dal, jollof rice, bowl of pho';

  @override
  String get photoSuggestFoods => 'Suggest foods';

  @override
  String get photoSuggestionsTitle => 'Possible matches';

  @override
  String get photoSuggestionsNote =>
      'These come from your description searched in the food database — not invented calories from the photo.';

  @override
  String get photoConfidenceUncertain => 'Uncertain match — confirm';

  @override
  String get photoConfidenceLow => 'Weak match — check carefully';

  @override
  String get photoPortionTitle => 'Estimate portion';

  @override
  String get photoPortionNote =>
      'Portion from the photo is only an estimate. Adjust before logging.';

  @override
  String get photoConfirmOpenFood => 'Confirm and open food';

  @override
  String get photoConfirmNote =>
      'Next you will verify serving size on the food details screen. Logging uses structured nutrition only.';

  @override
  String get photoDetailsEstimateNote =>
      'Portion was suggested from a meal photo and is uncertain — verify grams before logging.';

  @override
  String get photoSearchSubtitle =>
      'Photograph a meal, then confirm a food from the database.';

  @override
  String get photoErrorNoImage => 'Add a photo first.';

  @override
  String get photoErrorNeedDescription =>
      'Describe what you see so Nutrivoya can search the food database. The app will not invent foods from pixels alone.';

  @override
  String get photoErrorNoMatches =>
      'No structured foods matched that description. Try another name or search manually.';

  @override
  String get photoErrorFailed =>
      'Could not use that photo. Try again or pick another image.';

  @override
  String get addProductTitle => 'Add Product';

  @override
  String get addProductIntro =>
      'Submit a missing food or packaged product for your personal library. Values you enter are never treated as authoritative.';

  @override
  String get addProductProvenanceNote =>
      'Leave nutrition blank when unknown. Nutrivoya will not invent calories or macros.';

  @override
  String get addProductNameLabel => 'Product or food name';

  @override
  String get addProductBrandLabel => 'Brand (optional)';

  @override
  String get addProductBarcodeLabel => 'Barcode (optional)';

  @override
  String get addProductCuisineLabel => 'Cuisine or region (optional)';

  @override
  String get addProductServingSection => 'Serving';

  @override
  String get addProductServingGramsLabel => 'Default serving (grams)';

  @override
  String get addProductPortionNameLabel => 'Portion name (optional)';

  @override
  String get addProductNutritionSection => 'Nutrition per 100 g (optional)';

  @override
  String get addProductNutritionHint =>
      'Enter only values you know from a label or trusted source. Leave fields empty rather than guessing.';

  @override
  String get addProductEnergyLabel => 'Energy (kcal / 100 g)';

  @override
  String get addProductProteinLabel => 'Protein (g / 100 g)';

  @override
  String get addProductCarbLabel => 'Carbohydrate (g / 100 g)';

  @override
  String get addProductFatLabel => 'Fat (g / 100 g)';

  @override
  String get addProductFibreLabel => 'Fibre (g / 100 g)';

  @override
  String get addProductNotesLabel => 'Notes (optional)';

  @override
  String get addProductSubmit => 'Save to my library';

  @override
  String get addProductSubmitNote =>
      'Saved as user-submitted with pending review. It appears in your search only — not as verified nutrition.';

  @override
  String get addProductPublished =>
      'Saved to your personal library (pending review)';

  @override
  String get addProductErrorNameRequired => 'Enter a product or food name.';

  @override
  String get addProductErrorNameShort => 'Name is too short.';

  @override
  String get addProductErrorServingInvalid =>
      'Serving must be between 0 and 5000 grams.';

  @override
  String get addProductErrorBarcodeInvalid => 'Barcode should be 8–14 digits.';

  @override
  String get addProductErrorEnergyInvalid =>
      'Energy must be between 0 and 950 kcal per 100 g.';

  @override
  String get addProductErrorProteinInvalid =>
      'Protein must be between 0 and 1000 g per 100 g.';

  @override
  String get addProductErrorCarbInvalid =>
      'Carbohydrate must be between 0 and 1000 g per 100 g.';

  @override
  String get addProductErrorFatInvalid =>
      'Fat must be between 0 and 1000 g per 100 g.';

  @override
  String get addProductErrorFibreInvalid =>
      'Fibre must be between 0 and 1000 g per 100 g.';

  @override
  String get addProductWarningNoNutrition =>
      'No nutrition entered — food will show as unavailable until you add values.';

  @override
  String get addProductWarningNoEnergy =>
      'Energy is missing — macros alone will not show calories.';

  @override
  String get addProductWarningMacrosHigh =>
      'Protein + carbs + fat exceed 110 g per 100 g — check the label.';

  @override
  String get addProductStatusDraft => 'Draft';

  @override
  String get addProductStatusPending => 'Pending review';

  @override
  String get addProductStatusPublished =>
      'In personal library (pending review)';

  @override
  String get addProductStatusWithdrawn => 'Withdrawn';

  @override
  String get mySubmissionsTitle => 'My submissions';

  @override
  String get mySubmissionsEmpty =>
      'No submissions yet. Add a missing product from search, barcode, or Settings.';

  @override
  String get authContinueOffline => 'Continue without an account';

  @override
  String get authOfflineNote =>
      'Your data stays on this device only. Accounts and sync are available when Nutrivoya is connected to its backend.';

  @override
  String get settingsSyncNow => 'Sync now';

  @override
  String settingsSyncPending(int count) {
    return '$count changes waiting to sync';
  }

  @override
  String get settingsSyncDone => 'Diary synced';

  @override
  String get settingsSyncUnavailable =>
      'Sync unavailable — data is stored on this device';

  @override
  String get addProductStatusVerified => 'Verified by reviewer';

  @override
  String get addProductStatusRejected => 'Rejected';

  @override
  String get reviewQueueTitle => 'Review queue';

  @override
  String get reviewQueueEmpty => 'No submissions waiting for review.';

  @override
  String get reviewQueueNeedReviewerMode =>
      'Turn on Reviewer mode in Settings to approve or reject submissions. Review never invents nutrition values.';

  @override
  String get reviewQueueProvenanceNote =>
      'Approve only checks provenance — missing nutrition stays unavailable.';

  @override
  String get reviewQueueOpenFood => 'Open food';

  @override
  String get reviewQueueApprove => 'Approve';

  @override
  String get reviewQueueReject => 'Reject';

  @override
  String get reviewQueueApproved =>
      'Marked verified (user-submitted provenance kept)';

  @override
  String get reviewQueueRejected => 'Submission rejected';

  @override
  String reviewQueueBarcode(String code) {
    return 'Barcode $code';
  }

  @override
  String reviewQueueEnergy(int kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String get reviewQueueNoEnergy => 'Energy unavailable';

  @override
  String get settingsReviewerMode => 'Reviewer mode';

  @override
  String get settingsReviewerModeNote =>
      'Allow approving or rejecting pending product submissions on this device.';

  @override
  String get dashboardMicrosTitle => 'Micronutrients today';

  @override
  String get dashboardMicrosNote =>
      'Shown only when logged foods include measured values. Missing nutrients stay unavailable — never invented.';

  @override
  String get dashboardMicroUnavailable => 'unavailable';

  @override
  String get culturalSuggestionsTitle => 'Familiar cuisine ideas';

  @override
  String get culturalSuggestionsIntro =>
      'Ideas from your food database that fit familiar cuisines and today\'s diary. Nutrition always comes from structured records.';

  @override
  String get culturalSuggestionsEmpty =>
      'Add familiar cuisines in your profile, or log a meal, to see ideas from the food database.';

  @override
  String culturalSuggestionsKcalPer100g(int kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String get culturalSuggestionsKcalUnavailable => 'Energy unavailable';

  @override
  String get culturalSuggestReasonFamiliarCuisine => 'Familiar cuisine';

  @override
  String get culturalSuggestReasonProteinFamiliar =>
      'Protein-rich familiar food';

  @override
  String get culturalSuggestReasonProtein => 'Higher protein option';

  @override
  String get culturalSuggestReasonFibreFamiliar => 'Fibre-rich familiar food';

  @override
  String get culturalSuggestReasonFibre => 'Higher fibre option';

  @override
  String get culturalSuggestReasonExplore => 'From the food database';

  @override
  String get educationTitle => 'Nutrition education';

  @override
  String get educationIntro =>
      'Short guidance that respects cultural foods. Tips never invent calorie numbers for specific dishes.';

  @override
  String get educationTipPortionsTitle => 'Portion first, ban rarely';

  @override
  String get educationTipPortionsBody =>
      'Changing portion size or pairing a staple with vegetables and protein usually works better than removing a cultural food entirely.';

  @override
  String get educationTipStaplesTitle =>
      'Staples are not automatically unhealthy';

  @override
  String get educationTipStaplesBody =>
      'Rice, roti, yam, plantain, injera and similar staples can fit many goals when portions and overall patterns are considered.';

  @override
  String get educationTipPairProteinTitle => 'Pair for balance';

  @override
  String get educationTipPairProteinBody =>
      'If a meal is mostly starch, adding a familiar protein side or legumes can improve balance without abandoning the dish you enjoy.';

  @override
  String get educationTipFibreTitle => 'Fibre from familiar plants';

  @override
  String get educationTipFibreBody =>
      'Beans, lentils, vegetables and whole grains already common in many cuisines are practical fibre sources — check the food database for measured values.';

  @override
  String get educationTipMissingDataTitle => 'Missing data stays missing';

  @override
  String get educationTipMissingDataBody =>
      'When Nutrivoya lacks a nutrient value, it shows unavailable. The app will not invent calories or micros to fill gaps.';

  @override
  String get educationTipProvenanceTitle => 'Provenance matters';

  @override
  String get educationTipProvenanceBody =>
      'User-submitted foods stay labeled until verified. Verified still means user-submitted provenance — not an authoritative lab dataset.';

  @override
  String get catalogTitle => 'Public food catalog';

  @override
  String get catalogIntro =>
      'Verified user-contributed foods shared for others to search. Values are never invented at publish time.';

  @override
  String get catalogEmpty =>
      'No verified foods published yet. Approve a submission, then publish it from My submissions.';

  @override
  String get catalogVerifiedBadge => 'Verified submission';

  @override
  String get catalogPublishAction => 'Publish to catalog';

  @override
  String get catalogPublishDone => 'Published to the public catalog';

  @override
  String get catalogPublishNeedVerified =>
      'Only verified submissions can be published';

  @override
  String get settingsOnDevicePhotoAssist => 'On-device photo assist';

  @override
  String get settingsOnDevicePhotoAssistNote =>
      'Match your description to food vocabulary on this device, then look up structured nutrition. Never invents calories from the image.';

  @override
  String get photoOnDeviceAssistNote =>
      'On-device assist is on: your description is matched to food vocabulary, then looked up in the database. Pixels alone never invent foods or calories.';

  @override
  String get photoReasonRecognizer => 'On-device vocabulary match';

  @override
  String get photoReasonCuisineToken => 'Familiar-cuisine vocabulary match';

  @override
  String get photoReasonSearchMatch => 'Description search match';
}
