import 'package:drift/drift.dart';

/// Drift table for diary entries.
///
/// Stores a food snapshot at log time so the diary works offline even if the
/// underlying food data changes later. Macros are computed at log time from
/// the food's per-100g data and the selected portion/grams.
@DataClassName('DiaryEntryRow')
class DiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get foodId => text()();
  TextColumn get foodName => text()();
  TextColumn get foodCanonicalName => text()();
  TextColumn get mealType => text()();
  RealColumn get grams => real()();
  TextColumn get portionName => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get caloriesKcal => real().nullable()();
  RealColumn get proteinG => real().nullable()();
  RealColumn get carbohydrateG => real().nullable()();
  RealColumn get fatG => real().nullable()();
  RealColumn get fibreG => real().nullable()();
  TextColumn get confidence => text().withDefault(const Constant('unknown'))();
  TextColumn get sourceName => text().nullable()();
  DateTimeColumn get loggedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get syncPending => boolean().withDefault(const Constant(false))();
}
