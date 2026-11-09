# Nutrivoya

> A multilingual, culturally intelligent nutrition and calorie-tracking app
> that helps people understand and improve the food they actually eat —
> without telling them that health requires abandoning their culture.

Nutrivoya challenges the assumption that healthy eating requires abandoning
culturally familiar food. It is built to understand traditional, regional,
indigenous, ethnic, diasporic and home-cooked foods with the same rigour as
Western packaged foods, and to evaluate food by its actual nutritional
composition, preparation, portion and dietary context — never by cultural
stereotype.

This repository currently contains **Milestones 1–11**:
Foundation, Food Data Core, Food Logging, Calorie & Macro Targets,
Cultural Food Intelligence (seed expansion), Recipe Builder,
Multilingual Product, Barcode Products, Nutrition Assistant,
Advanced Tracking, and Photo Recognition.

## Status — Milestone 11 (Photo Recognition)

Milestone 11 adds a photo-assisted logging flow that **never** treats
computer-vision estimates as certain and **never** invents calories from
pixels:

- Capture or pick a meal photo (`image_picker`)
- User describes what they see → structured `FoodRepository` search
- Uncertain / low-confidence suggestions only
- Portion estimate from cultural servings — user must confirm
- Hand-off to food details for final verify + log

Pluggable `FoodPhotoRecognizer` (default: description-assisted search).
A future on-device model can emit query tokens; nutrition still comes
only from structured food records.

## Status — Milestone 10 (Advanced Tracking)

Milestone 10 adds calm progress tracking and quick-log helpers:

- Weight logs with multi-day trend (average + weekly slope) — never a
  single-day verdict
- Optional waist/hip measurements (not used for calorie targets)
- Daily water logging
- Favourites (star on food details) and frequent foods in search
- Meal templates saved from a diary day and re-applied later
- Drift schema v2 for weight / measurements / water; favourites and
  templates in local preferences

## Status — Milestone 9 (Nutrition Assistant)

Milestone 9 adds **Ask Nutrivoya**: a rule-based nutrition assistant that
answers from diary totals, personal targets, familiar cuisines, and the
structured food repository. It never invents calorie values and never
moralises foods.

### What is included in Milestone 9

- `NutritionAssistantService` with intents for cultural staples, meal
  balance, protein, hunger, calorie lookup, substitution, and medical
  redirect
- Structured `AssistantAnswer` facts + tip keys + citations (UI localises)
- Food lookup wired through `FoodRepository` only — no LLM calorie source
- Ask Nutrivoya screen with starter prompts, sources, and wellness /
  medical disclaimers
- Settings entry + `/assistant` route
- Localised assistant copy for en / fr / es / hi / pa / ar
- Unit tests for intent routing and reply formatting

## Status — Milestone 8 (Barcode Products)

Milestone 8 adds packaged-food barcode lookup behind
`PackagedFoodRepository`, with a real Open Food Facts adapter, camera
scanning (plus manual entry), serving verification on the existing food
details screen, and clear crowdsourced-data caveats.

### What is included in Milestone 8

- `PackagedFoodRepository` + barcode normalization helpers
- `OpenFoodFactsAdapter` (dio) mapping OFF nutriments → per-100 g `Food`
  with `FoodSourceType.packaged` and medium confidence
- In-memory barcode cache; `off:{barcode}` food ids
- `BarcodeScannerScreen` using `mobile_scanner` + manual barcode entry
- Search entry points (app bar + suggestions list)
- Composite food repository wires barcode digit queries and `off:` getById
- Android CAMERA/INTERNET permissions; iOS `NSCameraUsageDescription`
- Adapter and repository unit tests with a fake Dio adapter

Crowdsourced OFF entries are never treated as authoritative. Users must
verify serving size before logging.

## Status — Milestone 7 (Multilingual Product)

Milestone 7 fills validated UI translations for the MVP language set,
expands multilingual / script food aliases, and hardens RTL behaviour
for Arabic.

### What is included in Milestone 7

- Complete ARB translations for English, French, Spanish, Hindi,
  Punjabi (Gurmukhi) and Arabic (no longer English fallback stubs)
- Expanded food-name aliases across scripts (Devanagari, Gurmukhi,
  Arabic) and Romance-language translations
- `FoodName.normalize` keeps non-Latin scripts searchable and folds
  Latin diacritics / combining marks
