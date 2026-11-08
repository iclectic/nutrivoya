// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_database.dart';

// ignore_for_file: type=lint
class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodCanonicalNameMeta = const VerificationMeta(
    'foodCanonicalName',
  );
  @override
  late final GeneratedColumn<String> foodCanonicalName =
      GeneratedColumn<String>(
        'food_canonical_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionNameMeta = const VerificationMeta(
    'portionName',
  );
  @override
  late final GeneratedColumn<String> portionName = GeneratedColumn<String>(
    'portion_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _caloriesKcalMeta = const VerificationMeta(
    'caloriesKcal',
  );
  @override
  late final GeneratedColumn<double> caloriesKcal = GeneratedColumn<double>(
    'calories_kcal',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbohydrateGMeta = const VerificationMeta(
    'carbohydrateG',
  );
  @override
  late final GeneratedColumn<double> carbohydrateG = GeneratedColumn<double>(
    'carbohydrate_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fibreGMeta = const VerificationMeta('fibreG');
  @override
  late final GeneratedColumn<double> fibreG = GeneratedColumn<double>(
    'fibre_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncPendingMeta = const VerificationMeta(
    'syncPending',
  );
  @override
  late final GeneratedColumn<bool> syncPending = GeneratedColumn<bool>(
    'sync_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodId,
    foodName,
    foodCanonicalName,
    mealType,
    grams,
    portionName,
    quantity,
    caloriesKcal,
    proteinG,
    carbohydrateG,
    fatG,
    fibreG,
    confidence,
    sourceName,
    loggedAt,
    createdAt,
    syncPending,
    remoteId,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('food_canonical_name')) {
      context.handle(
        _foodCanonicalNameMeta,
        foodCanonicalName.isAcceptableOrUnknown(
          data['food_canonical_name']!,
          _foodCanonicalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodCanonicalNameMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('portion_name')) {
      context.handle(
        _portionNameMeta,
        portionName.isAcceptableOrUnknown(
          data['portion_name']!,
          _portionNameMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('calories_kcal')) {
      context.handle(
        _caloriesKcalMeta,
        caloriesKcal.isAcceptableOrUnknown(
          data['calories_kcal']!,
          _caloriesKcalMeta,
        ),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbohydrate_g')) {
      context.handle(
        _carbohydrateGMeta,
        carbohydrateG.isAcceptableOrUnknown(
          data['carbohydrate_g']!,
          _carbohydrateGMeta,
        ),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('fibre_g')) {
      context.handle(
        _fibreGMeta,
        fibreG.isAcceptableOrUnknown(data['fibre_g']!, _fibreGMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_pending')) {
      context.handle(
        _syncPendingMeta,
        syncPending.isAcceptableOrUnknown(
          data['sync_pending']!,
          _syncPendingMeta,
        ),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      foodCanonicalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_canonical_name'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      portionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_name'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      caloriesKcal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_kcal'],
      ),
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      ),
      carbohydrateG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbohydrate_g'],
      ),
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      ),
      fibreG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre_g'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      ),
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_pending'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }
}

class DiaryEntryRow extends DataClass implements Insertable<DiaryEntryRow> {
  final int id;
  final String foodId;
  final String foodName;
  final String foodCanonicalName;
  final String mealType;
  final double grams;
  final String? portionName;
  final int quantity;
  final double? caloriesKcal;
  final double? proteinG;
  final double? carbohydrateG;
  final double? fatG;
  final double? fibreG;
  final String confidence;
  final String? sourceName;
  final DateTime loggedAt;
  final DateTime createdAt;
  final bool syncPending;

  /// Client-generated UUID shared with the Supabase row (schema v2).
  final String? remoteId;

  /// Last local modification, used for last-write-wins merging (schema v2).
  final DateTime? updatedAt;

  /// Soft-delete marker so deletions can be synced before purging (schema v2).
  final DateTime? deletedAt;
  const DiaryEntryRow({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.foodCanonicalName,
    required this.mealType,
    required this.grams,
    this.portionName,
    required this.quantity,
    this.caloriesKcal,
    this.proteinG,
    this.carbohydrateG,
    this.fatG,
    this.fibreG,
    required this.confidence,
    this.sourceName,
    required this.loggedAt,
    required this.createdAt,
    required this.syncPending,
    this.remoteId,
    this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<String>(foodId);
    map['food_name'] = Variable<String>(foodName);
    map['food_canonical_name'] = Variable<String>(foodCanonicalName);
    map['meal_type'] = Variable<String>(mealType);
    map['grams'] = Variable<double>(grams);
    if (!nullToAbsent || portionName != null) {
      map['portion_name'] = Variable<String>(portionName);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || caloriesKcal != null) {
      map['calories_kcal'] = Variable<double>(caloriesKcal);
    }
    if (!nullToAbsent || proteinG != null) {
      map['protein_g'] = Variable<double>(proteinG);
    }
    if (!nullToAbsent || carbohydrateG != null) {
      map['carbohydrate_g'] = Variable<double>(carbohydrateG);
    }
    if (!nullToAbsent || fatG != null) {
      map['fat_g'] = Variable<double>(fatG);
    }
    if (!nullToAbsent || fibreG != null) {
      map['fibre_g'] = Variable<double>(fibreG);
    }
    map['confidence'] = Variable<String>(confidence);
    if (!nullToAbsent || sourceName != null) {
      map['source_name'] = Variable<String>(sourceName);
    }
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_pending'] = Variable<bool>(syncPending);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      foodId: Value(foodId),
      foodName: Value(foodName),
      foodCanonicalName: Value(foodCanonicalName),
      mealType: Value(mealType),
      grams: Value(grams),
      portionName: portionName == null && nullToAbsent
          ? const Value.absent()
          : Value(portionName),
      quantity: Value(quantity),
      caloriesKcal: caloriesKcal == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesKcal),
      proteinG: proteinG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinG),
      carbohydrateG: carbohydrateG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbohydrateG),
      fatG: fatG == null && nullToAbsent ? const Value.absent() : Value(fatG),
      fibreG: fibreG == null && nullToAbsent
          ? const Value.absent()
          : Value(fibreG),
      confidence: Value(confidence),
      sourceName: sourceName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceName),
      loggedAt: Value(loggedAt),
      createdAt: Value(createdAt),
      syncPending: Value(syncPending),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DiaryEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntryRow(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<String>(json['foodId']),
      foodName: serializer.fromJson<String>(json['foodName']),
      foodCanonicalName: serializer.fromJson<String>(json['foodCanonicalName']),
      mealType: serializer.fromJson<String>(json['mealType']),
      grams: serializer.fromJson<double>(json['grams']),
      portionName: serializer.fromJson<String?>(json['portionName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      caloriesKcal: serializer.fromJson<double?>(json['caloriesKcal']),
      proteinG: serializer.fromJson<double?>(json['proteinG']),
      carbohydrateG: serializer.fromJson<double?>(json['carbohydrateG']),
      fatG: serializer.fromJson<double?>(json['fatG']),
      fibreG: serializer.fromJson<double?>(json['fibreG']),
      confidence: serializer.fromJson<String>(json['confidence']),
      sourceName: serializer.fromJson<String?>(json['sourceName']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncPending: serializer.fromJson<bool>(json['syncPending']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<String>(foodId),
      'foodName': serializer.toJson<String>(foodName),
      'foodCanonicalName': serializer.toJson<String>(foodCanonicalName),
      'mealType': serializer.toJson<String>(mealType),
      'grams': serializer.toJson<double>(grams),
      'portionName': serializer.toJson<String?>(portionName),
      'quantity': serializer.toJson<int>(quantity),
      'caloriesKcal': serializer.toJson<double?>(caloriesKcal),
      'proteinG': serializer.toJson<double?>(proteinG),
      'carbohydrateG': serializer.toJson<double?>(carbohydrateG),
      'fatG': serializer.toJson<double?>(fatG),
      'fibreG': serializer.toJson<double?>(fibreG),
      'confidence': serializer.toJson<String>(confidence),
      'sourceName': serializer.toJson<String?>(sourceName),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncPending': serializer.toJson<bool>(syncPending),
      'remoteId': serializer.toJson<String?>(remoteId),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  DiaryEntryRow copyWith({
    int? id,
    String? foodId,
    String? foodName,
    String? foodCanonicalName,
    String? mealType,
    double? grams,
    Value<String?> portionName = const Value.absent(),
    int? quantity,
    Value<double?> caloriesKcal = const Value.absent(),
    Value<double?> proteinG = const Value.absent(),
    Value<double?> carbohydrateG = const Value.absent(),
    Value<double?> fatG = const Value.absent(),
    Value<double?> fibreG = const Value.absent(),
    String? confidence,
    Value<String?> sourceName = const Value.absent(),
    DateTime? loggedAt,
    DateTime? createdAt,
    bool? syncPending,
    Value<String?> remoteId = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => DiaryEntryRow(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    foodName: foodName ?? this.foodName,
    foodCanonicalName: foodCanonicalName ?? this.foodCanonicalName,
    mealType: mealType ?? this.mealType,
    grams: grams ?? this.grams,
    portionName: portionName.present ? portionName.value : this.portionName,
    quantity: quantity ?? this.quantity,
    caloriesKcal: caloriesKcal.present ? caloriesKcal.value : this.caloriesKcal,
    proteinG: proteinG.present ? proteinG.value : this.proteinG,
    carbohydrateG: carbohydrateG.present
        ? carbohydrateG.value
        : this.carbohydrateG,
    fatG: fatG.present ? fatG.value : this.fatG,
    fibreG: fibreG.present ? fibreG.value : this.fibreG,
    confidence: confidence ?? this.confidence,
    sourceName: sourceName.present ? sourceName.value : this.sourceName,
    loggedAt: loggedAt ?? this.loggedAt,
    createdAt: createdAt ?? this.createdAt,
    syncPending: syncPending ?? this.syncPending,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DiaryEntryRow copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntryRow(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      foodCanonicalName: data.foodCanonicalName.present
          ? data.foodCanonicalName.value
          : this.foodCanonicalName,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      grams: data.grams.present ? data.grams.value : this.grams,
      portionName: data.portionName.present
          ? data.portionName.value
          : this.portionName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      caloriesKcal: data.caloriesKcal.present
          ? data.caloriesKcal.value
          : this.caloriesKcal,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbohydrateG: data.carbohydrateG.present
          ? data.carbohydrateG.value
          : this.carbohydrateG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      fibreG: data.fibreG.present ? data.fibreG.value : this.fibreG,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncPending: data.syncPending.present
          ? data.syncPending.value
          : this.syncPending,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntryRow(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('foodCanonicalName: $foodCanonicalName, ')
          ..write('mealType: $mealType, ')
          ..write('grams: $grams, ')
          ..write('portionName: $portionName, ')
          ..write('quantity: $quantity, ')
          ..write('caloriesKcal: $caloriesKcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbohydrateG: $carbohydrateG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('confidence: $confidence, ')
          ..write('sourceName: $sourceName, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('remoteId: $remoteId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    foodId,
    foodName,
    foodCanonicalName,
    mealType,
    grams,
    portionName,
    quantity,
    caloriesKcal,
    proteinG,
    carbohydrateG,
    fatG,
    fibreG,
    confidence,
    sourceName,
    loggedAt,
    createdAt,
    syncPending,
    remoteId,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntryRow &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.foodName == this.foodName &&
          other.foodCanonicalName == this.foodCanonicalName &&
          other.mealType == this.mealType &&
          other.grams == this.grams &&
          other.portionName == this.portionName &&
          other.quantity == this.quantity &&
          other.caloriesKcal == this.caloriesKcal &&
          other.proteinG == this.proteinG &&
          other.carbohydrateG == this.carbohydrateG &&
          other.fatG == this.fatG &&
          other.fibreG == this.fibreG &&
          other.confidence == this.confidence &&
          other.sourceName == this.sourceName &&
          other.loggedAt == this.loggedAt &&
          other.createdAt == this.createdAt &&
          other.syncPending == this.syncPending &&
          other.remoteId == this.remoteId &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntryRow> {
  final Value<int> id;
  final Value<String> foodId;
  final Value<String> foodName;
  final Value<String> foodCanonicalName;
  final Value<String> mealType;
  final Value<double> grams;
  final Value<String?> portionName;
  final Value<int> quantity;
  final Value<double?> caloriesKcal;
  final Value<double?> proteinG;
  final Value<double?> carbohydrateG;
  final Value<double?> fatG;
  final Value<double?> fibreG;
  final Value<String> confidence;
  final Value<String?> sourceName;
  final Value<DateTime> loggedAt;
  final Value<DateTime> createdAt;
  final Value<bool> syncPending;
  final Value<String?> remoteId;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.foodCanonicalName = const Value.absent(),
    this.mealType = const Value.absent(),
    this.grams = const Value.absent(),
    this.portionName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.caloriesKcal = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbohydrateG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.confidence = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncPending = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String foodId,
    required String foodName,
    required String foodCanonicalName,
    required String mealType,
    required double grams,
    this.portionName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.caloriesKcal = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbohydrateG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.confidence = const Value.absent(),
    this.sourceName = const Value.absent(),
    required DateTime loggedAt,
    this.createdAt = const Value.absent(),
    this.syncPending = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : foodId = Value(foodId),
       foodName = Value(foodName),
       foodCanonicalName = Value(foodCanonicalName),
       mealType = Value(mealType),
       grams = Value(grams),
       loggedAt = Value(loggedAt);
  static Insertable<DiaryEntryRow> custom({
    Expression<int>? id,
    Expression<String>? foodId,
    Expression<String>? foodName,
    Expression<String>? foodCanonicalName,
    Expression<String>? mealType,
    Expression<double>? grams,
    Expression<String>? portionName,
    Expression<int>? quantity,
    Expression<double>? caloriesKcal,
    Expression<double>? proteinG,
    Expression<double>? carbohydrateG,
    Expression<double>? fatG,
    Expression<double>? fibreG,
    Expression<String>? confidence,
    Expression<String>? sourceName,
    Expression<DateTime>? loggedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? syncPending,
    Expression<String>? remoteId,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (foodName != null) 'food_name': foodName,
      if (foodCanonicalName != null) 'food_canonical_name': foodCanonicalName,
      if (mealType != null) 'meal_type': mealType,
      if (grams != null) 'grams': grams,
      if (portionName != null) 'portion_name': portionName,
      if (quantity != null) 'quantity': quantity,
      if (caloriesKcal != null) 'calories_kcal': caloriesKcal,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbohydrateG != null) 'carbohydrate_g': carbohydrateG,
      if (fatG != null) 'fat_g': fatG,
      if (fibreG != null) 'fibre_g': fibreG,
      if (confidence != null) 'confidence': confidence,
      if (sourceName != null) 'source_name': sourceName,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (syncPending != null) 'sync_pending': syncPending,
      if (remoteId != null) 'remote_id': remoteId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? foodId,
    Value<String>? foodName,
    Value<String>? foodCanonicalName,
    Value<String>? mealType,
    Value<double>? grams,
    Value<String?>? portionName,
    Value<int>? quantity,
    Value<double?>? caloriesKcal,
    Value<double?>? proteinG,
    Value<double?>? carbohydrateG,
    Value<double?>? fatG,
    Value<double?>? fibreG,
    Value<String>? confidence,
    Value<String?>? sourceName,
    Value<DateTime>? loggedAt,
    Value<DateTime>? createdAt,
    Value<bool>? syncPending,
    Value<String?>? remoteId,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      foodCanonicalName: foodCanonicalName ?? this.foodCanonicalName,
      mealType: mealType ?? this.mealType,
      grams: grams ?? this.grams,
      portionName: portionName ?? this.portionName,
      quantity: quantity ?? this.quantity,
      caloriesKcal: caloriesKcal ?? this.caloriesKcal,
      proteinG: proteinG ?? this.proteinG,
      carbohydrateG: carbohydrateG ?? this.carbohydrateG,
      fatG: fatG ?? this.fatG,
      fibreG: fibreG ?? this.fibreG,
      confidence: confidence ?? this.confidence,
      sourceName: sourceName ?? this.sourceName,
      loggedAt: loggedAt ?? this.loggedAt,
      createdAt: createdAt ?? this.createdAt,
      syncPending: syncPending ?? this.syncPending,
      remoteId: remoteId ?? this.remoteId,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (foodCanonicalName.present) {
      map['food_canonical_name'] = Variable<String>(foodCanonicalName.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (portionName.present) {
      map['portion_name'] = Variable<String>(portionName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (caloriesKcal.present) {
      map['calories_kcal'] = Variable<double>(caloriesKcal.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbohydrateG.present) {
      map['carbohydrate_g'] = Variable<double>(carbohydrateG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (fibreG.present) {
      map['fibre_g'] = Variable<double>(fibreG.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncPending.present) {
      map['sync_pending'] = Variable<bool>(syncPending.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('foodCanonicalName: $foodCanonicalName, ')
          ..write('mealType: $mealType, ')
          ..write('grams: $grams, ')
          ..write('portionName: $portionName, ')
          ..write('quantity: $quantity, ')
          ..write('caloriesKcal: $caloriesKcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbohydrateG: $carbohydrateG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('confidence: $confidence, ')
          ..write('sourceName: $sourceName, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('remoteId: $remoteId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DiaryDatabase extends GeneratedDatabase {
  _$DiaryDatabase(QueryExecutor e) : super(e);
  $DiaryDatabaseManager get managers => $DiaryDatabaseManager(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [diaryEntries];
}

typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      required String foodId,
      required String foodName,
      required String foodCanonicalName,
      required String mealType,
      required double grams,
      Value<String?> portionName,
      Value<int> quantity,
      Value<double?> caloriesKcal,
      Value<double?> proteinG,
      Value<double?> carbohydrateG,
      Value<double?> fatG,
      Value<double?> fibreG,
      Value<String> confidence,
      Value<String?> sourceName,
      required DateTime loggedAt,
      Value<DateTime> createdAt,
      Value<bool> syncPending,
      Value<String?> remoteId,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      Value<String> foodId,
      Value<String> foodName,
      Value<String> foodCanonicalName,
      Value<String> mealType,
      Value<double> grams,
      Value<String?> portionName,
      Value<int> quantity,
      Value<double?> caloriesKcal,
      Value<double?> proteinG,
      Value<double?> carbohydrateG,
      Value<double?> fatG,
      Value<double?> fibreG,
      Value<String> confidence,
      Value<String?> sourceName,
      Value<DateTime> loggedAt,
      Value<DateTime> createdAt,
      Value<bool> syncPending,
      Value<String?> remoteId,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
    });

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$DiaryDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodCanonicalName => $composableBuilder(
    column: $table.foodCanonicalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionName => $composableBuilder(
    column: $table.portionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesKcal => $composableBuilder(
    column: $table.caloriesKcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbohydrateG => $composableBuilder(
    column: $table.carbohydrateG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncPending => $composableBuilder(
    column: $table.syncPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$DiaryDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodCanonicalName => $composableBuilder(
    column: $table.foodCanonicalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionName => $composableBuilder(
    column: $table.portionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesKcal => $composableBuilder(
    column: $table.caloriesKcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbohydrateG => $composableBuilder(
    column: $table.carbohydrateG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncPending => $composableBuilder(
    column: $table.syncPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$DiaryDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get foodCanonicalName => $composableBuilder(
    column: $table.foodCanonicalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<String> get portionName => $composableBuilder(
    column: $table.portionName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get caloriesKcal => $composableBuilder(
    column: $table.caloriesKcal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbohydrateG => $composableBuilder(
    column: $table.carbohydrateG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<double> get fibreG =>
      $composableBuilder(column: $table.fibreG, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get syncPending => $composableBuilder(
    column: $table.syncPending,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$DiaryDatabase,
          $DiaryEntriesTable,
          DiaryEntryRow,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (
            DiaryEntryRow,
            BaseReferences<_$DiaryDatabase, $DiaryEntriesTable, DiaryEntryRow>,
          ),
          DiaryEntryRow,
          PrefetchHooks Function()
        > {
  $$DiaryEntriesTableTableManager(_$DiaryDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> foodId = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<String> foodCanonicalName = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<String?> portionName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double?> caloriesKcal = const Value.absent(),
                Value<double?> proteinG = const Value.absent(),
                Value<double?> carbohydrateG = const Value.absent(),
                Value<double?> fatG = const Value.absent(),
                Value<double?> fibreG = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<String?> sourceName = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> syncPending = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                foodId: foodId,
                foodName: foodName,
                foodCanonicalName: foodCanonicalName,
                mealType: mealType,
                grams: grams,
                portionName: portionName,
                quantity: quantity,
                caloriesKcal: caloriesKcal,
                proteinG: proteinG,
                carbohydrateG: carbohydrateG,
                fatG: fatG,
                fibreG: fibreG,
                confidence: confidence,
                sourceName: sourceName,
                loggedAt: loggedAt,
                createdAt: createdAt,
                syncPending: syncPending,
                remoteId: remoteId,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String foodId,
                required String foodName,
                required String foodCanonicalName,
                required String mealType,
                required double grams,
                Value<String?> portionName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double?> caloriesKcal = const Value.absent(),
                Value<double?> proteinG = const Value.absent(),
                Value<double?> carbohydrateG = const Value.absent(),
                Value<double?> fatG = const Value.absent(),
                Value<double?> fibreG = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<String?> sourceName = const Value.absent(),
                required DateTime loggedAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> syncPending = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => DiaryEntriesCompanion.insert(
                id: id,
                foodId: foodId,
                foodName: foodName,
                foodCanonicalName: foodCanonicalName,
                mealType: mealType,
                grams: grams,
                portionName: portionName,
                quantity: quantity,
                caloriesKcal: caloriesKcal,
                proteinG: proteinG,
                carbohydrateG: carbohydrateG,
                fatG: fatG,
                fibreG: fibreG,
                confidence: confidence,
                sourceName: sourceName,
                loggedAt: loggedAt,
                createdAt: createdAt,
                syncPending: syncPending,
                remoteId: remoteId,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$DiaryDatabase,
      $DiaryEntriesTable,
      DiaryEntryRow,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (
        DiaryEntryRow,
        BaseReferences<_$DiaryDatabase, $DiaryEntriesTable, DiaryEntryRow>,
      ),
      DiaryEntryRow,
      PrefetchHooks Function()
    >;

class $DiaryDatabaseManager {
  final _$DiaryDatabase _db;
  $DiaryDatabaseManager(this._db);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
}
