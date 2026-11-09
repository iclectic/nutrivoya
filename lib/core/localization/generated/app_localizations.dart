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

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

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

  /// No description provided for @onboardingSummaryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Estimated maintenance: {kcal} kcal/day'**
  String onboardingSummaryMaintenance(int kcal);

  /// No description provided for @onboardingSummaryTarget.
  ///
  /// In en, this message translates to:
  /// **'Suggested daily target: {kcal} kcal'**
  String onboardingSummaryTarget(int kcal);

  /// No description provided for @onboardingSummaryMacros.
  ///
  /// In en, this message translates to:
  /// **'Protein {protein} g · Carbs {carbs} g · Fat {fat} g · Fibre {fibre} g'**
  String onboardingSummaryMacros(int protein, int carbs, int fat, int fibre);

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

  /// No description provided for @dashboardCaloriesOf.
  ///
  /// In en, this message translates to:
  /// **'{consumed} / {target} kcal'**
  String dashboardCaloriesOf(int consumed, int target);

  /// No description provided for @dashboardCaloriesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal remaining'**
  String dashboardCaloriesRemaining(int kcal);

  /// No description provided for @dashboardCaloriesOver.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal over target'**
  String dashboardCaloriesOver(int kcal);

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
  /// **'No matching foods found. Try another name, alias or spelling.'**
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

  /// No description provided for @goalsBmr.
  ///
  /// In en, this message translates to:
  /// **'Estimated BMR'**
  String get goalsBmr;

  /// No description provided for @goalsTdee.
  ///
  /// In en, this message translates to:
  /// **'Estimated maintenance (TDEE)'**
  String get goalsTdee;

  /// No description provided for @goalsNeedProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete onboarding to see personalized targets.'**
  String get goalsNeedProfile;

  /// No description provided for @goalsEstimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Calculated expenditure is an estimate. Your actual needs may vary.'**
  String get goalsEstimateDisclaimer;

  /// No description provided for @goalsRefineOverTime.
  ///
  /// In en, this message translates to:
  /// **'We can refine this estimate over time using your weight trend.'**
  String get goalsRefineOverTime;

  /// No description provided for @energyNoteEstimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Calculated expenditure is an estimate. Your actual needs may vary.'**
  String get energyNoteEstimateDisclaimer;

  /// No description provided for @energyNotePhysiologicalUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Without a physiological calculation input, we averaged standard equations. Confidence is lower.'**
  String get energyNotePhysiologicalUnspecified;

  /// No description provided for @energyNoteAgeOutsideAdultRange.
  ///
  /// In en, this message translates to:
  /// **'Energy equations are less reliable outside typical adult ages. Consider professional guidance.'**
  String get energyNoteAgeOutsideAdultRange;

  /// No description provided for @energyNoteLoseWhileLowWeight.
  ///
  /// In en, this message translates to:
  /// **'Your profile suggests a low body weight. Aggressive weight loss is not recommended — please seek qualified support if needed.'**
  String get energyNoteLoseWhileLowWeight;

  /// No description provided for @energyNoteDeficitCapped.
  ///
  /// In en, this message translates to:
  /// **'We limited the calorie deficit to a safer rate. Crash dieting is not supported.'**
  String get energyNoteDeficitCapped;

  /// No description provided for @energyNoteFloorApplied.
  ///
  /// In en, this message translates to:
  /// **'Your target was raised to a minimum energy intake for safety.'**
  String get energyNoteFloorApplied;

  /// No description provided for @energyNoteTrackOnly.
  ///
  /// In en, this message translates to:
  /// **'You chose to track food only. The numbers below are maintenance estimates for reference.'**
  String get energyNoteTrackOnly;

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

  /// No description provided for @recipesTitle.
  ///
  /// In en, this message translates to:
  /// **'My recipes'**
  String get recipesTitle;

  /// No description provided for @recipesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create recipe'**
  String get recipesCreate;

  /// No description provided for @recipesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get recipesEdit;

  /// No description provided for @recipesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No personal recipes yet'**
  String get recipesEmptyTitle;

  /// No description provided for @recipesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save family recipes like Mum\'s jollof or Grandma\'s dal so you can log the versions you actually cook.'**
  String get recipesEmptyBody;

  /// No description provided for @recipesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipe name'**
  String get recipesNameLabel;

  /// No description provided for @recipesServingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get recipesServingsLabel;

  /// No description provided for @recipesYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Total yield (g)'**
  String get recipesYieldLabel;

  /// No description provided for @recipesYieldHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — defaults to ingredient sum'**
  String get recipesYieldHint;

  /// No description provided for @recipesIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipesIngredients;

  /// No description provided for @recipesIngredientsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients to calculate nutrition.'**
  String get recipesIngredientsEmpty;

  /// No description provided for @recipesAddIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get recipesAddIngredient;

  /// No description provided for @recipesNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get recipesNotesLabel;

  /// No description provided for @recipesCalculatedNutrition.
  ///
  /// In en, this message translates to:
  /// **'Calculated nutrition'**
  String get recipesCalculatedNutrition;

  /// No description provided for @recipesWholeRecipeKcal.
  ///
  /// In en, this message translates to:
  /// **'Whole recipe: ≈ {kcal} kcal'**
  String recipesWholeRecipeKcal(int kcal);

  /// No description provided for @recipesPerServingKcal.
  ///
  /// In en, this message translates to:
  /// **'≈ {kcal} kcal per serving'**
  String recipesPerServingKcal(int kcal);

  /// No description provided for @recipesServingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 serving} other{{count} servings}}'**
  String recipesServingsCount(int count);

  /// No description provided for @recipesPerServingShort.
  ///
  /// In en, this message translates to:
  /// **'serving'**
  String get recipesPerServingShort;

  /// No description provided for @recipesCalculationNote.
  ///
  /// In en, this message translates to:
  /// **'Calculated from your ingredients and quantities. Preparation and yield can change the values.'**
  String get recipesCalculationNote;

  /// No description provided for @recipesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe?'**
  String get recipesDeleteTitle;

  /// No description provided for @recipesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the recipe from your personal collection. Diary entries already logged are not affected.'**
  String get recipesDeleteBody;

  /// No description provided for @barcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get barcodeTitle;

  /// No description provided for @barcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a packaged-food barcode, or enter the number manually.'**
  String get barcodeHint;

  /// No description provided for @barcodeManualLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode number'**
  String get barcodeManualLabel;

  /// No description provided for @barcodeManualHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3017620422003'**
  String get barcodeManualHint;

  /// No description provided for @barcodeLookupButton.
  ///
  /// In en, this message translates to:
  /// **'Look up product'**
  String get barcodeLookupButton;

  /// No description provided for @barcodeCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable on this device. Enter the barcode manually instead.'**
  String get barcodeCameraUnavailable;

  /// No description provided for @barcodeNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get barcodeNotFoundTitle;

  /// No description provided for @barcodeNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'No packaged food matched barcode {barcode}. You can try again or add the food another way.'**
  String barcodeNotFoundBody(String barcode);

  /// No description provided for @barcodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a valid barcode. Use 8–14 digits.'**
  String get barcodeInvalid;

  /// No description provided for @barcodeNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the packaged-food database. Check your connection and try again.'**
  String get barcodeNetworkError;

  /// No description provided for @barcodeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get barcodeTryAgain;

  /// No description provided for @barcodeCrowdsourcedNote.
  ///
  /// In en, this message translates to:
  /// **'Packaged-food data comes from Open Food Facts and may be incomplete or crowdsourced. Always verify the serving size before logging.'**
  String get barcodeCrowdsourcedNote;

  /// No description provided for @assistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask Nutrivoya'**
  String get assistantTitle;

  /// No description provided for @assistantIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask about your meals, cultural staples, protein, or hunger — answers use your diary, targets, and food database. Numbers are never invented.'**
  String get assistantIntro;

  /// No description provided for @assistantWellnessDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Nutrivoya offers general wellness guidance, not medical advice.'**
  String get assistantWellnessDisclaimer;

  /// No description provided for @assistantMedicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This sounds like a medical or high-risk topic. Please speak with a qualified health professional. Nutrivoya cannot diagnose, treat, or prescribe.'**
  String get assistantMedicalDisclaimer;

  /// No description provided for @assistantTryAsking.
  ///
  /// In en, this message translates to:
  /// **'Try asking'**
  String get assistantTryAsking;

  /// No description provided for @assistantSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get assistantSuggestions;

  /// No description provided for @assistantSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get assistantSources;

  /// No description provided for @assistantInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about rice, protein, balance…'**
  String get assistantInputHint;

  /// No description provided for @assistantSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get assistantSend;

  /// No description provided for @assistantClear.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get assistantClear;

  /// No description provided for @assistantPromptRice.
  ///
  /// In en, this message translates to:
  /// **'Can I still eat rice while losing weight?'**
  String get assistantPromptRice;

  /// No description provided for @assistantPromptBalance.
  ///
  /// In en, this message translates to:
  /// **'How can I balance today\'s meals?'**
  String get assistantPromptBalance;

  /// No description provided for @assistantPromptProtein.
  ///
  /// In en, this message translates to:
  /// **'How can I raise protein with familiar foods?'**
  String get assistantPromptProtein;

  /// No description provided for @assistantPromptHunger.
  ///
  /// In en, this message translates to:
  /// **'Why am I still hungry near my calorie target?'**
  String get assistantPromptHunger;

  /// No description provided for @assistantPromptRoti.
  ///
  /// In en, this message translates to:
  /// **'How many calories in roti?'**
  String get assistantPromptRoti;

  /// No description provided for @assistantHeadlineCultural.
  ///
  /// In en, this message translates to:
  /// **'Yes — {staple} can fit your goals'**
  String assistantHeadlineCultural(String staple);

  /// No description provided for @assistantHeadlineBalance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s meal balance'**
  String get assistantHeadlineBalance;

  /// No description provided for @assistantHeadlineProtein.
  ///
  /// In en, this message translates to:
  /// **'Raising protein with familiar foods'**
  String get assistantHeadlineProtein;

  /// No description provided for @assistantHeadlineHunger.
  ///
  /// In en, this message translates to:
  /// **'Hunger near your calorie target'**
  String get assistantHeadlineHunger;

  /// No description provided for @assistantHeadlineLookupFound.
  ///
  /// In en, this message translates to:
  /// **'Nutrition for {foodName}'**
  String assistantHeadlineLookupFound(String foodName);

  /// No description provided for @assistantHeadlineLookupMissing.
  ///
  /// In en, this message translates to:
  /// **'No match for “{foodName}”'**
  String assistantHeadlineLookupMissing(String foodName);

  /// No description provided for @assistantHeadlineSubstitute.
  ///
  /// In en, this message translates to:
  /// **'Modify before you replace'**
  String get assistantHeadlineSubstitute;

  /// No description provided for @assistantHeadlineMedical.
  ///
  /// In en, this message translates to:
  /// **'Please seek professional guidance'**
  String get assistantHeadlineMedical;

  /// No description provided for @assistantHeadlineUnknown.
  ///
  /// In en, this message translates to:
  /// **'I need a clearer question'**
  String get assistantHeadlineUnknown;

  /// No description provided for @assistantBodyCultural.
  ///
  /// In en, this message translates to:
  /// **'{staple} is a normal part of {cuisine} eating. You do not need to abandon it — adjust portions and pairings to match your goal.'**
  String assistantBodyCultural(String staple, String cuisine);

  /// No description provided for @assistantBodyCulturalWithData.
  ///
  /// In en, this message translates to:
  /// **'{staple} can stay in your pattern. From the food database, {foodName} ({portionName}) is about {kcal} kcal ({sourceName}). Prefer a smaller portion or add vegetables and a protein side rather than cutting the staple entirely.'**
  String assistantBodyCulturalWithData(
    String staple,
    String foodName,
    String portionName,
    int kcal,
    String sourceName,
  );

  /// No description provided for @assistantBodyBalanceWithTargets.
  ///
  /// In en, this message translates to:
  /// **'Today you have logged {caloriesConsumed} of {calorieTarget} kcal and {proteinConsumed} of {proteinTarget} g protein across {entryCount} entries. Use familiar foods and small adjustments — not food moralising.'**
  String assistantBodyBalanceWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int proteinTarget,
    int entryCount,
  );

  /// No description provided for @assistantBodyBalanceNoTargets.
  ///
  /// In en, this message translates to:
  /// **'Today you have logged {caloriesConsumed} kcal and {proteinConsumed} g protein across {entryCount} entries. Set goals in Settings for clearer targets, or keep logging familiar meals.'**
  String assistantBodyBalanceNoTargets(
    int caloriesConsumed,
    int proteinConsumed,
    int entryCount,
  );

  /// No description provided for @assistantBodyProteinWithTargets.
  ///
  /// In en, this message translates to:
  /// **'You have logged {proteinConsumed} of {proteinTarget} g protein today ({proteinGap} g to go). Keep {cuisine} staples and add protein-rich sides.'**
  String assistantBodyProteinWithTargets(
    int proteinConsumed,
    int proteinTarget,
    int proteinGap,
    String cuisine,
  );

  /// No description provided for @assistantBodyProtein.
  ///
  /// In en, this message translates to:
  /// **'You have logged {proteinConsumed} g protein today. Raise it with familiar {cuisine} pairings rather than replacing your usual meals.'**
  String assistantBodyProtein(int proteinConsumed, String cuisine);

  /// No description provided for @assistantBodyHungerWithTargets.
  ///
  /// In en, this message translates to:
  /// **'You are at {caloriesConsumed} of {calorieTarget} kcal, with {proteinConsumed} g protein and {fibreConsumed} g fibre logged. Hunger can reflect protein, fibre, meal timing, or water — not a moral failure.'**
  String assistantBodyHungerWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int fibreConsumed,
  );

  /// No description provided for @assistantBodyHunger.
  ///
  /// In en, this message translates to:
  /// **'You have logged {caloriesConsumed} kcal, {proteinConsumed} g protein and {fibreConsumed} g fibre today. Hunger often improves with protein, fibre, and slower eating — not by labelling foods as bad.'**
  String assistantBodyHunger(
    int caloriesConsumed,
    int proteinConsumed,
    int fibreConsumed,
  );

  /// No description provided for @assistantBodyLookupFound.
  ///
  /// In en, this message translates to:
  /// **'{foodName} · {portionName}: ≈ {kcal} kcal and {proteinG} g protein. Source: {sourceName}. Confidence: {confidence}.'**
  String assistantBodyLookupFound(
    String foodName,
    String portionName,
    int kcal,
    int proteinG,
    String sourceName,
    String confidence,
  );

  /// No description provided for @assistantBodyLookupNoNutrition.
  ///
  /// In en, this message translates to:
  /// **'{foodName} was found in {sourceName}, but reliable calorie data is unavailable. Nutrivoya will not invent a number.'**
  String assistantBodyLookupNoNutrition(String foodName, String sourceName);

  /// No description provided for @assistantBodyLookupMissing.
  ///
  /// In en, this message translates to:
  /// **'No structured food matched “{foodName}”. Try another name, a barcode, or add a personal recipe — calories will not be guessed.'**
  String assistantBodyLookupMissing(String foodName);

  /// No description provided for @assistantBodySubstitute.
  ///
  /// In en, this message translates to:
  /// **'Start by changing portion size, adding vegetables, or pairing a protein side with the food you already eat. Replacement is optional — modification usually keeps cultural meals intact.'**
  String get assistantBodySubstitute;

  /// No description provided for @assistantBodyMedical.
  ///
  /// In en, this message translates to:
  /// **'Nutrivoya cannot advise on diagnosis, medications, pregnancy complications, eating disorders, or other clinical situations. Please consult an appropriate professional.'**
  String get assistantBodyMedical;

  /// No description provided for @assistantBodyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Try questions like “Can I still eat rice?”, “How do I raise protein?”, “How many calories in roti?”, or “Why am I still hungry?”'**
  String get assistantBodyUnknown;

  /// No description provided for @assistantTipAskRice.
  ///
  /// In en, this message translates to:
  /// **'Ask whether a cultural staple can fit your goals'**
  String get assistantTipAskRice;

  /// No description provided for @assistantTipAskBalance.
  ///
  /// In en, this message translates to:
  /// **'Ask how today\'s logged meals look against your targets'**
  String get assistantTipAskBalance;

  /// No description provided for @assistantTipAskProtein.
  ///
  /// In en, this message translates to:
  /// **'Ask how to raise protein with familiar foods'**
  String get assistantTipAskProtein;

  /// No description provided for @assistantTipAskFoodLookup.
  ///
  /// In en, this message translates to:
  /// **'Ask “calories in …” for a food in the database'**
  String get assistantTipAskFoodLookup;

  /// No description provided for @assistantTipSeekProfessional.
  ///
  /// In en, this message translates to:
  /// **'Contact a doctor, dietitian, or other qualified clinician'**
  String get assistantTipSeekProfessional;

  /// No description provided for @assistantTipFoodNotFound.
  ///
  /// In en, this message translates to:
  /// **'Try a different spelling, alias, or barcode scan'**
  String get assistantTipFoodNotFound;

  /// No description provided for @assistantTipNutritionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Nutrition data unavailable — no invented calories'**
  String get assistantTipNutritionUnavailable;

  /// No description provided for @assistantTipVerifyPortion.
  ///
  /// In en, this message translates to:
  /// **'Confirm the portion matches what you ate before logging'**
  String get assistantTipVerifyPortion;

  /// No description provided for @assistantTipNoMoralFood.
  ///
  /// In en, this message translates to:
  /// **'No food is inherently good or bad — context and pattern matter'**
  String get assistantTipNoMoralFood;

  /// No description provided for @assistantTipHungerProteinFibre.
  ///
  /// In en, this message translates to:
  /// **'Check protein and fibre — both support fullness'**
  String get assistantTipHungerProteinFibre;

  /// No description provided for @assistantTipHungerPace.
  ///
  /// In en, this message translates to:
  /// **'Eat a little slower and include volume foods like vegetables'**
  String get assistantTipHungerPace;

  /// No description provided for @assistantTipProteinPairDal.
  ///
  /// In en, this message translates to:
  /// **'Pair grains with dal, beans, or lentils'**
  String get assistantTipProteinPairDal;

  /// No description provided for @assistantTipProteinPairYoghurt.
  ///
  /// In en, this message translates to:
  /// **'Add yoghurt, paneer, or strained dairy on the side'**
  String get assistantTipProteinPairYoghurt;

  /// No description provided for @assistantTipProteinPairEgg.
  ///
  /// In en, this message translates to:
  /// **'Add egg, fish, tofu, or lean meat when it fits your cuisine'**
  String get assistantTipProteinPairEgg;

  /// No description provided for @assistantTipModifyNotReplace.
  ///
  /// In en, this message translates to:
  /// **'Modify the meal you already like before replacing it'**
  String get assistantTipModifyNotReplace;

  /// No description provided for @assistantTipModifyPortion.
  ///
  /// In en, this message translates to:
  /// **'Try a smaller serving of the staple first'**
  String get assistantTipModifyPortion;

  /// No description provided for @assistantTipAddVegetables.
  ///
  /// In en, this message translates to:
  /// **'Add vegetables or salad for volume and fibre'**
  String get assistantTipAddVegetables;

  /// No description provided for @assistantTipAddProteinSide.
  ///
  /// In en, this message translates to:
  /// **'Add a protein-rich side rather than cutting the staple'**
  String get assistantTipAddProteinSide;

  /// No description provided for @assistantTipLogSomething.
  ///
  /// In en, this message translates to:
  /// **'Log a meal so balance advice can use your real pattern'**
  String get assistantTipLogSomething;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @progressIntro.
  ///
  /// In en, this message translates to:
  /// **'Track weight, water and measurements as calm trends — day-to-day changes are noise, not a verdict.'**
  String get progressIntro;

  /// No description provided for @progressWater.
  ///
  /// In en, this message translates to:
  /// **'Water today'**
  String get progressWater;

  /// No description provided for @progressWaterTotal.
  ///
  /// In en, this message translates to:
  /// **'{total} ml of {goal} ml'**
  String progressWaterTotal(int total, int goal);

  /// No description provided for @progressWaterAdd.
  ///
  /// In en, this message translates to:
  /// **'+{ml} ml'**
  String progressWaterAdd(int ml);

  /// No description provided for @progressWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get progressWeight;

  /// No description provided for @progressLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get progressLogWeight;

  /// No description provided for @progressWeightKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get progressWeightKgLabel;

  /// No description provided for @progressWeightValue.
  ///
  /// In en, this message translates to:
  /// **'{kg} kg'**
  String progressWeightValue(String kg);

  /// No description provided for @progressWeightEmpty.
  ///
  /// In en, this message translates to:
  /// **'No weight logs yet. Add a few over days to see a calm trend.'**
  String get progressWeightEmpty;

  /// No description provided for @progressWeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a plausible weight between 20 and 400 kg.'**
  String get progressWeightInvalid;

  /// No description provided for @progressTrendNote.
  ///
  /// In en, this message translates to:
  /// **'Trends use a multi-day average. Single-day changes are expected and not judged.'**
  String get progressTrendNote;

  /// No description provided for @progressTrendInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Log weight on a few more days to estimate a weekly trend.'**
  String get progressTrendInsufficient;

  /// No description provided for @progressTrendSteady.
  ///
  /// In en, this message translates to:
  /// **'Around {avg} kg — roughly steady over recent days.'**
  String progressTrendSteady(String avg);

  /// No description provided for @progressTrendRising.
  ///
  /// In en, this message translates to:
  /// **'Around {avg} kg — gently rising (~{delta} kg/week). Focus on patterns, not one day.'**
  String progressTrendRising(String avg, String delta);

  /// No description provided for @progressTrendFalling.
  ///
  /// In en, this message translates to:
  /// **'Around {avg} kg — gently falling (~{delta} kg/week). Focus on patterns, not one day.'**
  String progressTrendFalling(String avg, String delta);

  /// No description provided for @progressMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get progressMeasurements;

  /// No description provided for @progressMeasurementsNote.
  ///
  /// In en, this message translates to:
  /// **'Optional waist and hip in centimetres. These are not used for calorie targets.'**
  String get progressMeasurementsNote;

  /// No description provided for @progressMeasurementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No measurements logged yet.'**
  String get progressMeasurementsEmpty;

  /// No description provided for @progressLogMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Log measurement'**
  String get progressLogMeasurement;

  /// No description provided for @progressWaistLabel.
  ///
  /// In en, this message translates to:
  /// **'Waist (cm)'**
  String get progressWaistLabel;

  /// No description provided for @progressHipLabel.
  ///
  /// In en, this message translates to:
  /// **'Hip (cm)'**
  String get progressHipLabel;

  /// No description provided for @progressWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist {cm} cm'**
  String progressWaist(String cm);

  /// No description provided for @progressHip.
  ///
  /// In en, this message translates to:
  /// **'Hip {cm} cm'**
  String progressHip(String cm);

  /// No description provided for @progressMeasurementInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one measurement.'**
  String get progressMeasurementInvalid;

  /// No description provided for @favouritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favouritesTitle;

  /// No description provided for @favouritesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get favouritesAdd;

  /// No description provided for @favouritesRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get favouritesRemove;

  /// No description provided for @frequentFoodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequent foods'**
  String get frequentFoodsTitle;

  /// No description provided for @frequentFoodsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Foods you log often will appear here.'**
  String get frequentFoodsEmpty;

  /// No description provided for @frequentFoodsCount.
  ///
  /// In en, this message translates to:
  /// **'Logged {count} times'**
  String frequentFoodsCount(int count);

  /// No description provided for @templatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal templates'**
  String get templatesTitle;

  /// No description provided for @templatesIntro.
  ///
  /// In en, this message translates to:
  /// **'Save a day\'s familiar meals and re-apply them later — useful for usual breakfasts and family patterns.'**
  String get templatesIntro;

  /// No description provided for @templatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No templates yet. Log a day you like, then save it as a template.'**
  String get templatesEmpty;

  /// No description provided for @templatesSaveFromToday.
  ///
  /// In en, this message translates to:
  /// **'Save from today'**
  String get templatesSaveFromToday;

  /// No description provided for @templatesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get templatesNameLabel;

  /// No description provided for @templatesNeedEntries.
  ///
  /// In en, this message translates to:
  /// **'Log some foods today before saving a template.'**
  String get templatesNeedEntries;

  /// No description provided for @templatesSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved'**
  String get templatesSaved;

  /// No description provided for @templatesApply.
  ///
  /// In en, this message translates to:
  /// **'Apply to today'**
  String get templatesApply;

  /// No description provided for @templatesApplied.
  ///
  /// In en, this message translates to:
  /// **'Added {count} items from the template'**
  String templatesApplied(int count);

  /// No description provided for @templatesTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{count} diary entries available to save'**
  String templatesTodayCount(int count);

  /// No description provided for @templatesItemSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} items · ≈ {kcal} kcal'**
  String templatesItemSummary(int count, int kcal);

  /// No description provided for @photoTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo meal'**
  String get photoTitle;

  /// No description provided for @photoIntro.
  ///
  /// In en, this message translates to:
  /// **'Photograph a meal, describe what you see, then confirm a food from the database. Nutrition always comes from structured food data — never from the image alone.'**
  String get photoIntro;

  /// No description provided for @photoUncertaintyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Photo suggestions are uncertain. Always confirm the food and portion before logging. Computer vision estimates are never treated as certain.'**
  String get photoUncertaintyDisclaimer;

  /// No description provided for @photoTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get photoTakePhoto;

  /// No description provided for @photoChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoChooseGallery;

  /// No description provided for @photoRetake.
  ///
  /// In en, this message translates to:
  /// **'Choose a different photo'**
  String get photoRetake;

  /// No description provided for @photoClear.
  ///
  /// In en, this message translates to:
  /// **'Clear photo'**
  String get photoClear;

  /// No description provided for @photoDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you see?'**
  String get photoDescriptionLabel;

  /// No description provided for @photoDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. roti and dal, jollof rice, bowl of pho'**
  String get photoDescriptionHint;

  /// No description provided for @photoSuggestFoods.
  ///
  /// In en, this message translates to:
  /// **'Suggest foods'**
  String get photoSuggestFoods;

  /// No description provided for @photoSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible matches'**
  String get photoSuggestionsTitle;

  /// No description provided for @photoSuggestionsNote.
  ///
  /// In en, this message translates to:
  /// **'These come from your description searched in the food database — not invented calories from the photo.'**
  String get photoSuggestionsNote;

  /// No description provided for @photoConfidenceUncertain.
  ///
  /// In en, this message translates to:
  /// **'Uncertain match — confirm'**
  String get photoConfidenceUncertain;

  /// No description provided for @photoConfidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Weak match — check carefully'**
  String get photoConfidenceLow;

  /// No description provided for @photoPortionTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate portion'**
  String get photoPortionTitle;

  /// No description provided for @photoPortionNote.
  ///
  /// In en, this message translates to:
  /// **'Portion from the photo is only an estimate. Adjust before logging.'**
  String get photoPortionNote;

  /// No description provided for @photoConfirmOpenFood.
  ///
  /// In en, this message translates to:
  /// **'Confirm and open food'**
  String get photoConfirmOpenFood;

  /// No description provided for @photoConfirmNote.
  ///
  /// In en, this message translates to:
  /// **'Next you will verify serving size on the food details screen. Logging uses structured nutrition only.'**
  String get photoConfirmNote;

  /// No description provided for @photoDetailsEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Portion was suggested from a meal photo and is uncertain — verify grams before logging.'**
  String get photoDetailsEstimateNote;

  /// No description provided for @photoSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photograph a meal, then confirm a food from the database.'**
  String get photoSearchSubtitle;

  /// No description provided for @photoErrorNoImage.
  ///
  /// In en, this message translates to:
  /// **'Add a photo first.'**
  String get photoErrorNoImage;

  /// No description provided for @photoErrorNeedDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe what you see so Nutrivoya can search the food database. The app will not invent foods from pixels alone.'**
  String get photoErrorNeedDescription;

  /// No description provided for @photoErrorNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No structured foods matched that description. Try another name or search manually.'**
  String get photoErrorNoMatches;

  /// No description provided for @photoErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not use that photo. Try again or pick another image.'**
  String get photoErrorFailed;

  /// No description provided for @addProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProductTitle;

  /// No description provided for @addProductIntro.
  ///
  /// In en, this message translates to:
  /// **'Submit a missing food or packaged product for your personal library. Values you enter are never treated as authoritative.'**
  String get addProductIntro;

  /// No description provided for @addProductProvenanceNote.
  ///
  /// In en, this message translates to:
  /// **'Leave nutrition blank when unknown. Nutrivoya will not invent calories or macros.'**
  String get addProductProvenanceNote;

  /// No description provided for @addProductNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product or food name'**
  String get addProductNameLabel;

  /// No description provided for @addProductBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Brand (optional)'**
  String get addProductBrandLabel;

  /// No description provided for @addProductBarcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode (optional)'**
  String get addProductBarcodeLabel;

  /// No description provided for @addProductCuisineLabel.
  ///
  /// In en, this message translates to:
  /// **'Cuisine or region (optional)'**
  String get addProductCuisineLabel;

  /// No description provided for @addProductServingSection.
  ///
  /// In en, this message translates to:
  /// **'Serving'**
  String get addProductServingSection;

  /// No description provided for @addProductServingGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Default serving (grams)'**
  String get addProductServingGramsLabel;

  /// No description provided for @addProductPortionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Portion name (optional)'**
  String get addProductPortionNameLabel;

  /// No description provided for @addProductNutritionSection.
  ///
  /// In en, this message translates to:
  /// **'Nutrition per 100 g (optional)'**
  String get addProductNutritionSection;

  /// No description provided for @addProductNutritionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter only values you know from a label or trusted source. Leave fields empty rather than guessing.'**
  String get addProductNutritionHint;

  /// No description provided for @addProductEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy (kcal / 100 g)'**
  String get addProductEnergyLabel;

  /// No description provided for @addProductProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein (g / 100 g)'**
  String get addProductProteinLabel;

  /// No description provided for @addProductCarbLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate (g / 100 g)'**
  String get addProductCarbLabel;

  /// No description provided for @addProductFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat (g / 100 g)'**
  String get addProductFatLabel;

  /// No description provided for @addProductFibreLabel.
  ///
  /// In en, this message translates to:
  /// **'Fibre (g / 100 g)'**
  String get addProductFibreLabel;

  /// No description provided for @addProductNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get addProductNotesLabel;

  /// No description provided for @addProductSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save to my library'**
  String get addProductSubmit;

  /// No description provided for @addProductSubmitNote.
  ///
  /// In en, this message translates to:
  /// **'Saved as user-submitted with pending review. It appears in your search only — not as verified nutrition.'**
  String get addProductSubmitNote;

  /// No description provided for @addProductPublished.
  ///
  /// In en, this message translates to:
  /// **'Saved to your personal library (pending review)'**
  String get addProductPublished;

  /// No description provided for @addProductErrorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a product or food name.'**
  String get addProductErrorNameRequired;

  /// No description provided for @addProductErrorNameShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short.'**
  String get addProductErrorNameShort;

  /// No description provided for @addProductErrorServingInvalid.
  ///
  /// In en, this message translates to:
  /// **'Serving must be between 0 and 5000 grams.'**
  String get addProductErrorServingInvalid;

  /// No description provided for @addProductErrorBarcodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Barcode should be 8–14 digits.'**
  String get addProductErrorBarcodeInvalid;

  /// No description provided for @addProductErrorEnergyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Energy must be between 0 and 950 kcal per 100 g.'**
  String get addProductErrorEnergyInvalid;

  /// No description provided for @addProductErrorProteinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Protein must be between 0 and 1000 g per 100 g.'**
  String get addProductErrorProteinInvalid;

  /// No description provided for @addProductErrorCarbInvalid.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate must be between 0 and 1000 g per 100 g.'**
  String get addProductErrorCarbInvalid;

  /// No description provided for @addProductErrorFatInvalid.
  ///
  /// In en, this message translates to:
  /// **'Fat must be between 0 and 1000 g per 100 g.'**
  String get addProductErrorFatInvalid;

  /// No description provided for @addProductErrorFibreInvalid.
  ///
  /// In en, this message translates to:
  /// **'Fibre must be between 0 and 1000 g per 100 g.'**
  String get addProductErrorFibreInvalid;

  /// No description provided for @addProductWarningNoNutrition.
  ///
  /// In en, this message translates to:
  /// **'No nutrition entered — food will show as unavailable until you add values.'**
  String get addProductWarningNoNutrition;

  /// No description provided for @addProductWarningNoEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy is missing — macros alone will not show calories.'**
  String get addProductWarningNoEnergy;

  /// No description provided for @addProductWarningMacrosHigh.
  ///
  /// In en, this message translates to:
  /// **'Protein + carbs + fat exceed 110 g per 100 g — check the label.'**
  String get addProductWarningMacrosHigh;

  /// No description provided for @addProductStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get addProductStatusDraft;

  /// No description provided for @addProductStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get addProductStatusPending;

  /// No description provided for @addProductStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'In personal library (pending review)'**
  String get addProductStatusPublished;

  /// No description provided for @addProductStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get addProductStatusWithdrawn;

  /// No description provided for @mySubmissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'My submissions'**
  String get mySubmissionsTitle;

  /// No description provided for @mySubmissionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No submissions yet. Add a missing product from search, barcode, or Settings.'**
  String get mySubmissionsEmpty;

  /// No description provided for @authContinueOffline.
  ///
  /// In en, this message translates to:
  /// **'Continue without an account'**
  String get authContinueOffline;

  /// No description provided for @authOfflineNote.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device only. Accounts and sync are available when Nutrivoya is connected to its backend.'**
  String get authOfflineNote;

  /// No description provided for @settingsSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get settingsSyncNow;

  /// No description provided for @settingsSyncPending.
  ///
  /// In en, this message translates to:
  /// **'{count} changes waiting to sync'**
  String settingsSyncPending(int count);

  /// No description provided for @settingsSyncDone.
  ///
  /// In en, this message translates to:
  /// **'Diary synced'**
  String get settingsSyncDone;

  /// No description provided for @settingsSyncUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sync unavailable — data is stored on this device'**
  String get settingsSyncUnavailable;
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