- RTL-safe layout tweaks (`AlignmentDirectional`, `TextAlign.end`,
  `EdgeInsetsDirectional`)
- Widget tests asserting each locale loads real strings and Arabic
  resolves to `TextDirection.rtl`
- Search tests for Devanagari, Punjabi, Arabic and French aliases

Translations are drafted for product use; native-speaker review remains
welcome for idiomatic polish. Do not treat unreviewed machine tone as
final brand voice.

## Status — Milestone 6 (Recipe Builder)

Milestone 6 adds personal recipe creation with structured nutrition
calculation from ingredients — never from an LLM inventing calories.

### What is included in Milestone 6

- `Recipe` and `RecipeIngredient` models with JSON persistence
- `RecipeNutritionService` — ingredients → quantities → yield →
  nutrients per 100 g → per serving
- Offline `RecipeRepository` (SharedPreferences)
- Recipes list, create/edit, and details screens
- Ingredient picker backed by the food search repository
- Entry points from Search (“My recipes”) and Settings
- Tests for recipe nutrition calculation

## Status — Milestone 5 (Cultural Food Intelligence — seed)

Milestone 5 expands the curated offline dataset across continents and
strengthens multilingual aliases / culturally meaningful portions.

### What is included in Milestone 5

- Expanded `LocalFoodDataset` (30+ foods) spanning South Asia, West &
  East Africa, East & Southeast Asia, Latin America, the Caribbean,
  Middle East / North Africa, and Eastern Europe
- Alias / transliteration coverage (e.g. aubergine / brinjal / baingan /
  बैंगन; dahi / laban; pho / phở bò)
- Regional portions (fufu balls, injera pieces, katori, arepas, …)
- Provenance + confidence retained on every record
- Dataset coverage tests

## Status — Milestone 4 (Calorie & Macro Targets)

Milestone 4 introduces evidence-based energy and macro target calculation
isolated in a tested domain service, wired through onboarding, goals and
the dashboard.

### What is included in Milestone 4

- `EnergyRequirementService` — Mifflin–St Jeor BMR, activity multipliers,
  goal-based calorie adjustment, protein/carb/fat/fibre targets
- Safety guardrails: deficit caps, minimum calorie floors, low-BMI loss
  warnings, age / unspecified-physio confidence notes
- `EnergyRequirementResult` + enriched `NutritionTargets` (BMR/TDEE)
- Onboarding summary shows live estimated targets
- Onboarding language step wired to locale controller
- Goals screen shows BMR, TDEE, targets and warnings
- Dashboard shows consumed / target calories, remaining, and macro
  progress (`82 / 120 g` style)
- Unit tests for BMR/TDEE, goals, macros and guardrails

## Status — Milestone 3 (Food Logging)

Milestone 3 builds the food diary: offline-first persistence (drift/SQLite),
a diary entry model that snapshots food data at log time, a repository with
CRUD + daily totals + recent foods, reactive Riverpod state, a meal-type
picker wired into the food details "Add to Meal" flow, a live dashboard with
calorie and macro totals, and a full diary screen with edit/delete.

### What is included in Milestone 3

- `DiaryEntry` model — food snapshot (id, name, canonical name), meal type,
  grams, portion name, quantity, computed macros at log time, confidence,
  source, timestamp, sync-pending flag
- `DailyTotals` — calories, protein, carbs, fat, fibre, entry count
- `DiaryDatabase` — drift/SQLite offline-first database with `DiaryEntries`
  table
- `DiaryRepository` — add / update / delete / entries-for-date /
  entries-for-meal / daily totals / recent foods / pending sync count +
  reactive streams
- `DiaryController` + Riverpod providers — reactive diary state, selected
  date, live entries and totals streams
- Meal-type picker bottom sheet on the food details screen
- "Add to Meal" logs the entry, shows a confirmation snackbar with a
  "Diary" action, and navigates home
- Dashboard — live calorie card, macro row, meal sections with per-meal
  calories, date picker
- Diary screen — full day grouped by meal type, per-meal calories,
  edit (grams/quantity) and delete with confirmation
- Localization strings for diary logging, meal picker, edit/delete
- Tests for the diary model, repository (in-memory drift), and the food
  details add-to-meal flow

### Offline-first design

- All diary entries are stored locally in SQLite (drift).
- Food data is snapshotted at log time so the diary is accurate even if the
  underlying food data changes later.
- New entries are flagged `syncPending = true` for a future Supabase sync
  layer.
