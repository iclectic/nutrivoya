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
}
