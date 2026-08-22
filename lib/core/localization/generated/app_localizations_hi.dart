// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'न्यूट्रिवोया';

  @override
  String get appTagline =>
      'ऐसा पोषण जो आपके खाने, आपकी संस्कृति और आपकी ज़िंदगी के साथ काम करता है।';

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
}