- The diary works fully offline; no network is required to log, edit, or
  view entries.

Milestone 2 builds the food data architecture: the canonical food model,
multilingual name ontology, nutrient model (per 100 g), culturally meaningful
portions, full data provenance and confidence scoring, a multi-source food
repository, a ranked search service, a curated offline dataset, a real USDA
FoodData Central adapter, and the food details + portion selector UI.

### What is included in Milestone 2

- `Food`, `FoodName`, `Nutrient`/`NutrientCode`, `FoodPortion`, `FoodSource`
  and `FoodSearchResult` models
- `NutritionConfidence` (high / medium / estimated / unknown)
- `NutritionCalculator` — scales per-100g data to portion grams; never
  fabricates missing values
- `FoodRepository` abstraction with a multi-tier `CompositeFoodRepository`
  (local curated + optional USDA) and a `LocalFoodRepository`
- `FoodSearchService` — normalize → exact primary → exact alias →
  cuisine-preferred → prefix → contains → fuzzy, with deduplication and
  ranking
- `LocalFoodDataset` — curated seed with real, attributed USDA per-100g
  values for common foods plus clearly-estimated cultural dishes (roti, dal,
  jollof rice, egusi soup) marked medium/estimated confidence
- `UsdaFoodDataCentralAdapter` — real HTTP adapter (dio) to the USDA
  FoodData Central API, configured via `--dart-define=USDA_FDC_API_KEY=`
- Food search screen with live ranked results
- Food details screen — the "Food Result Card" (≈kcal, macros, fibre,
  confidence, source, micronutrients, aliases, cuisine/region)
- Portion selector — culturally meaningful portions (1 roti, 1 katori,
  1 medium plate, …) + custom grams + quantity, with live nutrition
- `/food/:id` route
- Localization strings for nutrients, confidence, portions and food details
- Tests for models, calculator, search service, local dataset, repository
  and the details screen

### Data integrity principles

- All nutrient data is stored **per 100 g edible portion**.
- Missing nutrients are stored as `null` — never fabricated.
- Every food carries a `FoodSource` (type, name, reference, review status,
  confidence, updated_at).
- Cultural composite dishes are marked `estimated`/`medium` with recipe-based
  notes, not presented as precise.
- The USDA adapter is a real connection to a trusted dataset; it is not a
  mock. When unconfigured, the app falls back to the local curated dataset.
- The LLM is never used as a food database.

## Status — Milestone 1 (Foundation)

Milestone 1 establishes the standalone Flutter application, its architecture,
branding, theming, localization infrastructure, authentication, onboarding,
profile/goal models and the navigation shells for the core features. It
intentionally does **not** include food data, calorie calculations, barcode
scanning, photo recognition or AI features — those arrive in later milestones.

### What is included

- Brand-new standalone Flutter project (`com.nutrivoya.app`)
- Nutrivoya display name on iOS and Android
- Material 3 design with light / dark / system theme
- Riverpod state management
- go_router navigation with auth + onboarding redirects
- Localization architecture using `flutter_localizations` + `intl` + ARB files
- English localization (complete) plus placeholder files for
  French, Spanish, Hindi, Punjabi and Arabic (awaiting native validation)
- Supabase initialization abstraction (runs in offline mode when unconfigured)
- Auth repository + login / signup / password-reset screens
- Multi-step onboarding flow (goal, profile, cuisines, language, summary)
- User profile, nutrition goal, activity level and physiological-input models
- Nutrition targets model (placeholders; calculated in Milestone 4)
- Dashboard, diary, food-search, settings, profile and goals shells
- Bottom navigation
- Unit and widget tests

### What remains intentionally out of scope

- User-contributed “Add Product” publish workflow (submission + review)
- Supabase diary sync (entries are flagged `syncPending`)
- Full LLM chatbot (Ask Nutrivoya is structured / rule-based)
- Photo calorie detection (vision never invents kcal)
- Wearables / social / grocery delivery

