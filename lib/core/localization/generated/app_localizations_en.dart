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
      'No results yet. Food search will be available in a later milestone.';

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
  String get goalsEstimateNote =>
      'These are estimates based on standard equations (Mifflin-St Jeor). Your actual needs may vary, and they can be refined over time using your weight trend.';

  @override
  String get goalsMaintenance => 'Estimated maintenance';

  @override
  String get goalsBmr => 'Estimated resting energy (BMR)';

  @override
  String goalsKcalValue(String value) {
    return '$value kcal';
  }

  @override
  String goalsGramValue(String value) {
    return '$value g';
  }

  @override
  String get goalsCompleteProfile =>
      'Complete your profile to see estimated targets.';

  @override
  String get goalsRateTitle => 'Rate of change (kg per week)';

  @override
  String goalsRateValue(String value) {
    return '$value kg/week';
  }

  @override
  String get goalsCustomTarget => 'Custom calorie target';

  @override
  String get goalsCustomTargetHint => 'Leave empty to use the estimate';

  @override
  String get goalsUseEstimate => 'Use estimate';

  @override
  String get goalsSave => 'Save';

  @override
  String get goalsUsingCustom => 'Using your custom target';

  @override
  String get goalsLifeStage => 'Life stage (optional)';

  @override
  String get goalsLifeStageNone => 'Prefer not to say / not applicable';

  @override
  String get goalsLifeStagePregnant => 'Pregnant';

  @override
  String get goalsLifeStageBreastfeeding => 'Breastfeeding';

  @override
  String get goalsLifeStagePostpartum => 'Postpartum';

  @override
  String get goalsLifeStagePerimenopause => 'Perimenopause';

  @override
  String get goalsLifeStageMenopause => 'Menopause';

  @override
  String get goalsWarningRateCapped =>
      'Your requested rate was reduced to a gentler, more sustainable pace.';

  @override
  String get goalsWarningFloor =>
      'Your target was kept above a safe minimum intake.';

  @override
  String get goalsWarningPregnancy =>
      'Nutrivoya doesn\'t set weight-loss targets during pregnancy. Please discuss nutrition and weight with your midwife or clinician.';

  @override
  String get goalsWarningBreastfeeding =>
      'While breastfeeding, extra energy is included and no aggressive deficit is set. A health professional can advise on gradual changes.';

  @override
  String get goalsWarningUnderweight =>
      'Your BMI is below 18.5, so Nutrivoya won\'t set a weight-loss target. Consider speaking with a health professional.';

  @override
  String get goalsWarningMinor =>
      'Weight-loss targets aren\'t set for people under 18. A doctor or registered dietitian can give personalised guidance.';

  @override
  String get goalsWarningNeutral =>
      'Physiological input wasn\'t specified, so a neutral equation was used. Estimates may be less precise.';

  @override
  String get goalsWarningCustomLow =>
      'This target is very low. Very low intakes can be unsafe without medical supervision.';

  @override
  String dashboardOfTarget(String consumed, String target) {
    return '$consumed / $target kcal';
  }

  @override
  String dashboardRemaining(String value) {
    return '$value kcal remaining (estimate)';
  }

  @override
  String dashboardAbove(String value) {
    return '$value kcal above estimate';
  }

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
  String get settingsRecipes => 'My recipes';

  @override
  String get recipesTitle => 'My recipes';

  @override
  String get recipesEmpty =>
      'No recipes yet. Build one from the ingredients you actually cook with — nutrition is calculated from each ingredient.';

  @override
  String get recipeNew => 'New recipe';

  @override
  String get recipeEdit => 'Edit recipe';

  @override
  String get recipeDelete => 'Delete recipe';

  @override
  String get recipeName => 'Recipe name';

  @override
  String get recipeServings => 'Servings';

  @override
  String get recipeYield => 'Cooked weight (g, optional)';

  @override
  String get recipeYieldHelp =>
      'Weigh the finished pot to account for water gained or lost while cooking. Leave empty to use the ingredient total.';

  @override
  String get recipeIngredients => 'Ingredients';

  @override
  String get recipeAddIngredient => 'Add ingredient';

  @override
  String get recipeSearchIngredient => 'Search ingredients';

  @override
  String get recipeGrams => 'g';

  @override
  String recipePerServing(String grams) {
    return 'Per serving ($grams g)';
  }

  @override
  String recipeNutritionLine(
    String kcal,
    String protein,
    String carbs,
    String fat,
  ) {
    return '$kcal kcal · protein $protein g · carbs $carbs g · fat $fat g';
  }

  @override
  String get recipeSave => 'Save recipe';

  @override
  String get recipeNeedsIngredients => 'Add a name and at least one ingredient';

  @override
  String get recipeMissingData =>
      'Some ingredients have no data for a nutrient, so it is shown as unavailable rather than guessed.';

  @override
  String get barcodeTitle => 'Scan a barcode';

  @override
  String get barcodeScanTooltip => 'Scan barcode';

  @override
  String get barcodeManualHint => 'Or type the barcode number';

  @override
  String get barcodeLookup => 'Look up';

  @override
  String get barcodeInvalid => 'That doesn\'t look like a valid barcode';

  @override
  String get barcodeCameraUnavailable =>
      'Camera unavailable — enter the barcode number below.';

  @override
  String get barcodeProductTitle => 'Packaged product';

  @override
  String get barcodeNotFound =>
      'Product not found in Open Food Facts. You can search by name instead.';

  @override
  String get barcodeLookupFailed =>
      'Couldn\'t reach the product database. Check your connection and try again.';

  @override
  String get barcodeSearchByName => 'Search by name';

  @override
  String get barcodeSource =>
      'Source: Open Food Facts (community data, not verified by Nutrivoya)';

  @override
  String get barcodePer100g => 'Nutrition per 100 g';

  @override
  String get barcodeVerifyCheckbox =>
      'I checked these values against the label on the package';

  @override
  String get barcodeUse => 'Use this product';

  @override
  String get barcodeIssueMissingEnergy =>
      'The energy value is missing — please check the label.';

  @override
  String get barcodeIssueMissingMacros =>
      'Some macronutrient values are missing; they will be shown as unavailable.';

  @override
  String get barcodeIssueEnergyMismatch =>
      'Calories don\'t add up from protein, carbs and fat — the product data may contain an error.';

  @override
  String get barcodeIssueImplausible =>
      'Some values look impossible per 100 g — please check the label.';

  @override
  String get settingsAssistant => 'Ask Nutrivoya';

  @override
  String get assistantTitle => 'Ask Nutrivoya';

  @override
  String get assistantIntro =>
      'I answer from Nutrivoya\'s food data, your diary and your estimated targets — I never make up nutrition numbers. I\'m not a substitute for medical advice.';

  @override
  String get assistantProfileCaution =>
      'Because of your profile (for example pregnancy, breastfeeding, age or low body weight), please check any changes to how you eat with a qualified professional.';

  @override
  String get assistantAskDay => 'How is my day going?';

  @override
  String get assistantAskBalance => 'Balance my next meal';

  @override
  String get assistantAskFood => 'Tell me about a food';

  @override
  String get assistantAskSwap => 'Ideas for a food I eat';

  @override
  String get assistantInputHint => 'Ask a question';

  @override
  String get assistantDayEmpty =>
      'Nothing logged yet today. Whenever you eat, log it and I can help you see how the day is shaping up.';

  @override
  String assistantDayNoTargets(String kcal, String protein, String fibre) {
    return 'So far today: $kcal kcal, $protein g protein and $fibre g fibre. Set up goals to compare with personal targets.';
  }

  @override
  String assistantDaySummary(
    String kcal,
    String target,
    String protein,
    String proteinTarget,
    String fibre,
    String fibreTarget,
  ) {
    return 'So far today: $kcal of about $target kcal, $protein of $proteinTarget g protein and $fibre of $fibreTarget g fibre. Targets are estimates, not strict rules.';
  }

  @override
  String get assistantBalanceNoTargets =>
      'Set up your goals first so I can compare with personal targets.';

  @override
  String get assistantBalanceOnTrack =>
      'Protein and fibre are close to today\'s estimates — enjoy your next meal the way you like it.';

  @override
  String assistantBalanceProtein(String gap) {
    return 'Protein is about $gap g below today\'s estimate. Options with plenty of protein, familiar cuisines first:';
  }

  @override
  String assistantBalanceFibre(String gap) {
    return 'Fibre is about $gap g below today\'s estimate. Options rich in fibre:';
  }

  @override
  String assistantFoodSummary(
    String name,
    String grams,
    String kcal,
    String protein,
    String carbs,
    String fat,
  ) {
    return '$name: a $grams g serving has about $kcal kcal, $protein g protein, $carbs g carbs and $fat g fat.';
  }

  @override
  String get assistantFoodUnavailable =>
      'Some values aren\'t available for this food, so I won\'t estimate them.';

  @override
  String assistantFoodCulture(String places) {
    return 'Food tradition: $places.';
  }

  @override
  String assistantFoodSource(String source, String confidence) {
    return 'Data: $source · confidence: $confidence.';
  }

  @override
  String get assistantHighlightHighProtein => 'A rich source of protein.';

  @override
  String get assistantHighlightSourceProtein =>
      'Provides a useful amount of protein.';

  @override
  String get assistantHighlightHighFibre => 'High in fibre.';

  @override
  String get assistantHighlightSourceFibre => 'A source of fibre.';

  @override
  String get assistantHighlightEnergyDense =>
      'Energy-dense — portion size makes a big difference to the total.';

  @override
  String get assistantHighlightLight => 'Low in energy per 100 g.';

  @override
  String get assistantHighlightHighSodium =>
      'Fairly high in salt — worth knowing if you\'re watching sodium.';

  @override
  String get assistantSwapIntro =>
      'Ideas from the same food tradition — not replacements, just options:';

  @override
  String assistantSwapMoreFibre(String name) {
    return '$name — more fibre per calorie';
  }

  @override
  String assistantSwapMoreProtein(String name) {
    return '$name — more protein per calorie';
  }

  @override
  String assistantSwapLighter(String name) {
    return '$name — lighter per 100 g';
  }

  @override
  String get assistantSwapNone =>
      'I don\'t have close alternatives from the same tradition yet. Adjusting the portion, or adding vegetables or legumes on the side, are simple options.';

  @override
  String get assistantUnknown =>
      'I can help with your day so far, balancing your next meal, information about a food, or ideas from the same cuisine. Try one of the suggestions above.';

  @override
  String get assistantSafety =>
      'This deserves personal care. Please talk to a doctor, registered dietitian or another qualified professional — I won\'t give targets or numbers for this.';

  @override
  String get assistantSafetyEatingDisorder =>
      'If you\'re struggling with eating, you\'re not alone. Please reach out to a doctor or an eating-disorder support service in your country.';
}
