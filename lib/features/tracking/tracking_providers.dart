import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/body_measurement.dart';
import '../../core/models/diary_entry.dart';
import '../../core/models/favourite_food.dart';
import '../../core/models/frequent_food.dart';
import '../../core/models/meal_template.dart';
import '../../core/models/nutrition_confidence.dart';
import '../../core/models/water_log.dart';
import '../../core/models/weight_entry.dart';
import '../../core/services/weight_trend_service.dart';
import '../diary/diary_providers.dart';
import '../diary/diary_repository.dart';
import 'favourites_repository.dart';
import 'meal_template_repository.dart';
import 'tracking_repository.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepository(ref.watch(diaryDatabaseProvider));
});

final weightTrendServiceProvider = Provider<WeightTrendService>((ref) {
  return const WeightTrendService();
});

final weightEntriesProvider =
    StreamProvider.autoDispose<List<WeightEntry>>((ref) {
  return ref.watch(trackingRepositoryProvider).watchWeightEntries();
});

final weightTrendProvider = Provider.autoDispose<WeightTrend>((ref) {
  final entries = ref.watch(weightEntriesProvider).asData?.value ?? const [];
  return ref.watch(weightTrendServiceProvider).analyze(entries);
});

final bodyMeasurementsProvider =
    StreamProvider.autoDispose<List<BodyMeasurement>>((ref) {
  return ref.watch(trackingRepositoryProvider).watchMeasurements();
});

final dailyWaterProvider = StreamProvider.autoDispose<DailyWater>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(trackingRepositoryProvider).watchWaterForDate(date);
});

/// Tickable revision so SharedPreferences-backed lists refresh after writes.
final favouritesRevisionProvider = StateProvider<int>((ref) => 0);

final favouritesProvider = Provider.autoDispose<List<FavouriteFood>>((ref) {
  ref.watch(favouritesRevisionProvider);
  return ref.watch(favouritesRepositoryProvider).list();
});

final isFavouriteProvider =
    Provider.autoDispose.family<bool, String>((ref, foodId) {
  return ref.watch(favouritesProvider).any((f) => f.foodId == foodId);
});

final mealTemplatesRevisionProvider = StateProvider<int>((ref) => 0);

final mealTemplatesProvider = Provider.autoDispose<List<MealTemplate>>((ref) {
  ref.watch(mealTemplatesRevisionProvider);
  return ref.watch(mealTemplateRepositoryProvider).list();
});

/// Foods logged most often in the diary over the last 60 days.
final frequentFoodsProvider =
    FutureProvider.autoDispose<List<FrequentFood>>((ref) async {
  final repo = ref.watch(diaryRepositoryProvider);
  return frequentFoodsFromDiary(repo);
});

Future<List<FrequentFood>> frequentFoodsFromDiary(
  DiaryRepository repo, {
  int limit = 12,
}) async {
  final now = DateTime.now();
  final counts = <String, _FreqAcc>{};
  for (var i = 0; i < 60; i++) {
    final day =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
    final entries = await repo.entriesForDate(day);
    for (final e in entries) {
      final acc = counts.putIfAbsent(
        e.foodId,
        () => _FreqAcc(foodName: e.foodName),
      );
      acc.count += 1;
      if (acc.lastLoggedAt == null || e.loggedAt.isAfter(acc.lastLoggedAt!)) {
        acc.lastLoggedAt = e.loggedAt;
        acc.foodName = e.foodName;
      }
    }
  }
  final ranked = counts.entries
      .map(
        (e) => FrequentFood(
          foodId: e.key,
          foodName: e.value.foodName,
          logCount: e.value.count,
          lastLoggedAt: e.value.lastLoggedAt,
        ),
      )
      .toList()
    ..sort((a, b) {
      final byCount = b.logCount.compareTo(a.logCount);
      if (byCount != 0) return byCount;
      return (b.lastLoggedAt ?? DateTime(0))
          .compareTo(a.lastLoggedAt ?? DateTime(0));
    });
  return ranked.take(limit).toList();
}

class _FreqAcc {
  _FreqAcc({required this.foodName});
  String foodName;
  int count = 0;
  DateTime? lastLoggedAt;
}

class TrackingController extends Notifier {
  @override
  void build() {}

  TrackingRepository get _tracking => ref.read(trackingRepositoryProvider);
  FavouritesRepository get _favourites =>
      ref.read(favouritesRepositoryProvider);
  MealTemplateRepository get _templates =>
      ref.read(mealTemplateRepositoryProvider);
  DiaryRepository get _diary => ref.read(diaryRepositoryProvider);

  Future<void> logWeight(double kg, {DateTime? at, String? note}) async {
    await _tracking.addWeight(
      WeightEntry(
        weightKg: kg,
        loggedAt: at ?? DateTime.now(),
        note: note,
      ),
    );
  }

  Future<void> deleteWeight(int id) => _tracking.deleteWeight(id);

  Future<void> logMeasurement({
    double? waistCm,
    double? hipCm,
    DateTime? at,
    String? note,
  }) async {
    await _tracking.addMeasurement(
      BodyMeasurement(
        loggedAt: at ?? DateTime.now(),
        waistCm: waistCm,
        hipCm: hipCm,
        note: note,
      ),
    );
  }

  Future<void> deleteMeasurement(int id) => _tracking.deleteMeasurement(id);

  Future<void> addWaterMl(int ml, {DateTime? at}) async {
    if (ml <= 0) return;
    await _tracking.addWater(
      WaterLog(amountMl: ml, loggedAt: at ?? DateTime.now()),
    );
  }

  Future<void> toggleFavourite(FavouriteFood food) async {
    await _favourites.toggle(food);
    ref.read(favouritesRevisionProvider.notifier).state++;
  }

  Future<MealTemplate> saveTemplateFromToday({
    required String name,
    DateTime? date,
  }) async {
    final DateTime day = date ?? ref.read(selectedDateProvider);
    final entries = await _diary.entriesForDate(day);
    final template = MealTemplateRepository.fromDiaryEntries(
      id: 'tpl_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'Meal template' : name.trim(),
      entries: entries,
    );
    await _templates.save(template);
    ref.read(mealTemplatesRevisionProvider.notifier).state++;
    return template;
  }

  Future<void> deleteTemplate(String id) async {
    await _templates.delete(id);
    ref.read(mealTemplatesRevisionProvider.notifier).state++;
  }

  /// Apply a template to [date] (defaults to selected diary date).
  Future<int> applyTemplate(String templateId, {DateTime? date}) async {
    final template = _templates.getById(templateId);
    if (template == null) return 0;
    final DateTime day = date ?? ref.read(selectedDateProvider);
    var added = 0;
    for (final item in template.items) {
      final loggedAt = DateTime(
        day.year,
        day.month,
        day.day,
        12,
        added,
      );
      await _diary.add(
        DiaryEntry(
          foodId: item.foodId,
          foodName: item.foodName,
          foodCanonicalName: item.foodCanonicalName,
          mealType: item.mealType,
          grams: item.grams,
          portionName: item.portionName,
          quantity: item.quantity,
          caloriesKcal: item.caloriesKcal,
          proteinG: item.proteinG,
          carbohydrateG: item.carbohydrateG,
          fatG: item.fatG,
          fibreG: item.fibreG,
          confidence: NutritionConfidenceX.fromId(item.confidence),
          sourceName: item.sourceName,
          loggedAt: loggedAt,
        ),
      );
      added++;
    }
    return added;
  }
}

final trackingControllerProvider =
    NotifierProvider<TrackingController, void>(TrackingController.new);