## Project structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart            # Root MaterialApp.router
│   ├── bootstrap.dart      # Async init (Supabase, SharedPreferences)
│   ├── router.dart         # go_router config + redirects
│   ├── theme.dart          # Material 3 light/dark themes
│   └── main_shell.dart     # Bottom navigation host
├── core/
│   ├── api/                # Supabase bootstrap abstraction
│   ├── config/             # App config (compile-time env)
│   ├── database/           # Drift diary database + table definitions
│   ├── errors/             # Sealed AppError types
│   ├── localization/       # Locale controller + generated localizations
│   ├── models/             # Domain models (food, nutrient, diary, profile, goals)
│   ├── storage/            # LocalPreferences, theme controller
│   └── utils/              # NutritionCalculator
├── features/
│   ├── auth/               # Auth repository, controller, screens
│   ├── food/               # Food repository, search service, data adapters
│   ├── food_search/        # Search screen
│   ├── food_details/       # Details screen + portion selector
│   ├── diary/              # Diary repository, providers, screen
│   ├── onboarding/         # Multi-step onboarding
│   ├── dashboard/          # Today screen (live totals)
│   ├── profile/            # Profile repo, controller, screen
│   ├── goals/              # Goals shell
│   ├── barcode/            # Barcode scanner + packaged lookup
│   ├── recipes/            # Personal recipe builder
│   ├── assistant/          # Ask Nutrivoya (rule-based guidance)
│   ├── tracking/           # Progress, favourites, templates, water
│   ├── photo/              # Photo-assisted food suggestions
│   └── settings/           # Settings (theme, language, account, about)
├── l10n/                   # ARB source files
└── shared/
    ├── extensions/         # AppLocalizations context extension
    └── widgets/            # Reusable widgets (EmptyState, …)
```

## Getting started

### Prerequisites

- Flutter 3.41.x (stable), Dart 3.11+
- A Supabase project (optional for Milestone 1 — the app runs without it)

### Install dependencies

```bash
flutter pub get
```

### Configure Supabase (optional)

Nutrivoya reads Supabase credentials as compile-time constants. Copy the
example env file and fill in your values, then run with `--dart-define`:

```bash
cp .env.example .env
# Edit .env with your Supabase URL and publishable/anon key

flutter run \
  --dart-define=SUPABASE_URL=YOUR_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_KEY \
  --dart-define=USDA_FDC_API_KEY=YOUR_USDA_KEY
```

When the Supabase constants are empty, the app uses an
`UnconfiguredAuthRepository` and runs in a limited offline/demo mode so the
UI and tests stay functional. The USDA FoodData Central adapter is optional;
without a key, food search uses the local curated dataset.

### Run the app

```bash
flutter run
```

### Analyze

```bash
flutter analyze
```

### Test

```bash
flutter test
```

## Localization

Localization uses Flutter's official `gen-l10n` tooling.

- Source ARB files live in `lib/l10n/` (`app_en.arb` is the template).
- Configuration is in `l10n.yaml`.
- Generated output goes to `lib/core/localization/generated/` (excluded from
  analysis).
- To add a language: create `lib/l10n/app_<locale>.arb`, add the locale code
  to `AppConfig.supportedLocaleCodes`, add the asset entry in `pubspec.yaml`,
  and run `flutter gen-l10n`.

> MVP locales (en, fr, es, hi, pa, ar) ship with complete ARB coverage.
> Native-speaker review remains welcome for idiomatic polish; Nutrivoya
> does not claim brand-perfect phrasing in every language until reviewed.

## Architecture notes

- **State management:** Riverpod (`flutter_riverpod`).
- **Routing:** go_router with a refresh notifier that re-evaluates redirects
  on auth/onboarding state changes.
- **Backend abstraction:** `SupabaseBootstrap` initializes Supabase only when
  credentials are present; `AuthRepository` is an interface with a Supabase
  implementation and an unconfigured fallback, keeping auth logic out of
  widgets and swappable later.
- **Offline-first intent:** user profile and preferences are persisted locally
  via `SharedPreferences`. Diary sync arrives in Milestone 3.
- **Domain models** are immutable value types with stable `id` strings for
  storage and `l10nKey` mappings for the UI.
- **Safety & respect:** the goal enum never forces weight loss; physiological
  calculation input is kept separate from gender identity; onboarding explains
  why each piece of information is requested.

## Safety scope

Nutrivoya is a wellness and nutrition-tracking app. It does not diagnose or
treat disease. For high-risk circumstances (eating disorders, pregnancy
complications, severe underweight, children, significant chronic illness,
medically prescribed diets) the app encourages appropriate professional
guidance. Aggressive weight-loss targets are not enabled in pregnancy.

## Next milestone

Core milestones 1–11 from the original plan are implemented. Remaining
product work includes diary sync, user-contributed products, and deeper
on-device recognition models — always with user confirmation and
structured nutrition lookup.
