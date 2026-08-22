import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pa'),
  ];

  /// Application display name
  ///
  /// In en, this message translates to:
  /// **'Nutrivoya'**
  String get appName;

  /// Welcome screen tagline
  ///
  /// In en, this message translates to:
  /// **'Nutrition that works with your food, your culture and your life.'**
  String get appTagline;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get commonGetStarted;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navDashboard;

  /// No description provided for @navDiary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get navDiary;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue tracking your nutrition.'**
  String get authLoginSubtitle;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your culturally intelligent nutrition journey.'**
  String get authSignupSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get authEmailHint;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// No description provided for @authSignupButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignupButton;

  /// No description provided for @authSwitchToSignup.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get authSwitchToSignup;

  /// No description provided for @authSwitchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authSwitchToLogin;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get authErrorGeneric;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Nutrivoya'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Nutrition that works with your food, your culture and your life.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like Nutrivoya to help with?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalMaintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain my weight'**
  String get onboardingGoalMaintain;

  /// No description provided for @onboardingGoalLose.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get onboardingGoalLose;

  /// No description provided for @onboardingGoalGain.
  ///
  /// In en, this message translates to:
  /// **'Gain weight'**
  String get onboardingGoalGain;

  /// No description provided for @onboardingGoalBuildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get onboardingGoalBuildMuscle;

  /// No description provided for @onboardingGoalImprove.
  ///
  /// In en, this message translates to:
  /// **'Improve my nutrition'**
  String get onboardingGoalImprove;

  /// No description provided for @onboardingGoalTrack.
  ///
  /// In en, this message translates to:
  /// **'Just track what I eat'**
  String get onboardingGoalTrack;

  /// No description provided for @onboardingProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get onboardingProfileTitle;

  /// No description provided for @onboardingProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We use this only to estimate your nutrition needs. You can change it later.'**
  String get onboardingProfileSubtitle;

  /// No description provided for @onboardingAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get onboardingAgeLabel;

  /// No description provided for @onboardingHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get onboardingHeightLabel;

  /// No description provided for @onboardingWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get onboardingWeightLabel;

  /// No description provided for @onboardingSexLabel.
  ///
  /// In en, this message translates to:
  /// **'Physiological calculation input'**
  String get onboardingSexLabel;

  /// No description provided for @onboardingSexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboardingSexFemale;

  /// No description provided for @onboardingSexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboardingSexMale;

  /// No description provided for @onboardingSexPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get onboardingSexPreferNotToSay;

  /// No description provided for @onboardingSexHelp.
  ///
  /// In en, this message translates to:
  /// **'Used only for energy-requirement equations. This is separate from your gender identity.'**
  String get onboardingSexHelp;

  /// No description provided for @onboardingActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get onboardingActivityLabel;

  /// No description provided for @onboardingActivitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get onboardingActivitySedentary;

  /// No description provided for @onboardingActivityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly active'**
  String get onboardingActivityLight;

  /// No description provided for @onboardingActivityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get onboardingActivityModerate;

  /// No description provided for @onboardingActivityActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get onboardingActivityActive;

  /// No description provided for @onboardingActivityExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra active'**
  String get onboardingActivityExtra;

  /// No description provided for @onboardingCuisineTitle.
  ///
  /// In en, this message translates to:
  /// **'What foods feel familiar to you?'**
  String get onboardingCuisineTitle;

  /// No description provided for @onboardingCuisineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional. We use this to prioritize familiar foods in search. You can skip this.'**
  String get onboardingCuisineSubtitle;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in settings.'**
  String get onboardingLanguageSubtitle;

  /// No description provided for @onboardingSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your estimated nutrition target'**
  String get onboardingSummaryTitle;

  /// No description provided for @onboardingSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'This is an estimate based on standard equations. Your actual needs may vary, and we can refine this over time using your weight trend.'**
  String get onboardingSummaryBody;

  /// No description provided for @onboardingSummaryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Personalized calorie and macro targets will be calculated in a later step.'**
  String get onboardingSummaryComingSoon;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashboardGreetingEvening;

  /// No description provided for @dashboardToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardToday;

  /// No description provided for @dashboardCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get dashboardCalories;

  /// No description provided for @dashboardProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get dashboardProtein;

  /// No description provided for @dashboardCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get dashboardCarbs;

  /// No description provided for @dashboardFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get dashboardFat;

  /// No description provided for @dashboardFibre.
  ///
  /// In en, this message translates to:
  /// **'Fibre'**
  String get dashboardFibre;

  /// No description provided for @dashboardLogFood.
  ///
  /// In en, this message translates to:
  /// **'Log food'**
  String get dashboardLogFood;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Search for a food to start tracking your day.'**
  String get dashboardEmptyBody;

  /// No description provided for @dashboardTargetsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Targets will be set up after onboarding.'**
  String get dashboardTargetsPlaceholder;

  /// No description provided for @diaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diaryTitle;

  /// No description provided for @diaryMealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get diaryMealBreakfast;

  /// No description provided for @diaryMealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get diaryMealLunch;

  /// No description provided for @diaryMealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get diaryMealDinner;

  /// No description provided for @diaryMealSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get diaryMealSnacks;

  /// No description provided for @diaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get diaryEmpty;

  /// No description provided for @diaryAddToMeal.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get diaryAddToMeal;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search for foods like roti, jollof rice, dal or mango.'**
  String get searchEmpty;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results yet. Food search will be available in a later milestone.'**
  String get searchNoResults;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecent;

  /// No description provided for @searchFrequent.
  ///
  /// In en, this message translates to:
  /// **'Frequent'**
  String get searchFrequent;

  /// No description provided for @searchFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get searchFavourites;

  /// No description provided for @searchMyRecipes.
  ///
  /// In en, this message translates to:
  /// **'My recipes'**
  String get searchMyRecipes;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageEs;

  /// No description provided for @settingsLanguageHi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get settingsLanguageHi;

  /// No description provided for @settingsLanguagePa.
  ///
  /// In en, this message translates to:
  /// **'ਪੰਜਾਬੀ'**
  String get settingsLanguagePa;

  /// No description provided for @settingsLanguageAr.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsLanguageAr;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Nutrivoya'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Nutrivoya is a multilingual, culturally intelligent nutrition and calorie-tracking app that helps people understand and improve the food they actually eat — without telling them that health requires abandoning their culture.'**
  String get settingsAboutBody;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get settingsGoals;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get settingsComingSoon;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get profileGoal;

  /// No description provided for @profileActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get profileActivity;

  /// No description provided for @profileCuisines.
  ///
  /// In en, this message translates to:
  /// **'Familiar cuisines'**
  String get profileCuisines;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition goals'**
  String get goalsTitle;

  /// No description provided for @goalsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get goalsNotSet;

  /// No description provided for @goalsCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Calorie target'**
  String get goalsCalorieTarget;

  /// No description provided for @goalsProteinTarget.
  ///
  /// In en, this message translates to:
  /// **'Protein target'**
  String get goalsProteinTarget;

  /// No description provided for @goalsCarbTarget.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate target'**
  String get goalsCarbTarget;

  /// No description provided for @goalsFatTarget.
  ///
  /// In en, this message translates to:
  /// **'Fat target'**
  String get goalsFatTarget;

  /// No description provided for @goalsFibreTarget.
  ///
  /// In en, this message translates to:
  /// **'Fibre target'**
  String get goalsFibreTarget;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimate confidence'**
  String get confidenceLabel;

  /// No description provided for @confidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get confidenceHigh;

  /// No description provided for @confidenceHighNote.
  ///
  /// In en, this message translates to:
  /// **'Official food-composition data'**
  String get confidenceHighNote;

  /// No description provided for @confidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get confidenceMedium;

  /// No description provided for @confidenceMediumNote.
  ///
  /// In en, this message translates to:
  /// **'Calculated from a standardized recipe'**
  String get confidenceMediumNote;

  /// No description provided for @confidenceEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get confidenceEstimated;

  /// No description provided for @confidenceEstimatedNote.
  ///
  /// In en, this message translates to:
  /// **'Based on common ingredients and portion size'**
  String get confidenceEstimatedNote;

  /// No description provided for @confidenceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get confidenceUnknown;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @sourceAuthoritative.
  ///
  /// In en, this message translates to:
  /// **'Authoritative food-composition dataset'**
  String get sourceAuthoritative;

  /// No description provided for @sourcePackaged.
  ///
  /// In en, this message translates to:
  /// **'Packaged-food database'**
  String get sourcePackaged;

  /// No description provided for @sourceNutrivoyaCurated.
  ///
  /// In en, this message translates to:
  /// **'Nutrivoya curated dataset'**
  String get sourceNutrivoyaCurated;

  /// No description provided for @sourceRecipeEstimated.
  ///
  /// In en, this message translates to:
  /// **'Recipe-based estimate'**
  String get sourceRecipeEstimated;

  /// No description provided for @sourceUserSubmitted.
  ///
  /// In en, this message translates to:
  /// **'User-submitted'**
  String get sourceUserSubmitted;

  /// No description provided for @portionLabel.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get portionLabel;

  /// No description provided for @portionSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get portionSmall;

  /// No description provided for @portionMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get portionMedium;

  /// No description provided for @portionLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get portionLarge;

  /// No description provided for @portionGrams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get portionGrams;

  /// No description provided for @portionQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get portionQuantity;

  /// No description provided for @portionCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom grams'**
  String get portionCustom;

  /// No description provided for @nutrientEnergyKcal.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get nutrientEnergyKcal;

  /// No description provided for @nutrientProteinG.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutrientProteinG;

  /// No description provided for @nutrientCarbohydrateG.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get nutrientCarbohydrateG;

  /// No description provided for @nutrientFatG.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutrientFatG;

  /// No description provided for @nutrientFibreG.
  ///
  /// In en, this message translates to:
  /// **'Fibre'**
  String get nutrientFibreG;

  /// No description provided for @nutrientSaturatedFatG.
  ///
  /// In en, this message translates to:
  /// **'Saturated fat'**
  String get nutrientSaturatedFatG;

  /// No description provided for @nutrientSugarG.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get nutrientSugarG;

  /// No description provided for @nutrientSodiumMg.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get nutrientSodiumMg;

  /// No description provided for @nutrientIronMg.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get nutrientIronMg;

  /// No description provided for @nutrientCalciumMg.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get nutrientCalciumMg;

  /// No description provided for @nutrientPotassiumMg.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get nutrientPotassiumMg;

  /// No description provided for @nutrientMagnesiumMg.
  ///
  /// In en, this message translates to:
  /// **'Magnesium'**
  String get nutrientMagnesiumMg;

  /// No description provided for @nutrientZincMg.
  ///
  /// In en, this message translates to:
  /// **'Zinc'**
  String get nutrientZincMg;

  /// No description provided for @nutrientVitaminAUg.
  ///
  /// In en, this message translates to:
  /// **'Vitamin A'**
  String get nutrientVitaminAUg;

  /// No description provided for @nutrientVitaminCMg.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C'**
  String get nutrientVitaminCMg;

  /// No description provided for @nutrientVitaminDUg.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D'**
  String get nutrientVitaminDUg;

  /// No description provided for @nutrientVitaminB12Ug.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B12'**
  String get nutrientVitaminB12Ug;

  /// No description provided for @nutrientFolateUg.
  ///
  /// In en, this message translates to:
  /// **'Folate'**
  String get nutrientFolateUg;

  /// No description provided for @foodDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Food details'**
  String get foodDetailsTitle;

  /// No description provided for @foodDetailsAddToMeal.
  ///
  /// In en, this message translates to:
  /// **'Add to meal'**
  String get foodDetailsAddToMeal;

  /// No description provided for @foodDetailsPerPortion.
  ///
  /// In en, this message translates to:
  /// **'per portion'**
  String get foodDetailsPerPortion;

  /// No description provided for @foodDetailsPer100g.
  ///
  /// In en, this message translates to:
  /// **'per 100 g'**
  String get foodDetailsPer100g;

  /// No description provided for @foodDetailsPreparationNote.
  ///
  /// In en, this message translates to:
  /// **'Preparation and serving size can change the values.'**
  String get foodDetailsPreparationNote;

  /// No description provided for @foodDetailsNoData.
  ///
  /// In en, this message translates to:
  /// **'Nutrition data unavailable'**
  String get foodDetailsNoData;

  /// No description provided for @foodDetailsApprox.
  ///
  /// In en, this message translates to:
  /// **'≈'**
  String get foodDetailsApprox;

  /// No description provided for @foodDetailsLoggingSoon.
  ///
  /// In en, this message translates to:
  /// **'Food logging arrives in the next milestone.'**
  String get foodDetailsLoggingSoon;

  /// No description provided for @foodDetailsMacros.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get foodDetailsMacros;

  /// No description provided for @foodDetailsMicronutrients.
  ///
  /// In en, this message translates to:
  /// **'Micronutrients'**
  String get foodDetailsMicronutrients;

  /// No description provided for @foodDetailsCuisine.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get foodDetailsCuisine;

  /// No description provided for @foodDetailsRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get foodDetailsRegion;

  /// No description provided for @foodDetailsAliases.
  ///
  /// In en, this message translates to:
  /// **'Also known as'**
  String get foodDetailsAliases;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String searchResultsCount(int count);

  /// No description provided for @searchTryExample.
  ///
  /// In en, this message translates to:
  /// **'Try: roti, jollof rice, dal, mango'**
  String get searchTryExample;

  /// No description provided for @diaryAddToMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to which meal?'**
  String get diaryAddToMealTitle;

  /// No description provided for @diaryEntryAdded.
  ///
  /// In en, this message translates to:
  /// **'{food} added to {meal}'**
  String diaryEntryAdded(String food, String meal);

  /// No description provided for @diaryEntryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get diaryEntryDeleted;

  /// No description provided for @diaryEntryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Entry updated'**
  String get diaryEntryUpdated;

  /// No description provided for @diaryEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get diaryEditEntry;

  /// No description provided for @diaryDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get diaryDeleteEntry;

  /// No description provided for @diaryConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove this entry from your diary?'**
  String get diaryConfirmDelete;

  /// No description provided for @diaryConfirmDeleteYes.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get diaryConfirmDeleteYes;

  /// No description provided for @diaryGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get diaryGramsLabel;

  /// No description provided for @diaryQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get diaryQuantityLabel;

  /// No description provided for @diaryNoEntriesForMeal.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get diaryNoEntriesForMeal;

  /// No description provided for @diaryKcalShort.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get diaryKcalShort;

  /// No description provided for @diarySelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get diarySelectDate;

  /// No description provided for @diaryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get diaryToday;

  /// No description provided for @diaryYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get diaryYesterday;

  /// No description provided for @diaryEntryCalories.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal'**
  String diaryEntryCalories(int kcal);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'hi',
    'pa',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pa':
      return AppLocalizationsPa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
