// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Nutrivoya';

  @override
  String get appTagline =>
      'Une nutrition qui s\'adapte à votre alimentation, votre culture et votre vie.';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonGetStarted => 'Commencer';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonError => 'Une erreur s\'est produite';

  @override
  String get commonClose => 'Fermer';

  @override
  String get navDashboard => 'Aujourd\'hui';

  @override
  String get navDiary => 'Journal';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navSettings => 'Réglages';

  @override
  String get authLoginTitle => 'Bon retour';

  @override
  String get authLoginSubtitle =>
      'Connectez-vous pour continuer à suivre votre nutrition.';

  @override
  String get authSignupTitle => 'Créer votre compte';

  @override
  String get authSignupSubtitle =>
      'Commencez votre parcours nutritionnel culturellement intelligent.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authEmailHint => 'vous@exemple.com';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authSignupButton => 'Créer un compte';

  @override
  String get authSwitchToSignup => 'Pas encore de compte ? S\'inscrire';

  @override
  String get authSwitchToLogin => 'Déjà un compte ? Se connecter';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authErrorInvalidCredentials => 'E-mail ou mot de passe invalide.';

  @override
  String get authErrorEmailInUse => 'Un compte existe déjà pour cet e-mail.';

  @override
  String get authErrorWeakPassword =>
      'Veuillez choisir un mot de passe plus fort.';

  @override
  String get authErrorGeneric =>
      'Échec de l\'authentification. Veuillez réessayer.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Nutrivoya';

  @override
  String get onboardingWelcomeBody =>
      'Une nutrition qui s\'adapte à votre alimentation, votre culture et votre vie.';

  @override
  String get onboardingGoalTitle =>
      'En quoi souhaitez-vous que Nutrivoya vous aide ?';

  @override
  String get onboardingGoalMaintain => 'Maintenir mon poids';

  @override
  String get onboardingGoalLose => 'Perdre du poids';

  @override
  String get onboardingGoalGain => 'Prendre du poids';

  @override
  String get onboardingGoalBuildMuscle => 'Développer mes muscles';

  @override
  String get onboardingGoalImprove => 'Améliorer ma nutrition';

  @override
  String get onboardingGoalTrack => 'Suivre simplement ce que je mange';

  @override
  String get onboardingProfileTitle => 'Parlez-nous de vous';

  @override
  String get onboardingProfileSubtitle =>
      'Nous utilisons ces informations uniquement pour estimer vos besoins nutritionnels. Vous pourrez les modifier plus tard.';

  @override
  String get onboardingAgeLabel => 'Âge';

  @override
  String get onboardingHeightLabel => 'Taille (cm)';

  @override
  String get onboardingWeightLabel => 'Poids (kg)';

  @override
  String get onboardingSexLabel => 'Paramètre physiologique de calcul';

  @override
  String get onboardingSexFemale => 'Féminin';

  @override
  String get onboardingSexMale => 'Masculin';

  @override
  String get onboardingSexPreferNotToSay => 'Préférer ne pas dire';

  @override
  String get onboardingSexHelp =>
      'Utilisé uniquement pour les équations de besoins énergétiques. Ceci est distinct de votre identité de genre.';

  @override
  String get onboardingActivityLabel => 'Niveau d\'activité';

  @override
  String get onboardingActivitySedentary => 'Sédentaire';

  @override
  String get onboardingActivityLight => 'Légèrement actif';

  @override
  String get onboardingActivityModerate => 'Modérément actif';

  @override
  String get onboardingActivityActive => 'Très actif';

  @override
  String get onboardingActivityExtra => 'Extrêmement actif';

  @override
  String get onboardingCuisineTitle => 'Quels aliments vous sont familiers ?';

  @override
  String get onboardingCuisineSubtitle =>
      'Facultatif. Nous utilisons cela pour prioriser les aliments familiers dans la recherche. Vous pouvez passer.';

  @override
  String get onboardingLanguageTitle => 'Choisissez votre langue';

  @override
  String get onboardingLanguageSubtitle =>
      'Vous pouvez changer cela à tout moment dans les réglages.';

  @override
  String get onboardingSummaryTitle => 'Votre objectif nutritionnel estimé';

  @override
  String get onboardingSummaryBody =>
      'Ceci est une estimation basée sur des équations standard. Vos besoins réels peuvent varier, et nous pourrons affiner cette estimation au fil du temps grâce à votre tendance de poids.';

  @override
  String get onboardingSummaryComingSoon =>
      'Les objectifs caloriques et de macronutriments personnalisés seront calculés à une étape ultérieure.';

  @override
  String onboardingSummaryMaintenance(int kcal) {
    return 'Entretien estimé : $kcal kcal/jour';
  }

  @override
  String onboardingSummaryTarget(int kcal) {
    return 'Objectif quotidien suggéré : $kcal kcal';
  }

  @override
  String onboardingSummaryMacros(int protein, int carbs, int fat, int fibre) {
    return 'Protéines $protein g · Glucides $carbs g · Lipides $fat g · Fibres $fibre g';
  }

  @override
  String get dashboardGreetingMorning => 'Bonjour';

  @override
  String get dashboardGreetingAfternoon => 'Bon après-midi';

  @override
  String get dashboardGreetingEvening => 'Bonsoir';

  @override
  String get dashboardToday => 'Aujourd\'hui';

  @override
  String get dashboardCalories => 'Calories';

  @override
  String get dashboardProtein => 'Protéines';

  @override
  String get dashboardCarbs => 'Glucides';

  @override
  String get dashboardFat => 'Lipides';

  @override
  String get dashboardFibre => 'Fibres';

  @override
  String get dashboardLogFood => 'Enregistrer un aliment';

  @override
  String get dashboardEmptyTitle => 'Rien d\'enregistré pour l\'instant';

  @override
  String get dashboardEmptyBody =>
      'Recherchez un aliment pour commencer à suivre votre journée.';

  @override
  String get dashboardTargetsPlaceholder =>
      'Les objectifs seront définis après l\'onboarding.';

  @override
  String dashboardCaloriesOf(int consumed, int target) {
    return '$consumed / $target kcal';
  }

  @override
  String dashboardCaloriesRemaining(int kcal) {
    return '$kcal kcal restantes';
  }

  @override
  String dashboardCaloriesOver(int kcal) {
    return '$kcal kcal au-dessus de l\'objectif';
  }

  @override
  String get diaryTitle => 'Journal';

  @override
  String get diaryMealBreakfast => 'Petit-déjeuner';

  @override
  String get diaryMealLunch => 'Déjeuner';

  @override
  String get diaryMealDinner => 'Dîner';

  @override
  String get diaryMealSnacks => 'Collations';

  @override
  String get diaryEmpty => 'Aucune entrée pour l\'instant.';

  @override
  String get diaryAddToMeal => 'Ajouter un aliment';

  @override
  String get searchTitle => 'Recherche';

  @override
  String get searchHint => 'Qu\'avez-vous mangé ?';

  @override
  String get searchEmpty =>
      'Recherchez des aliments comme roti, riz jollof, dal ou mangue.';

  @override
  String get searchNoResults =>
      'Aucun aliment correspondant. Essayez un autre nom, alias ou orthographe.';

  @override
  String get searchRecent => 'Récents';

  @override
  String get searchFrequent => 'Fréquents';

  @override
  String get searchFavourites => 'Favoris';

  @override
  String get searchMyRecipes => 'Mes recettes';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

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
  String get settingsAccount => 'Compte';

  @override
  String get settingsSignOut => 'Se déconnecter';

  @override
  String get settingsAbout => 'À propos de Nutrivoya';

  @override
  String get settingsAboutBody =>
      'Nutrivoya est une application multilingue et culturellement intelligente de suivi nutritionnel et calorique qui aide les gens à comprendre et améliorer les aliments qu\'ils mangent réellement — sans leur dire que la santé exige d\'abandonner leur culture.';

  @override
  String get settingsProfile => 'Profil';

  @override
  String get settingsGoals => 'Objectifs';

  @override
  String get settingsComingSoon => 'Bientôt disponible';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGoal => 'Objectif';

  @override
  String get profileActivity => 'Niveau d\'activité';

  @override
  String get profileCuisines => 'Cuisines familières';

  @override
  String get profileEdit => 'Modifier le profil';

  @override
  String get goalsTitle => 'Objectifs nutritionnels';

  @override
  String get goalsNotSet => 'Pas encore défini';

  @override
  String get goalsCalorieTarget => 'Objectif calorique';

  @override
  String get goalsProteinTarget => 'Objectif protéines';

  @override
  String get goalsCarbTarget => 'Objectif glucides';

  @override
  String get goalsFatTarget => 'Objectif lipides';

  @override
  String get goalsFibreTarget => 'Objectif fibres';

  @override
  String get goalsBmr => 'BMR estimé';

  @override
  String get goalsTdee => 'Entretien estimé (TDEE)';

  @override
  String get goalsNeedProfile =>
      'Terminez l\'onboarding pour voir des objectifs personnalisés.';

  @override
  String get goalsEstimateDisclaimer =>
      'La dépense calculée est une estimation. Vos besoins réels peuvent varier.';

  @override
  String get goalsRefineOverTime =>
      'Nous pourrons affiner cette estimation au fil du temps grâce à votre tendance de poids.';

  @override
  String get energyNoteEstimateDisclaimer =>
      'La dépense calculée est une estimation. Vos besoins réels peuvent varier.';

  @override
  String get energyNotePhysiologicalUnspecified =>
      'Sans paramètre physiologique, nous avons moyenné les équations standard. La confiance est plus faible.';

  @override
  String get energyNoteAgeOutsideAdultRange =>
      'Les équations énergétiques sont moins fiables hors des âges adultes typiques. Envisagez un accompagnement professionnel.';

  @override
  String get energyNoteLoseWhileLowWeight =>
      'Votre profil suggère un poids corporel bas. Une perte de poids agressive n\'est pas recommandée — cherchez un soutien qualifié si besoin.';

  @override
  String get energyNoteDeficitCapped =>
      'Nous avons limité le déficit calorique à un rythme plus sûr. Les régimes drastiques ne sont pas pris en charge.';

  @override
  String get energyNoteFloorApplied =>
      'Votre objectif a été relevé à un apport énergétique minimum pour la sécurité.';

  @override
  String get energyNoteTrackOnly =>
      'Vous avez choisi de suivre uniquement. Les chiffres ci-dessous sont des estimations d\'entretien à titre indicatif.';

  @override
  String get confidenceLabel => 'Confiance de l\'estimation';

  @override
  String get confidenceHigh => 'Élevée';

  @override
  String get confidenceHighNote =>
      'Données officielles de composition des aliments';

  @override
  String get confidenceMedium => 'Moyenne';

  @override
  String get confidenceMediumNote =>
      'Calculée à partir d\'une recette standardisée';

  @override
  String get confidenceEstimated => 'Estimée';

  @override
  String get confidenceEstimatedNote =>
      'Basée sur des ingrédients et une portion courants';

  @override
  String get confidenceUnknown => 'Inconnue';

  @override
  String get sourceLabel => 'Source';

  @override
  String get sourceAuthoritative =>
      'Base de composition alimentaire officielle';

  @override
  String get sourcePackaged => 'Base d\'aliments emballés';

  @override
  String get sourceNutrivoyaCurated => 'Jeu de données Nutrivoya';

  @override
  String get sourceRecipeEstimated => 'Estimation basée sur une recette';

  @override
  String get sourceUserSubmitted => 'Soumis par un utilisateur';

  @override
  String get portionLabel => 'Portion';

  @override
  String get portionSmall => 'Petite';

  @override
  String get portionMedium => 'Moyenne';

  @override
  String get portionLarge => 'Grande';

  @override
  String get portionGrams => 'Grammes';

  @override
  String get portionQuantity => 'Quantité';

  @override
  String get portionCustom => 'Grammes personnalisés';

  @override
  String get nutrientEnergyKcal => 'Calories';

  @override
  String get nutrientProteinG => 'Protéines';

  @override
  String get nutrientCarbohydrateG => 'Glucides';

  @override
  String get nutrientFatG => 'Lipides';

  @override
  String get nutrientFibreG => 'Fibres';

  @override
  String get nutrientSaturatedFatG => 'Graisses saturées';

  @override
  String get nutrientSugarG => 'Sucres';

  @override
  String get nutrientSodiumMg => 'Sodium';

  @override
  String get nutrientIronMg => 'Fer';

  @override
  String get nutrientCalciumMg => 'Calcium';

  @override
  String get nutrientPotassiumMg => 'Potassium';

  @override
  String get nutrientMagnesiumMg => 'Magnésium';

  @override
  String get nutrientZincMg => 'Zinc';

  @override
  String get nutrientVitaminAUg => 'Vitamine A';

  @override
  String get nutrientVitaminCMg => 'Vitamine C';

  @override
  String get nutrientVitaminDUg => 'Vitamine D';

  @override
  String get nutrientVitaminB12Ug => 'Vitamine B12';

  @override
  String get nutrientFolateUg => 'Folate';

  @override
  String get foodDetailsTitle => 'Détails de l\'aliment';

  @override
  String get foodDetailsAddToMeal => 'Ajouter au repas';

  @override
  String get foodDetailsPerPortion => 'par portion';

  @override
  String get foodDetailsPer100g => 'pour 100 g';

  @override
  String get foodDetailsPreparationNote =>
      'La préparation et la taille de la portion peuvent modifier les valeurs.';

  @override
  String get foodDetailsNoData => 'Données nutritionnelles indisponibles';

  @override
  String get foodDetailsApprox => '≈';

  @override
  String get foodDetailsLoggingSoon =>
      'L\'enregistrement des aliments arrive à la prochaine étape.';

  @override
  String get foodDetailsMacros => 'Macros';

  @override
  String get foodDetailsMicronutrients => 'Micronutriments';

  @override
  String get foodDetailsCuisine => 'Cuisine';

  @override
  String get foodDetailsRegion => 'Région';

  @override
  String get foodDetailsAliases => 'Aussi connu sous';

  @override
  String searchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats',
      one: '1 résultat',
      zero: 'Aucun résultat',
    );
    return '$_temp0';
  }

  @override
  String get searchTryExample => 'Essayez : roti, riz jollof, dal, mangue';

  @override
  String get diaryAddToMealTitle => 'Ajouter à quel repas ?';

  @override
  String diaryEntryAdded(String food, String meal) {
    return '$food ajouté à $meal';
  }

  @override
  String get diaryEntryDeleted => 'Entrée supprimée';

  @override
  String get diaryEntryUpdated => 'Entrée mise à jour';

  @override
  String get diaryEditEntry => 'Modifier l\'entrée';

  @override
  String get diaryDeleteEntry => 'Supprimer l\'entrée';

  @override
  String get diaryConfirmDelete => 'Retirer cette entrée de votre journal ?';

  @override
  String get diaryConfirmDeleteYes => 'Retirer';

  @override
  String get diaryGramsLabel => 'Grammes';

  @override
  String get diaryQuantityLabel => 'Quantité';

  @override
  String get diaryNoEntriesForMeal => 'Aucune entrée pour l\'instant';

  @override
  String get diaryKcalShort => 'kcal';

  @override
  String get diarySelectDate => 'Choisir une date';

  @override
  String get diaryToday => 'Aujourd\'hui';

  @override
  String get diaryYesterday => 'Hier';

  @override
  String diaryEntryCalories(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipesTitle => 'Mes recettes';

  @override
  String get recipesCreate => 'Créer une recette';

  @override
  String get recipesEdit => 'Modifier la recette';

  @override
  String get recipesEmptyTitle => 'Pas encore de recettes personnelles';

  @override
  String get recipesEmptyBody =>
      'Enregistrez des recettes familiales comme le jollof de maman ou le dal de grand-mère pour suivre les versions que vous cuisinez vraiment.';

  @override
  String get recipesNameLabel => 'Nom de la recette';

  @override
  String get recipesServingsLabel => 'Portions';

  @override
  String get recipesYieldLabel => 'Rendement total (g)';

  @override
  String get recipesYieldHint =>
      'Facultatif — somme des ingrédients par défaut';

  @override
  String get recipesIngredients => 'Ingrédients';

  @override
  String get recipesIngredientsEmpty =>
      'Ajoutez des ingrédients pour calculer la nutrition.';

  @override
  String get recipesAddIngredient => 'Ajouter un ingrédient';

  @override
  String get recipesNotesLabel => 'Notes';

  @override
  String get recipesCalculatedNutrition => 'Nutrition calculée';

  @override
  String recipesWholeRecipeKcal(int kcal) {
    return 'Recette entière : ≈ $kcal kcal';
  }

  @override
  String recipesPerServingKcal(int kcal) {
    return '≈ $kcal kcal par portion';
  }

  @override
  String recipesServingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count portions',
      one: '1 portion',
    );
    return '$_temp0';
  }

  @override
  String get recipesPerServingShort => 'portion';

  @override
  String get recipesCalculationNote =>
      'Calculée à partir de vos ingrédients et quantités. La préparation et le rendement peuvent modifier les valeurs.';

  @override
  String get recipesDeleteTitle => 'Supprimer la recette ?';

  @override
  String get recipesDeleteBody =>
      'Cela retire la recette de votre collection personnelle. Les entrées déjà enregistrées dans le journal ne sont pas affectées.';

  @override
  String get barcodeTitle => 'Scanner un code-barres';

  @override
  String get barcodeHint =>
      'Pointez la caméra vers un code-barres d\'aliment emballé, ou saisissez le numéro manuellement.';

  @override
  String get barcodeManualLabel => 'Numéro de code-barres';

  @override
  String get barcodeManualHint => 'ex. 3017620422003';

  @override
  String get barcodeLookupButton => 'Rechercher le produit';

  @override
  String get barcodeCameraUnavailable =>
      'Caméra indisponible sur cet appareil. Saisissez le code-barres manuellement.';

  @override
  String get barcodeNotFoundTitle => 'Produit introuvable';

  @override
  String barcodeNotFoundBody(String barcode) {
    return 'Aucun aliment emballé ne correspond au code-barres $barcode. Réessayez ou ajoutez l\'aliment autrement.';
  }

  @override
  String get barcodeInvalid =>
      'Cela ne ressemble pas à un code-barres valide. Utilisez 8 à 14 chiffres.';

  @override
  String get barcodeNetworkError =>
      'Impossible d\'atteindre la base d\'aliments emballés. Vérifiez votre connexion et réessayez.';

  @override
  String get barcodeTryAgain => 'Réessayer';

  @override
  String get barcodeCrowdsourcedNote =>
      'Les données d\'aliments emballés proviennent d\'Open Food Facts et peuvent être incomplètes ou collaboratives. Vérifiez toujours la taille de portion avant d\'enregistrer.';

  @override
  String get assistantTitle => 'Demander à Nutrivoya';

  @override
  String get assistantIntro =>
      'Posez des questions sur vos repas, aliments culturels, protéines ou faim — les réponses utilisent votre journal, vos objectifs et la base alimentaire. Aucun chiffre n\'est inventé.';

  @override
  String get assistantWellnessDisclaimer =>
      'Nutrivoya propose des conseils de bien-être généraux, pas un avis médical.';

  @override
  String get assistantMedicalDisclaimer =>
      'Cela semble médical ou à haut risque. Consultez un professionnel de santé qualifié. Nutrivoya ne diagnostique pas, ne traite pas et ne prescrit pas.';

  @override
  String get assistantTryAsking => 'Essayez de demander';

  @override
  String get assistantSuggestions => 'Suggestions';

  @override
  String get assistantSources => 'Sources';

  @override
  String get assistantInputHint =>
      'Demandez à propos du riz, des protéines, de l\'équilibre…';

  @override
  String get assistantSend => 'Envoyer';

  @override
  String get assistantClear => 'Effacer la conversation';

  @override
  String get assistantPromptRice =>
      'Puis-je encore manger du riz en perdant du poids ?';

  @override
  String get assistantPromptBalance =>
      'Comment équilibrer mes repas d\'aujourd\'hui ?';

  @override
  String get assistantPromptProtein =>
      'Comment augmenter les protéines avec des aliments familiers ?';

  @override
  String get assistantPromptHunger =>
      'Pourquoi ai-je encore faim près de mon objectif calorique ?';

  @override
  String get assistantPromptRoti => 'Combien de calories dans un roti ?';

  @override
  String assistantHeadlineCultural(String staple) {
    return 'Oui — $staple peut entrer dans vos objectifs';
  }

  @override
  String get assistantHeadlineBalance => 'Équilibre des repas d\'aujourd\'hui';

  @override
  String get assistantHeadlineProtein =>
      'Augmenter les protéines avec des aliments familiers';

  @override
  String get assistantHeadlineHunger => 'Faim près de votre objectif calorique';

  @override
  String assistantHeadlineLookupFound(String foodName) {
    return 'Nutrition pour $foodName';
  }

  @override
  String assistantHeadlineLookupMissing(String foodName) {
    return 'Aucun résultat pour « $foodName »';
  }

  @override
  String get assistantHeadlineSubstitute => 'Modifiez avant de remplacer';

  @override
  String get assistantHeadlineMedical => 'Demandez un avis professionnel';

  @override
  String get assistantHeadlineUnknown =>
      'J\'ai besoin d\'une question plus claire';

  @override
  String assistantBodyCultural(String staple, String cuisine) {
    return '$staple fait naturellement partie de l\'alimentation $cuisine. Vous n\'avez pas à l\'abandonner — ajustez les portions et les accompagnements selon votre objectif.';
  }

  @override
  String assistantBodyCulturalWithData(
    String staple,
    String foodName,
    String portionName,
    int kcal,
    String sourceName,
  ) {
    return '$staple peut rester dans votre alimentation. D\'après la base, $foodName ($portionName) fait environ $kcal kcal ($sourceName). Préférez une portion plus petite ou ajoutez des légumes et une source de protéines plutôt que de supprimer l\'aliment.';
  }

  @override
  String assistantBodyBalanceWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int proteinTarget,
    int entryCount,
  ) {
    return 'Aujourd\'hui vous avez enregistré $caloriesConsumed sur $calorieTarget kcal et $proteinConsumed sur $proteinTarget g de protéines sur $entryCount entrées. Utilisez des aliments familiers et de petits ajustements — sans moraliser.';
  }

  @override
  String assistantBodyBalanceNoTargets(
    int caloriesConsumed,
    int proteinConsumed,
    int entryCount,
  ) {
    return 'Aujourd\'hui vous avez enregistré $caloriesConsumed kcal et $proteinConsumed g de protéines sur $entryCount entrées. Définissez des objectifs dans Réglages pour plus de clarté, ou continuez à noter vos repas habituels.';
  }

  @override
  String assistantBodyProteinWithTargets(
    int proteinConsumed,
    int proteinTarget,
    int proteinGap,
    String cuisine,
  ) {
    return 'Vous avez enregistré $proteinConsumed sur $proteinTarget g de protéines aujourd\'hui (il reste $proteinGap g). Gardez les aliments $cuisine et ajoutez des accompagnements riches en protéines.';
  }

  @override
  String assistantBodyProtein(int proteinConsumed, String cuisine) {
    return 'Vous avez enregistré $proteinConsumed g de protéines aujourd\'hui. Augmentez-les avec des accompagnements $cuisine familiers plutôt qu\'en remplaçant vos repas.';
  }

  @override
  String assistantBodyHungerWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int fibreConsumed,
  ) {
    return 'Vous êtes à $caloriesConsumed sur $calorieTarget kcal, avec $proteinConsumed g de protéines et $fibreConsumed g de fibres. La faim peut venir des protéines, des fibres, du rythme des repas ou de l\'hydratation — pas d\'un échec moral.';
  }

  @override
  String assistantBodyHunger(
    int caloriesConsumed,
    int proteinConsumed,
    int fibreConsumed,
  ) {
    return 'Vous avez enregistré $caloriesConsumed kcal, $proteinConsumed g de protéines et $fibreConsumed g de fibres. La faim s\'améliore souvent avec protéines, fibres et un rythme plus lent — pas en classant les aliments comme mauvais.';
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
    return '$foodName · $portionName : ≈ $kcal kcal et $proteinG g de protéines. Source : $sourceName. Confiance : $confidence.';
  }

  @override
  String assistantBodyLookupNoNutrition(String foodName, String sourceName) {
    return '$foodName a été trouvé dans $sourceName, mais aucune donnée calorique fiable n\'est disponible. Nutrivoya n\'inventera pas de chiffre.';
  }

  @override
  String assistantBodyLookupMissing(String foodName) {
    return 'Aucun aliment structuré ne correspond à « $foodName ». Essayez un autre nom, un code-barres ou une recette personnelle — les calories ne seront pas estimées au hasard.';
  }

  @override
  String get assistantBodySubstitute =>
      'Commencez par ajuster la portion, ajouter des légumes ou accompagner d\'une source de protéines. Remplacer est optionnel — modifier conserve souvent les repas culturels.';

  @override
  String get assistantBodyMedical =>
      'Nutrivoya ne peut pas conseiller sur un diagnostic, des médicaments, une grossesse à risque, des troubles alimentaires ou d\'autres situations cliniques. Consultez un professionnel adapté.';

  @override
  String get assistantBodyUnknown =>
      'Essayez : « Puis-je encore manger du riz ? », « Comment augmenter les protéines ? », « Combien de calories dans un roti ? » ou « Pourquoi ai-je encore faim ? »';

  @override
  String get assistantTipAskRice =>
      'Demandez si un aliment culturel peut entrer dans vos objectifs';

  @override
  String get assistantTipAskBalance =>
      'Demandez comment vos repas d\'aujourd\'hui se comparent à vos objectifs';

  @override
  String get assistantTipAskProtein =>
      'Demandez comment augmenter les protéines avec des aliments familiers';

  @override
  String get assistantTipAskFoodLookup =>
      'Demandez « calories dans … » pour un aliment de la base';

  @override
  String get assistantTipSeekProfessional =>
      'Contactez un médecin, un diététicien ou un clinicien qualifié';

  @override
  String get assistantTipFoodNotFound =>
      'Essayez une autre orthographe, un alias ou un scan de code-barres';

  @override
  String get assistantTipNutritionUnavailable =>
      'Données nutritionnelles indisponibles — aucun calorie inventée';

  @override
  String get assistantTipVerifyPortion =>
      'Vérifiez que la portion correspond à ce que vous avez mangé';

  @override
  String get assistantTipNoMoralFood =>
      'Aucun aliment n\'est bon ou mauvais en soi — le contexte compte';

  @override
  String get assistantTipHungerProteinFibre =>
      'Vérifiez protéines et fibres — les deux favorisent la satiété';

  @override
  String get assistantTipHungerPace =>
      'Mangez un peu plus lentement et ajoutez des légumes pour le volume';

  @override
  String get assistantTipProteinPairDal =>
      'Associez les céréales au dal, aux haricots ou aux lentilles';

  @override
  String get assistantTipProteinPairYoghurt =>
      'Ajoutez du yaourt, du paneer ou un laitier égoutté';

  @override
  String get assistantTipProteinPairEgg =>
      'Ajoutez œuf, poisson, tofu ou viande maigre selon votre cuisine';

  @override
  String get assistantTipModifyNotReplace =>
      'Modifiez le repas que vous aimez déjà avant de le remplacer';

  @override
  String get assistantTipModifyPortion =>
      'Essayez d\'abord une plus petite portion de l\'aliment de base';

  @override
  String get assistantTipAddVegetables =>
      'Ajoutez des légumes ou une salade pour le volume et les fibres';

  @override
  String get assistantTipAddProteinSide =>
      'Ajoutez un accompagnement protéiné plutôt que de supprimer l\'aliment';

  @override
  String get assistantTipLogSomething =>
      'Enregistrez un repas pour que les conseils utilisent votre vrai schéma';

  @override
  String get progressTitle => 'Progression';

  @override
  String get progressIntro =>
      'Suivez le poids, l\'eau et les mensurations comme des tendances calmes — les variations quotidiennes sont du bruit, pas un verdict.';

  @override
  String get progressWater => 'Eau aujourd\'hui';

  @override
  String progressWaterTotal(int total, int goal) {
    return '$total ml sur $goal ml';
  }

  @override
  String progressWaterAdd(int ml) {
    return '+$ml ml';
  }

  @override
  String get progressWeight => 'Poids';

  @override
  String get progressLogWeight => 'Enregistrer le poids';

  @override
  String get progressWeightKgLabel => 'Poids (kg)';

  @override
  String progressWeightValue(String kg) {
    return '$kg kg';
  }

  @override
  String get progressWeightEmpty =>
      'Aucun poids enregistré. Ajoutez-en quelques-uns sur plusieurs jours pour voir une tendance calme.';

  @override
  String get progressWeightInvalid =>
      'Entrez un poids plausible entre 20 et 400 kg.';

  @override
  String get progressTrendNote =>
      'Les tendances utilisent une moyenne sur plusieurs jours. Les variations d\'un jour sont normales et non jugées.';

  @override
  String get progressTrendInsufficient =>
      'Enregistrez le poids sur quelques jours de plus pour estimer une tendance hebdomadaire.';

  @override
  String progressTrendSteady(String avg) {
    return 'Environ $avg kg — plutôt stable ces derniers jours.';
  }

  @override
  String progressTrendRising(String avg, String delta) {
    return 'Environ $avg kg — légère hausse (~$delta kg/semaine). Regardez le motif, pas un seul jour.';
  }

  @override
  String progressTrendFalling(String avg, String delta) {
    return 'Environ $avg kg — légère baisse (~$delta kg/semaine). Regardez le motif, pas un seul jour.';
  }

  @override
  String get progressMeasurements => 'Mensurations';

  @override
  String get progressMeasurementsNote =>
      'Tour de taille et de hanches optionnels (cm). Non utilisés pour les objectifs caloriques.';

  @override
  String get progressMeasurementsEmpty => 'Aucune mensuration enregistrée.';

  @override
  String get progressLogMeasurement => 'Enregistrer une mensuration';

  @override
  String get progressWaistLabel => 'Taille (cm)';

  @override
  String get progressHipLabel => 'Hanches (cm)';

  @override
  String progressWaist(String cm) {
    return 'Taille $cm cm';
  }

  @override
  String progressHip(String cm) {
    return 'Hanches $cm cm';
  }

  @override
  String get progressMeasurementInvalid => 'Entrez au moins une mensuration.';

  @override
  String get favouritesTitle => 'Favoris';

  @override
  String get favouritesAdd => 'Ajouter aux favoris';

  @override
  String get favouritesRemove => 'Retirer des favoris';

  @override
  String get frequentFoodsTitle => 'Aliments fréquents';

  @override
  String get frequentFoodsEmpty =>
      'Les aliments que vous enregistrez souvent apparaîtront ici.';

  @override
  String frequentFoodsCount(int count) {
    return 'Enregistré $count fois';
  }

  @override
  String get templatesTitle => 'Modèles de repas';

  @override
  String get templatesIntro =>
      'Enregistrez les repas familiers d\'une journée et réappliquez-les plus tard — utile pour les petits-déjeuners habituels.';

  @override
  String get templatesEmpty =>
      'Aucun modèle. Enregistrez une journée qui vous plaît, puis sauvegardez-la.';

  @override
  String get templatesSaveFromToday => 'Enregistrer à partir d\'aujourd\'hui';

  @override
  String get templatesNameLabel => 'Nom du modèle';

  @override
  String get templatesNeedEntries =>
      'Enregistrez des aliments aujourd\'hui avant de créer un modèle.';

  @override
  String get templatesSaved => 'Modèle enregistré';

  @override
  String get templatesApply => 'Appliquer à aujourd\'hui';

  @override
  String templatesApplied(int count) {
    return '$count éléments ajoutés depuis le modèle';
  }

  @override
  String templatesTodayCount(int count) {
    return '$count entrées du journal disponibles';
  }

  @override
  String templatesItemSummary(int count, int kcal) {
    return '$count éléments · ≈ $kcal kcal';
  }

  @override
  String get photoTitle => 'Repas photo';

  @override
  String get photoIntro =>
      'Photographiez un repas, décrivez ce que vous voyez, puis confirmez un aliment de la base. La nutrition vient toujours des données structurées — jamais de l\'image seule.';

  @override
  String get photoUncertaintyDisclaimer =>
      'Les suggestions photo sont incertaines. Confirmez toujours l\'aliment et la portion avant d\'enregistrer. Les estimations de vision ne sont jamais traitées comme certaines.';

  @override
  String get photoTakePhoto => 'Prendre une photo';

  @override
  String get photoChooseGallery => 'Choisir dans la galerie';

  @override
  String get photoRetake => 'Choisir une autre photo';

  @override
  String get photoClear => 'Effacer la photo';

  @override
  String get photoDescriptionLabel => 'Que voyez-vous ?';

  @override
  String get photoDescriptionHint => 'ex. roti et dal, riz jollof, bol de phở';

  @override
  String get photoSuggestFoods => 'Suggérer des aliments';

  @override
  String get photoSuggestionsTitle => 'Correspondances possibles';

  @override
  String get photoSuggestionsNote =>
      'Issues de votre description recherchée dans la base — pas de calories inventées depuis la photo.';

  @override
  String get photoConfidenceUncertain =>
      'Correspondance incertaine — confirmez';

  @override
  String get photoConfidenceLow => 'Faible correspondance — vérifiez';

  @override
  String get photoPortionTitle => 'Estimer la portion';

  @override
  String get photoPortionNote =>
      'La portion issue de la photo n\'est qu\'une estimation. Ajustez avant d\'enregistrer.';

  @override
  String get photoConfirmOpenFood => 'Confirmer et ouvrir l\'aliment';

  @override
  String get photoConfirmNote =>
      'Vous vérifierez ensuite la portion sur l\'écran détail. L\'enregistrement utilise uniquement la nutrition structurée.';

  @override
  String get photoDetailsEstimateNote =>
      'La portion a été suggérée depuis une photo et est incertaine — vérifiez les grammes avant d\'enregistrer.';

  @override
  String get photoSearchSubtitle =>
      'Photographiez un repas, puis confirmez un aliment de la base.';

  @override
  String get photoErrorNoImage => 'Ajoutez d\'abord une photo.';

  @override
  String get photoErrorNeedDescription =>
      'Décrivez ce que vous voyez pour que Nutrivoya cherche dans la base. L\'app n\'invente pas d\'aliments à partir des pixels.';

  @override
  String get photoErrorNoMatches =>
      'Aucun aliment structuré ne correspond. Essayez un autre nom ou une recherche manuelle.';

  @override
  String get photoErrorFailed =>
      'Impossible d\'utiliser cette photo. Réessayez ou choisissez une autre image.';

  @override
  String get addProductTitle => 'Ajouter un produit';

  @override
  String get addProductIntro =>
      'Soumettez un aliment ou produit emballé manquant pour votre bibliothèque personnelle. Les valeurs saisies ne sont jamais traitées comme officielles.';

  @override
  String get addProductProvenanceNote =>
      'Laissez la nutrition vide si elle est inconnue. Nutrivoya n\'invente pas de calories ni de macros.';

  @override
  String get addProductNameLabel => 'Nom du produit ou de l\'aliment';

  @override
  String get addProductBrandLabel => 'Marque (facultatif)';

  @override
  String get addProductBarcodeLabel => 'Code-barres (facultatif)';

  @override
  String get addProductCuisineLabel => 'Cuisine ou région (facultatif)';

  @override
  String get addProductServingSection => 'Portion';

  @override
  String get addProductServingGramsLabel => 'Portion par défaut (grammes)';

  @override
  String get addProductPortionNameLabel => 'Nom de la portion (facultatif)';

  @override
  String get addProductNutritionSection => 'Nutrition pour 100 g (facultatif)';

  @override
  String get addProductNutritionHint =>
      'Saisissez uniquement les valeurs connues d\'une étiquette ou d\'une source fiable. Laissez vide plutôt que d\'estimer.';

  @override
  String get addProductEnergyLabel => 'Énergie (kcal / 100 g)';

  @override
  String get addProductProteinLabel => 'Protéines (g / 100 g)';

  @override
  String get addProductCarbLabel => 'Glucides (g / 100 g)';

  @override
  String get addProductFatLabel => 'Lipides (g / 100 g)';

  @override
  String get addProductFibreLabel => 'Fibres (g / 100 g)';

  @override
  String get addProductNotesLabel => 'Notes (facultatif)';

  @override
  String get addProductSubmit => 'Enregistrer dans ma bibliothèque';

  @override
  String get addProductSubmitNote =>
      'Enregistré comme soumission utilisateur en attente de revue. Visible uniquement dans votre recherche — pas comme nutrition vérifiée.';

  @override
  String get addProductPublished =>
      'Enregistré dans votre bibliothèque personnelle (en attente de revue)';

  @override
  String get addProductErrorNameRequired =>
      'Saisissez un nom de produit ou d\'aliment.';

  @override
  String get addProductErrorNameShort => 'Le nom est trop court.';

  @override
  String get addProductErrorServingInvalid =>
      'La portion doit être entre 0 et 5000 grammes.';

  @override
  String get addProductErrorBarcodeInvalid =>
      'Le code-barres doit contenir 8 à 14 chiffres.';

  @override
  String get addProductErrorEnergyInvalid =>
      'L\'énergie doit être entre 0 et 950 kcal pour 100 g.';

  @override
  String get addProductErrorProteinInvalid =>
      'Les protéines doivent être entre 0 et 1000 g pour 100 g.';

  @override
  String get addProductErrorCarbInvalid =>
      'Les glucides doivent être entre 0 et 1000 g pour 100 g.';

  @override
  String get addProductErrorFatInvalid =>
      'Les lipides doivent être entre 0 et 1000 g pour 100 g.';

  @override
  String get addProductErrorFibreInvalid =>
      'Les fibres doivent être entre 0 et 1000 g pour 100 g.';

  @override
  String get addProductWarningNoNutrition =>
      'Aucune nutrition saisie — l\'aliment restera indisponible jusqu\'à ce que vous ajoutiez des valeurs.';

  @override
  String get addProductWarningNoEnergy =>
      'Énergie manquante — les macros seules n\'afficheront pas les calories.';

  @override
  String get addProductWarningMacrosHigh =>
      'Protéines + glucides + lipides dépassent 110 g pour 100 g — vérifiez l\'étiquette.';

  @override
  String get addProductStatusDraft => 'Brouillon';

  @override
  String get addProductStatusPending => 'En attente de revue';

  @override
  String get addProductStatusPublished =>
      'Dans la bibliothèque personnelle (en attente de revue)';

  @override
  String get addProductStatusWithdrawn => 'Retiré';

  @override
  String get mySubmissionsTitle => 'Mes soumissions';

  @override
  String get mySubmissionsEmpty =>
      'Aucune soumission. Ajoutez un produit manquant depuis la recherche, le code-barres ou les Réglages.';

  @override
  String get authContinueOffline => 'Continuer sans compte';

  @override
  String get authOfflineNote =>
      'Vos données restent uniquement sur cet appareil. Les comptes et la synchronisation sont disponibles lorsque Nutrivoya est connecté à son backend.';

  @override
  String get settingsSyncNow => 'Synchroniser maintenant';

  @override
  String settingsSyncPending(int count) {
    return '$count modifications en attente de synchronisation';
  }

  @override
  String get settingsSyncDone => 'Journal synchronisé';

  @override
  String get settingsSyncUnavailable =>
      'Synchronisation indisponible — données stockées sur cet appareil';

  @override
  String get addProductStatusVerified => 'Vérifié par un réviseur';

  @override
  String get addProductStatusRejected => 'Rejeté';

  @override
  String get reviewQueueTitle => 'File de revue';

  @override
  String get reviewQueueEmpty => 'Aucune soumission en attente de revue.';

  @override
  String get reviewQueueNeedReviewerMode =>
      'Activez le mode réviseur dans les Réglages pour approuver ou rejeter. La revue n\'invente jamais de nutrition.';

  @override
  String get reviewQueueProvenanceNote =>
      'L\'approbation ne change que la provenance — la nutrition manquante reste indisponible.';

  @override
  String get reviewQueueOpenFood => 'Ouvrir l\'aliment';

  @override
  String get reviewQueueApprove => 'Approuver';

  @override
  String get reviewQueueReject => 'Rejeter';

  @override
  String get reviewQueueApproved =>
      'Marqué comme vérifié (provenance utilisateur conservée)';

  @override
  String get reviewQueueRejected => 'Soumission rejetée';

  @override
  String reviewQueueBarcode(String code) {
    return 'Code-barres $code';
  }

  @override
  String reviewQueueEnergy(int kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String get reviewQueueNoEnergy => 'Énergie indisponible';

  @override
  String get settingsReviewerMode => 'Mode réviseur';

  @override
  String get settingsReviewerModeNote =>
      'Autoriser l\'approbation ou le rejet des soumissions en attente sur cet appareil.';

  @override
  String get dashboardMicrosTitle => 'Micronutriments du jour';

  @override
  String get dashboardMicrosNote =>
      'Shown only when logged foods include measured values. Missing nutrients stay indisponible — never invented.';

  @override
  String get dashboardMicroUnavailable => 'indisponible';

  @override
  String get culturalSuggestionsTitle => 'Idées de cuisine familière';

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
  String get culturalSuggestionsKcalUnavailable => 'Energy indisponible';

  @override
  String get culturalSuggestReasonFamiliarCuisine => 'Cuisine familière';

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
  String get culturalSuggestReasonExplore => 'Depuis la base alimentaire';

  @override
  String get educationTitle => 'Éducation nutritionnelle';

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
      'When Nutrivoya lacks a nutrient value, it shows indisponible. The app will not invent calories or micros to fill gaps.';

  @override
  String get educationTipProvenanceTitle => 'Provenance matters';

  @override
  String get educationTipProvenanceBody =>
      'User-submitted foods stay labeled until verified. Verified still means user-submitted provenance — not an authoritative lab dataset.';

  @override
  String get catalogTitle => 'Catalogue alimentaire public';

  @override
  String get catalogIntro =>
      'Verified user-contributed foods shared for others to search. Values are never invented at publish time.';

  @override
  String get catalogEmpty =>
      'No verified foods published yet. Approve a submission, then publish it from My submissions.';

  @override
  String get catalogVerifiedBadge => 'Soumission vérifiée';

  @override
  String get catalogPublishAction => 'Publier au catalogue';

  @override
  String get catalogPublishDone => 'Publié dans le catalogue public';

  @override
  String get catalogPublishNeedVerified =>
      'Seules les soumissions vérifiées peuvent être publiées';
}
