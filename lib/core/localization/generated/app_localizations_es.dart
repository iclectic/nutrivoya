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
}
