// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Nutrivoya';

  @override
  String get appTagline =>
      'Nutrición que funciona con tu comida, tu cultura y tu vida.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonSkip => 'Omitir';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonGetStarted => 'Empezar';

  @override
  String get commonLoading => 'Cargando…';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonError => 'Algo salió mal';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get navDashboard => 'Hoy';

  @override
  String get navDiary => 'Diario';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get authLoginTitle => 'Bienvenido de nuevo';

  @override
  String get authLoginSubtitle =>
      'Inicia sesión para seguir registrando tu nutrición.';

  @override
  String get authSignupTitle => 'Crea tu cuenta';

  @override
  String get authSignupSubtitle =>
      'Comienza tu viaje nutricional culturalmente inteligente.';

  @override
  String get authEmailLabel => 'Correo electrónico';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authEmailHint => 'tu@ejemplo.com';

  @override
  String get authLoginButton => 'Iniciar sesión';

  @override
  String get authSignupButton => 'Crear cuenta';

  @override
  String get authSwitchToSignup => '¿No tienes cuenta? Regístrate';

  @override
  String get authSwitchToLogin => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authErrorInvalidCredentials => 'Correo o contraseña no válidos.';

  @override
  String get authErrorEmailInUse => 'Ya existe una cuenta con este correo.';

  @override
  String get authErrorWeakPassword => 'Elige una contraseña más segura.';

  @override
  String get authErrorGeneric => 'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a Nutrivoya';

  @override
  String get onboardingWelcomeBody =>
      'Nutrición que funciona con tu comida, tu cultura y tu vida.';

  @override
  String get onboardingGoalTitle =>
      '¿En qué te gustaría que Nutrivoya te ayude?';

  @override
  String get onboardingGoalMaintain => 'Mantener mi peso';

  @override
  String get onboardingGoalLose => 'Perder peso';

  @override
  String get onboardingGoalGain => 'Ganar peso';

  @override
  String get onboardingGoalBuildMuscle => 'Ganar músculo';

  @override
  String get onboardingGoalImprove => 'Mejorar mi nutrición';

  @override
  String get onboardingGoalTrack => 'Solo registrar lo que como';

  @override
  String get onboardingProfileTitle => 'Cuéntanos sobre ti';

  @override
  String get onboardingProfileSubtitle =>
      'Solo usamos esto para estimar tus necesidades nutricionales. Puedes cambiarlo después.';

  @override
  String get onboardingAgeLabel => 'Edad';

  @override
  String get onboardingHeightLabel => 'Altura (cm)';

  @override
  String get onboardingWeightLabel => 'Peso (kg)';

  @override
  String get onboardingSexLabel => 'Parámetro fisiológico de cálculo';

  @override
  String get onboardingSexFemale => 'Femenino';

  @override
  String get onboardingSexMale => 'Masculino';

  @override
  String get onboardingSexPreferNotToSay => 'Prefiero no decirlo';

  @override
  String get onboardingSexHelp =>
      'Solo se usa en las ecuaciones de requerimiento energético. Es distinto de tu identidad de género.';

  @override
  String get onboardingActivityLabel => 'Nivel de actividad';

  @override
  String get onboardingActivitySedentary => 'Sedentario';

  @override
  String get onboardingActivityLight => 'Ligeramente activo';

  @override
  String get onboardingActivityModerate => 'Moderadamente activo';

  @override
  String get onboardingActivityActive => 'Muy activo';

  @override
  String get onboardingActivityExtra => 'Extraactivo';

  @override
  String get onboardingCuisineTitle => '¿Qué comidas te resultan familiares?';

  @override
  String get onboardingCuisineSubtitle =>
      'Opcional. Lo usamos para priorizar alimentos familiares en la búsqueda. Puedes omitirlo.';

  @override
  String get onboardingLanguageTitle => 'Elige tu idioma';

  @override
  String get onboardingLanguageSubtitle =>
      'Puedes cambiarlo en cualquier momento en ajustes.';

  @override
  String get onboardingSummaryTitle => 'Tu objetivo nutricional estimado';

  @override
  String get onboardingSummaryBody =>
      'Esta es una estimación basada en ecuaciones estándar. Tus necesidades reales pueden variar, y podemos refinarla con el tiempo según tu tendencia de peso.';

  @override
  String get onboardingSummaryComingSoon =>
      'Los objetivos personalizados de calorías y macros se calcularán en un paso posterior.';

  @override
  String onboardingSummaryMaintenance(int kcal) {
    return 'Mantenimiento estimado: $kcal kcal/día';
  }

  @override
  String onboardingSummaryTarget(int kcal) {
    return 'Objetivo diario sugerido: $kcal kcal';
  }

  @override
  String onboardingSummaryMacros(int protein, int carbs, int fat, int fibre) {
    return 'Proteína $protein g · Carbohidratos $carbs g · Grasa $fat g · Fibra $fibre g';
  }

  @override
  String get dashboardGreetingMorning => 'Buenos días';

  @override
  String get dashboardGreetingAfternoon => 'Buenas tardes';

  @override
  String get dashboardGreetingEvening => 'Buenas noches';

  @override
  String get dashboardToday => 'Hoy';

  @override
  String get dashboardCalories => 'Calorías';

  @override
  String get dashboardProtein => 'Proteína';

  @override
  String get dashboardCarbs => 'Carbohidratos';

  @override
  String get dashboardFat => 'Grasa';

  @override
  String get dashboardFibre => 'Fibra';

  @override
  String get dashboardLogFood => 'Registrar comida';

  @override
  String get dashboardEmptyTitle => 'Aún no hay registros';

  @override
  String get dashboardEmptyBody =>
      'Busca un alimento para empezar a seguir tu día.';

  @override
  String get dashboardTargetsPlaceholder =>
      'Los objetivos se configurarán después del onboarding.';

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
    return '$kcal kcal por encima del objetivo';
  }

  @override
  String get diaryTitle => 'Diario';

  @override
  String get diaryMealBreakfast => 'Desayuno';

  @override
  String get diaryMealLunch => 'Comida';

  @override
  String get diaryMealDinner => 'Cena';

  @override
  String get diaryMealSnacks => 'Snacks';

  @override
  String get diaryEmpty => 'Aún no hay entradas.';

  @override
  String get diaryAddToMeal => 'Añadir alimento';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => '¿Qué comiste?';

  @override
  String get searchEmpty =>
      'Busca alimentos como roti, arroz jollof, dal o mango.';

  @override
  String get searchNoResults =>
      'No se encontraron alimentos. Prueba otro nombre, alias u ortografía.';

  @override
  String get searchRecent => 'Recientes';

  @override
  String get searchFrequent => 'Frecuentes';

  @override
  String get searchFavourites => 'Favoritos';

  @override
  String get searchMyRecipes => 'Mis recetas';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

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
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get settingsAbout => 'Acerca de Nutrivoya';

  @override
  String get settingsAboutBody =>
      'Nutrivoya es una app multilingüe y culturalmente inteligente de seguimiento nutricional y calórico que ayuda a las personas a entender y mejorar la comida que realmente comen — sin decirles que la salud exige abandonar su cultura.';

  @override
  String get settingsProfile => 'Perfil';

  @override
  String get settingsGoals => 'Objetivos';

  @override
  String get settingsComingSoon => 'Próximamente';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileGoal => 'Objetivo';

  @override
  String get profileActivity => 'Nivel de actividad';

  @override
  String get profileCuisines => 'Cocinas familiares';

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get goalsTitle => 'Objetivos nutricionales';

  @override
  String get goalsNotSet => 'Aún no definido';

  @override
  String get goalsCalorieTarget => 'Objetivo de calorías';

  @override
  String get goalsProteinTarget => 'Objetivo de proteína';

  @override
  String get goalsCarbTarget => 'Objetivo de carbohidratos';

  @override
  String get goalsFatTarget => 'Objetivo de grasa';

  @override
  String get goalsFibreTarget => 'Objetivo de fibra';

  @override
  String get goalsBmr => 'BMR estimado';

  @override
  String get goalsTdee => 'Mantenimiento estimado (TDEE)';

  @override
  String get goalsNeedProfile =>
      'Completa el onboarding para ver objetivos personalizados.';

  @override
  String get goalsEstimateDisclaimer =>
      'El gasto calculado es una estimación. Tus necesidades reales pueden variar.';

  @override
  String get goalsRefineOverTime =>
      'Podemos refinar esta estimación con el tiempo según tu tendencia de peso.';

  @override
  String get energyNoteEstimateDisclaimer =>
      'El gasto calculado es una estimación. Tus necesidades reales pueden variar.';

  @override
  String get energyNotePhysiologicalUnspecified =>
      'Sin un parámetro fisiológico, promediamos las ecuaciones estándar. La confianza es menor.';

  @override
  String get energyNoteAgeOutsideAdultRange =>
      'Las ecuaciones energéticas son menos fiables fuera de las edades adultas típicas. Considera orientación profesional.';

  @override
  String get energyNoteLoseWhileLowWeight =>
      'Tu perfil sugiere un peso corporal bajo. No se recomienda una pérdida de peso agresiva — busca apoyo cualificado si lo necesitas.';

  @override
  String get energyNoteDeficitCapped =>
      'Limitamos el déficit calórico a un ritmo más seguro. No se admiten dietas extremas.';

  @override
  String get energyNoteFloorApplied =>
      'Tu objetivo se elevó a una ingesta energética mínima por seguridad.';

  @override
  String get energyNoteTrackOnly =>
      'Elegiste solo registrar. Las cifras siguientes son estimaciones de mantenimiento de referencia.';

  @override
  String get confidenceLabel => 'Confianza de la estimación';

  @override
  String get confidenceHigh => 'Alta';

  @override
  String get confidenceHighNote =>
      'Datos oficiales de composición de alimentos';

  @override
  String get confidenceMedium => 'Media';

  @override
  String get confidenceMediumNote =>
      'Calculada a partir de una receta estandarizada';

  @override
  String get confidenceEstimated => 'Estimada';

  @override
  String get confidenceEstimatedNote =>
      'Basada en ingredientes y tamaño de porción habituales';

  @override
  String get confidenceUnknown => 'Desconocida';

  @override
  String get sourceLabel => 'Fuente';

  @override
  String get sourceAuthoritative =>
      'Base de composición alimentaria autoritativa';

  @override
  String get sourcePackaged => 'Base de alimentos envasados';

  @override
  String get sourceNutrivoyaCurated => 'Conjunto de datos de Nutrivoya';

  @override
  String get sourceRecipeEstimated => 'Estimación basada en receta';

  @override
  String get sourceUserSubmitted => 'Enviado por el usuario';

  @override
  String get portionLabel => 'Porción';

  @override
  String get portionSmall => 'Pequeña';

  @override
  String get portionMedium => 'Mediana';

  @override
  String get portionLarge => 'Grande';

  @override
  String get portionGrams => 'Gramos';

  @override
  String get portionQuantity => 'Cantidad';

  @override
  String get portionCustom => 'Gramos personalizados';

  @override
  String get nutrientEnergyKcal => 'Calorías';

  @override
  String get nutrientProteinG => 'Proteína';

  @override
  String get nutrientCarbohydrateG => 'Carbohidratos';

  @override
  String get nutrientFatG => 'Grasa';

  @override
  String get nutrientFibreG => 'Fibra';

  @override
  String get nutrientSaturatedFatG => 'Grasa saturada';

  @override
  String get nutrientSugarG => 'Azúcar';

  @override
  String get nutrientSodiumMg => 'Sodio';

  @override
  String get nutrientIronMg => 'Hierro';

  @override
  String get nutrientCalciumMg => 'Calcio';

  @override
  String get nutrientPotassiumMg => 'Potasio';

  @override
  String get nutrientMagnesiumMg => 'Magnesio';

  @override
  String get nutrientZincMg => 'Zinc';

  @override
  String get nutrientVitaminAUg => 'Vitamina A';

  @override
  String get nutrientVitaminCMg => 'Vitamina C';

  @override
  String get nutrientVitaminDUg => 'Vitamina D';

  @override
  String get nutrientVitaminB12Ug => 'Vitamina B12';

  @override
  String get nutrientFolateUg => 'Folato';

  @override
  String get foodDetailsTitle => 'Detalles del alimento';

  @override
  String get foodDetailsAddToMeal => 'Añadir a la comida';

  @override
  String get foodDetailsPerPortion => 'por porción';

  @override
  String get foodDetailsPer100g => 'por 100 g';

  @override
  String get foodDetailsPreparationNote =>
      'La preparación y el tamaño de la porción pueden cambiar los valores.';

  @override
  String get foodDetailsNoData => 'Datos nutricionales no disponibles';

  @override
  String get foodDetailsApprox => '≈';

  @override
  String get foodDetailsLoggingSoon =>
      'El registro de alimentos llega en el próximo hito.';

  @override
  String get foodDetailsMacros => 'Macros';

  @override
  String get foodDetailsMicronutrients => 'Micronutrientes';

  @override
  String get foodDetailsCuisine => 'Cocina';

  @override
  String get foodDetailsRegion => 'Región';

  @override
  String get foodDetailsAliases => 'También conocido como';

  @override
  String searchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados',
      one: '1 resultado',
      zero: 'Sin resultados',
    );
    return '$_temp0';
  }

  @override
  String get searchTryExample => 'Prueba: roti, arroz jollof, dal, mango';

  @override
  String get diaryAddToMealTitle => '¿Añadir a qué comida?';

  @override
  String diaryEntryAdded(String food, String meal) {
    return '$food añadido a $meal';
  }

  @override
  String get diaryEntryDeleted => 'Entrada eliminada';

  @override
  String get diaryEntryUpdated => 'Entrada actualizada';

  @override
  String get diaryEditEntry => 'Editar entrada';

  @override
  String get diaryDeleteEntry => 'Eliminar entrada';

  @override
  String get diaryConfirmDelete => '¿Quitar esta entrada de tu diario?';

  @override
  String get diaryConfirmDeleteYes => 'Quitar';

  @override
  String get diaryGramsLabel => 'Gramos';

  @override
  String get diaryQuantityLabel => 'Cantidad';

  @override
  String get diaryNoEntriesForMeal => 'Aún no hay entradas';

  @override
  String get diaryKcalShort => 'kcal';

  @override
  String get diarySelectDate => 'Seleccionar fecha';

  @override
  String get diaryToday => 'Hoy';

  @override
  String get diaryYesterday => 'Ayer';

  @override
  String diaryEntryCalories(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get recipesTitle => 'Mis recetas';

  @override
  String get recipesCreate => 'Crear receta';

  @override
  String get recipesEdit => 'Editar receta';

  @override
  String get recipesEmptyTitle => 'Aún no hay recetas personales';

  @override
  String get recipesEmptyBody =>
      'Guarda recetas familiares como el jollof de mamá o el dal de la abuela para registrar las versiones que cocinas de verdad.';

  @override
  String get recipesNameLabel => 'Nombre de la receta';

  @override
  String get recipesServingsLabel => 'Raciones';

  @override
  String get recipesYieldLabel => 'Rendimiento total (g)';

  @override
  String get recipesYieldHint =>
      'Opcional — por defecto la suma de ingredientes';

  @override
  String get recipesIngredients => 'Ingredientes';

  @override
  String get recipesIngredientsEmpty =>
      'Añade ingredientes para calcular la nutrición.';

  @override
  String get recipesAddIngredient => 'Añadir ingrediente';

  @override
  String get recipesNotesLabel => 'Notas';

  @override
  String get recipesCalculatedNutrition => 'Nutrición calculada';

  @override
  String recipesWholeRecipeKcal(int kcal) {
    return 'Receta completa: ≈ $kcal kcal';
  }

  @override
  String recipesPerServingKcal(int kcal) {
    return '≈ $kcal kcal por ración';
  }

  @override
  String recipesServingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count raciones',
      one: '1 ración',
    );
    return '$_temp0';
  }

  @override
  String get recipesPerServingShort => 'ración';

  @override
  String get recipesCalculationNote =>
      'Calculada a partir de tus ingredientes y cantidades. La preparación y el rendimiento pueden cambiar los valores.';

  @override
  String get recipesDeleteTitle => '¿Eliminar receta?';

  @override
  String get recipesDeleteBody =>
      'Esto elimina la receta de tu colección personal. Las entradas ya registradas en el diario no se ven afectadas.';

  @override
  String get barcodeTitle => 'Escanear código de barras';

  @override
  String get barcodeHint =>
      'Apunta la cámara a un código de barras de un alimento envasado, o introduce el número manualmente.';

  @override
  String get barcodeManualLabel => 'Número de código de barras';

  @override
  String get barcodeManualHint => 'p. ej. 3017620422003';

  @override
  String get barcodeLookupButton => 'Buscar producto';

  @override
  String get barcodeCameraUnavailable =>
      'Cámara no disponible en este dispositivo. Introduce el código de barras manualmente.';

  @override
  String get barcodeNotFoundTitle => 'Producto no encontrado';

  @override
  String barcodeNotFoundBody(String barcode) {
    return 'Ningún alimento envasado coincidió con el código $barcode. Puedes intentarlo de nuevo o añadir el alimento de otra forma.';
  }

  @override
  String get barcodeInvalid =>
      'Eso no parece un código de barras válido. Usa de 8 a 14 dígitos.';

  @override
  String get barcodeNetworkError =>
      'No se pudo alcanzar la base de alimentos envasados. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get barcodeTryAgain => 'Intentar de nuevo';

  @override
  String get barcodeCrowdsourcedNote =>
      'Los datos de alimentos envasados provienen de Open Food Facts y pueden estar incompletos o ser colaborativos. Verifica siempre el tamaño de la porción antes de registrar.';

  @override
  String get assistantTitle => 'Pregunta a Nutrivoya';

  @override
  String get assistantIntro =>
      'Pregunta sobre tus comidas, alimentos culturales, proteínas o hambre: las respuestas usan tu diario, objetivos y base de alimentos. Nunca se inventan cifras.';

  @override
  String get assistantWellnessDisclaimer =>
      'Nutrivoya ofrece orientación general de bienestar, no consejo médico.';

  @override
  String get assistantMedicalDisclaimer =>
      'Esto parece un tema médico o de alto riesgo. Habla con un profesional de la salud cualificado. Nutrivoya no diagnostica, trata ni prescribe.';

  @override
  String get assistantTryAsking => 'Prueba a preguntar';

  @override
  String get assistantSuggestions => 'Sugerencias';

  @override
  String get assistantSources => 'Fuentes';

  @override
  String get assistantInputHint =>
      'Pregunta sobre arroz, proteína, equilibrio…';

  @override
  String get assistantSend => 'Enviar';

  @override
  String get assistantClear => 'Borrar chat';

  @override
  String get assistantPromptRice =>
      '¿Puedo seguir comiendo arroz mientras bajo de peso?';

  @override
  String get assistantPromptBalance => '¿Cómo equilibro las comidas de hoy?';

  @override
  String get assistantPromptProtein =>
      '¿Cómo subo la proteína con alimentos familiares?';

  @override
  String get assistantPromptHunger =>
      '¿Por qué sigo con hambre cerca de mi objetivo de calorías?';

  @override
  String get assistantPromptRoti => '¿Cuántas calorías tiene el roti?';

  @override
  String assistantHeadlineCultural(String staple) {
    return 'Sí — $staple puede encajar en tus objetivos';
  }

  @override
  String get assistantHeadlineBalance => 'Equilibrio de las comidas de hoy';

  @override
  String get assistantHeadlineProtein =>
      'Subir proteína con alimentos familiares';

  @override
  String get assistantHeadlineHunger => 'Hambre cerca de tu objetivo calórico';

  @override
  String assistantHeadlineLookupFound(String foodName) {
    return 'Nutrición de $foodName';
  }

  @override
  String assistantHeadlineLookupMissing(String foodName) {
    return 'Sin coincidencia para “$foodName”';
  }

  @override
  String get assistantHeadlineSubstitute => 'Modifica antes de sustituir';

  @override
  String get assistantHeadlineMedical => 'Busca orientación profesional';

  @override
  String get assistantHeadlineUnknown => 'Necesito una pregunta más clara';

  @override
  String assistantBodyCultural(String staple, String cuisine) {
    return '$staple forma parte habitual de la comida $cuisine. No hace falta abandonarlo: ajusta porciones y acompañamientos según tu objetivo.';
  }

  @override
  String assistantBodyCulturalWithData(
    String staple,
    String foodName,
    String portionName,
    int kcal,
    String sourceName,
  ) {
    return '$staple puede quedarse en tu patrón. Según la base, $foodName ($portionName) tiene unas $kcal kcal ($sourceName). Prefiere una porción menor o añade verduras y una fuente de proteína en lugar de eliminar el alimento.';
  }

  @override
  String assistantBodyBalanceWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int proteinTarget,
    int entryCount,
  ) {
    return 'Hoy has registrado $caloriesConsumed de $calorieTarget kcal y $proteinConsumed de $proteinTarget g de proteína en $entryCount entradas. Usa alimentos familiares y ajustes pequeños — sin moralizar.';
  }

  @override
  String assistantBodyBalanceNoTargets(
    int caloriesConsumed,
    int proteinConsumed,
    int entryCount,
  ) {
    return 'Hoy has registrado $caloriesConsumed kcal y $proteinConsumed g de proteína en $entryCount entradas. Define objetivos en Ajustes para más claridad, o sigue registrando comidas familiares.';
  }

  @override
  String assistantBodyProteinWithTargets(
    int proteinConsumed,
    int proteinTarget,
    int proteinGap,
    String cuisine,
  ) {
    return 'Has registrado $proteinConsumed de $proteinTarget g de proteína hoy (faltan $proteinGap g). Mantén los alimentos $cuisine y añade acompañamientos ricos en proteína.';
  }

  @override
  String assistantBodyProtein(int proteinConsumed, String cuisine) {
    return 'Has registrado $proteinConsumed g de proteína hoy. Súbela con acompañamientos $cuisine familiares en lugar de sustituir tus comidas.';
  }

  @override
  String assistantBodyHungerWithTargets(
    int caloriesConsumed,
    int calorieTarget,
    int proteinConsumed,
    int fibreConsumed,
  ) {
    return 'Estás en $caloriesConsumed de $calorieTarget kcal, con $proteinConsumed g de proteína y $fibreConsumed g de fibra. El hambre puede deberse a proteína, fibra, ritmo de comida o agua — no a un fallo moral.';
  }

  @override
  String assistantBodyHunger(
    int caloriesConsumed,
    int proteinConsumed,
    int fibreConsumed,
  ) {
    return 'Has registrado $caloriesConsumed kcal, $proteinConsumed g de proteína y $fibreConsumed g de fibra. El hambre suele mejorar con proteína, fibra y comer más despacio — no etiquetando alimentos como malos.';
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
    return '$foodName · $portionName: ≈ $kcal kcal y $proteinG g de proteína. Fuente: $sourceName. Confianza: $confidence.';
  }

  @override
  String assistantBodyLookupNoNutrition(String foodName, String sourceName) {
    return '$foodName se encontró en $sourceName, pero no hay datos calóricos fiables. Nutrivoya no inventará un número.';
  }

  @override
  String assistantBodyLookupMissing(String foodName) {
    return 'Ningún alimento estructurado coincide con “$foodName”. Prueba otro nombre, un código de barras o una receta personal — no se adivinarán las calorías.';
  }

  @override
  String get assistantBodySubstitute =>
      'Empieza cambiando el tamaño de la porción, añadiendo verduras o acompañando con proteína. Sustituir es opcional: modificar suele conservar las comidas culturales.';

  @override
  String get assistantBodyMedical =>
      'Nutrivoya no puede aconsejar sobre diagnóstico, medicamentos, complicaciones del embarazo, trastornos alimentarios u otras situaciones clínicas. Consulta a un profesional adecuado.';

  @override
  String get assistantBodyUnknown =>
      'Prueba preguntas como “¿Puedo seguir comiendo arroz?”, “¿Cómo subo la proteína?”, “¿Cuántas calorías tiene el roti?” o “¿Por qué sigo con hambre?”';

  @override
  String get assistantTipAskRice =>
      'Pregunta si un alimento cultural encaja en tus objetivos';

  @override
  String get assistantTipAskBalance =>
      'Pregunta cómo se ven las comidas de hoy frente a tus objetivos';

  @override
  String get assistantTipAskProtein =>
      'Pregunta cómo subir proteína con alimentos familiares';

  @override
  String get assistantTipAskFoodLookup =>
      'Pregunta “calorías en …” para un alimento de la base';

  @override
  String get assistantTipSeekProfessional =>
      'Contacta con un médico, dietista u otro clínico cualificado';

  @override
  String get assistantTipFoodNotFound =>
      'Prueba otra ortografía, un alias o escanear el código de barras';

  @override
  String get assistantTipNutritionUnavailable =>
      'Datos nutricionales no disponibles — sin calorías inventadas';

  @override
  String get assistantTipVerifyPortion =>
      'Confirma que la porción coincide con lo que comiste';

  @override
  String get assistantTipNoMoralFood =>
      'Ningún alimento es bueno o malo por sí solo — importa el contexto';

  @override
  String get assistantTipHungerProteinFibre =>
      'Revisa proteína y fibra: ambas ayudan a la saciedad';

  @override
  String get assistantTipHungerPace =>
      'Come un poco más despacio e incluye verduras para volumen';

  @override
  String get assistantTipProteinPairDal =>
      'Combina cereales con dal, legumbres o lentejas';

  @override
  String get assistantTipProteinPairYoghurt =>
      'Añade yogur, paneer o lácteo colado';

  @override
  String get assistantTipProteinPairEgg =>
      'Añade huevo, pescado, tofu o carne magra según tu cocina';

  @override
  String get assistantTipModifyNotReplace =>
      'Modifica la comida que ya te gusta antes de sustituirla';

  @override
  String get assistantTipModifyPortion =>
      'Prueba primero una porción más pequeña del alimento base';

  @override
  String get assistantTipAddVegetables =>
      'Añade verduras o ensalada para volumen y fibra';

  @override
  String get assistantTipAddProteinSide =>
      'Añade un acompañamiento proteico en lugar de eliminar el alimento base';

  @override
  String get assistantTipLogSomething =>
      'Registra una comida para que el consejo use tu patrón real';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get progressIntro =>
      'Registra peso, agua y medidas como tendencias tranquilas: los cambios diarios son ruido, no un veredicto.';

  @override
  String get progressWater => 'Agua hoy';

  @override
  String progressWaterTotal(int total, int goal) {
    return '$total ml de $goal ml';
  }

  @override
  String progressWaterAdd(int ml) {
    return '+$ml ml';
  }

  @override
  String get progressWeight => 'Peso';

  @override
  String get progressLogWeight => 'Registrar peso';

  @override
  String get progressWeightKgLabel => 'Peso (kg)';

  @override
  String progressWeightValue(String kg) {
    return '$kg kg';
  }

  @override
  String get progressWeightEmpty =>
      'Aún no hay registros de peso. Añade unos cuantos en varios días para ver una tendencia calmada.';

  @override
  String get progressWeightInvalid =>
      'Introduce un peso plausible entre 20 y 400 kg.';

  @override
  String get progressTrendNote =>
      'Las tendencias usan un promedio de varios días. Los cambios de un solo día son normales y no se juzgan.';

  @override
  String get progressTrendInsufficient =>
      'Registra el peso unos días más para estimar una tendencia semanal.';

  @override
  String progressTrendSteady(String avg) {
    return 'Alrededor de $avg kg — bastante estable estos días.';
  }

  @override
  String progressTrendRising(String avg, String delta) {
    return 'Alrededor de $avg kg — subiendo con suavidad (~$delta kg/semana). Mira el patrón, no un solo día.';
  }

  @override
  String progressTrendFalling(String avg, String delta) {
    return 'Alrededor de $avg kg — bajando con suavidad (~$delta kg/semana). Mira el patrón, no un solo día.';
  }

  @override
  String get progressMeasurements => 'Medidas corporales';

  @override
  String get progressMeasurementsNote =>
      'Cintura y cadera opcionales en cm. No se usan para objetivos calóricos.';

  @override
  String get progressMeasurementsEmpty => 'Aún no hay medidas registradas.';

  @override
  String get progressLogMeasurement => 'Registrar medida';

  @override
  String get progressWaistLabel => 'Cintura (cm)';

  @override
  String get progressHipLabel => 'Cadera (cm)';

  @override
  String progressWaist(String cm) {
    return 'Cintura $cm cm';
  }

  @override
  String progressHip(String cm) {
    return 'Cadera $cm cm';
  }

  @override
  String get progressMeasurementInvalid => 'Introduce al menos una medida.';

  @override
  String get favouritesTitle => 'Favoritos';

  @override
  String get favouritesAdd => 'Añadir a favoritos';

  @override
  String get favouritesRemove => 'Quitar de favoritos';

  @override
  String get frequentFoodsTitle => 'Alimentos frecuentes';

  @override
  String get frequentFoodsEmpty =>
      'Los alimentos que registres a menudo aparecerán aquí.';

  @override
  String frequentFoodsCount(int count) {
    return 'Registrado $count veces';
  }

  @override
  String get templatesTitle => 'Plantillas de comidas';

  @override
  String get templatesIntro =>
      'Guarda las comidas familiares de un día y vuelve a aplicarlas — útil para desayunos habituales.';

  @override
  String get templatesEmpty =>
      'Aún no hay plantillas. Registra un día que te guste y guárdalo.';

  @override
  String get templatesSaveFromToday => 'Guardar desde hoy';

  @override
  String get templatesNameLabel => 'Nombre de la plantilla';

  @override
  String get templatesNeedEntries =>
      'Registra alimentos hoy antes de guardar una plantilla.';

  @override
  String get templatesSaved => 'Plantilla guardada';

  @override
  String get templatesApply => 'Aplicar a hoy';

  @override
  String templatesApplied(int count) {
    return 'Se añadieron $count elementos de la plantilla';
  }

  @override
  String templatesTodayCount(int count) {
    return '$count entradas del diario disponibles';
  }

  @override
  String templatesItemSummary(int count, int kcal) {
    return '$count elementos · ≈ $kcal kcal';
  }

  @override
  String get photoTitle => 'Comida con foto';

  @override
  String get photoIntro =>
      'Fotografía una comida, describe lo que ves y confirma un alimento de la base. La nutrición siempre viene de datos estructurados — nunca solo de la imagen.';

  @override
  String get photoUncertaintyDisclaimer =>
      'Las sugerencias por foto son inciertas. Confirma siempre el alimento y la porción antes de registrar. Las estimaciones de visión nunca se tratan como certezas.';

  @override
  String get photoTakePhoto => 'Tomar foto';

  @override
  String get photoChooseGallery => 'Elegir de la galería';

  @override
  String get photoRetake => 'Elegir otra foto';

  @override
  String get photoClear => 'Borrar foto';

  @override
  String get photoDescriptionLabel => '¿Qué ves?';

  @override
  String get photoDescriptionHint =>
      'p. ej. roti y dal, arroz jollof, bowl de pho';

  @override
  String get photoSuggestFoods => 'Sugerir alimentos';

  @override
  String get photoSuggestionsTitle => 'Posibles coincidencias';

  @override
  String get photoSuggestionsNote =>
      'Vienen de tu descripción buscada en la base — no de calorías inventadas a partir de la foto.';

  @override
  String get photoConfidenceUncertain => 'Coincidencia incierta — confirma';

  @override
  String get photoConfidenceLow => 'Coincidencia débil — revisa con cuidado';

  @override
  String get photoPortionTitle => 'Estimar porción';

  @override
  String get photoPortionNote =>
      'La porción de la foto es solo una estimación. Ajústala antes de registrar.';

  @override
  String get photoConfirmOpenFood => 'Confirmar y abrir alimento';

  @override
  String get photoConfirmNote =>
      'Luego verificarás la ración en la ficha del alimento. El registro usa solo nutrición estructurada.';

  @override
  String get photoDetailsEstimateNote =>
      'La porción se sugirió desde una foto y es incierta — verifica los gramos antes de registrar.';

  @override
  String get photoSearchSubtitle =>
      'Fotografía una comida y confirma un alimento de la base.';

  @override
  String get photoErrorNoImage => 'Añade primero una foto.';

  @override
  String get photoErrorNeedDescription =>
      'Describe lo que ves para buscar en la base. La app no inventa alimentos solo con píxeles.';

  @override
  String get photoErrorNoMatches =>
      'Ningún alimento estructurado coincidió. Prueba otro nombre o busca manualmente.';

  @override
  String get photoErrorFailed =>
      'No se pudo usar esa foto. Inténtalo de nuevo o elige otra imagen.';

  @override
  String get addProductTitle => 'Añadir producto';

  @override
  String get addProductIntro =>
      'Envía un alimento o producto envasado que falte a tu biblioteca personal. Los valores que introduzcas nunca se tratan como autoritativos.';

  @override
  String get addProductProvenanceNote =>
      'Deja la nutrición en blanco si no la conoces. Nutrivoya no inventa calorías ni macros.';

  @override
  String get addProductNameLabel => 'Nombre del producto o alimento';

  @override
  String get addProductBrandLabel => 'Marca (opcional)';

  @override
  String get addProductBarcodeLabel => 'Código de barras (opcional)';

  @override
  String get addProductCuisineLabel => 'Cocina o región (opcional)';

  @override
  String get addProductServingSection => 'Ración';

  @override
  String get addProductServingGramsLabel => 'Ración por defecto (gramos)';

  @override
  String get addProductPortionNameLabel => 'Nombre de la porción (opcional)';

  @override
  String get addProductNutritionSection => 'Nutrición por 100 g (opcional)';

  @override
  String get addProductNutritionHint =>
      'Introduce solo valores que conozcas de una etiqueta o fuente fiable. Mejor vacío que inventado.';

  @override
  String get addProductEnergyLabel => 'Energía (kcal / 100 g)';

  @override
  String get addProductProteinLabel => 'Proteína (g / 100 g)';

  @override
  String get addProductCarbLabel => 'Carbohidratos (g / 100 g)';

  @override
  String get addProductFatLabel => 'Grasa (g / 100 g)';

  @override
  String get addProductFibreLabel => 'Fibra (g / 100 g)';

  @override
  String get addProductNotesLabel => 'Notas (opcional)';

  @override
  String get addProductSubmit => 'Guardar en mi biblioteca';

  @override
  String get addProductSubmitNote =>
      'Se guarda como enviado por el usuario con revisión pendiente. Solo aparece en tu búsqueda — no como nutrición verificada.';

  @override
  String get addProductPublished =>
      'Guardado en tu biblioteca personal (revisión pendiente)';

  @override
  String get addProductErrorNameRequired =>
      'Introduce un nombre de producto o alimento.';

  @override
  String get addProductErrorNameShort => 'El nombre es demasiado corto.';

  @override
  String get addProductErrorServingInvalid =>
      'La ración debe estar entre 0 y 5000 gramos.';

  @override
  String get addProductErrorBarcodeInvalid =>
      'El código de barras debe tener 8–14 dígitos.';

  @override
  String get addProductErrorEnergyInvalid =>
      'La energía debe estar entre 0 y 950 kcal por 100 g.';

  @override
  String get addProductErrorProteinInvalid =>
      'La proteína debe estar entre 0 y 1000 g por 100 g.';

  @override
  String get addProductErrorCarbInvalid =>
      'Los carbohidratos deben estar entre 0 y 1000 g por 100 g.';

  @override
  String get addProductErrorFatInvalid =>
      'La grasa debe estar entre 0 y 1000 g por 100 g.';

  @override
  String get addProductErrorFibreInvalid =>
      'La fibra debe estar entre 0 y 1000 g por 100 g.';

  @override
  String get addProductWarningNoNutrition =>
      'Sin nutrición — el alimento aparecerá como no disponible hasta que añadas valores.';

  @override
  String get addProductWarningNoEnergy =>
      'Falta la energía — solo con macros no se mostrarán calorías.';

  @override
  String get addProductWarningMacrosHigh =>
      'Proteína + carbohidratos + grasa superan 110 g por 100 g — revisa la etiqueta.';

  @override
  String get addProductStatusDraft => 'Borrador';

  @override
  String get addProductStatusPending => 'Revisión pendiente';

  @override
  String get addProductStatusPublished =>
      'En biblioteca personal (revisión pendiente)';

  @override
  String get addProductStatusWithdrawn => 'Retirado';

  @override
  String get mySubmissionsTitle => 'Mis envíos';

  @override
  String get mySubmissionsEmpty =>
      'Aún no hay envíos. Añade un producto que falte desde búsqueda, código de barras o Ajustes.';
}
