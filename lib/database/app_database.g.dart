// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hppMeta = const VerificationMeta('hpp');
  @override
  late final GeneratedColumn<int> hpp = GeneratedColumn<int>(
    'hpp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<int> sellingPrice = GeneratedColumn<int>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    hpp,
    sellingPrice,
    unit,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hpp')) {
      context.handle(
        _hppMeta,
        hpp.isAcceptableOrUnknown(data['hpp']!, _hppMeta),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hpp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hpp'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final int hpp;
  final int sellingPrice;
  final String unit;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    required this.hpp,
    required this.sellingPrice,
    required this.unit,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['hpp'] = Variable<int>(hpp);
    map['selling_price'] = Variable<int>(sellingPrice);
    map['unit'] = Variable<String>(unit);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      hpp: Value(hpp),
      sellingPrice: Value(sellingPrice),
      unit: Value(unit),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hpp: serializer.fromJson<int>(json['hpp']),
      sellingPrice: serializer.fromJson<int>(json['sellingPrice']),
      unit: serializer.fromJson<String>(json['unit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'hpp': serializer.toJson<int>(hpp),
      'sellingPrice': serializer.toJson<int>(sellingPrice),
      'unit': serializer.toJson<String>(unit),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    int? hpp,
    int? sellingPrice,
    String? unit,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    hpp: hpp ?? this.hpp,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    unit: unit ?? this.unit,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hpp: data.hpp.present ? data.hpp.value : this.hpp,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      unit: data.unit.present ? data.unit.value : this.unit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hpp: $hpp, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('unit: $unit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    hpp,
    sellingPrice,
    unit,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.hpp == this.hpp &&
          other.sellingPrice == this.sellingPrice &&
          other.unit == this.unit &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> hpp;
  final Value<int> sellingPrice;
  final Value<String> unit;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hpp = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.unit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.hpp = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.unit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? hpp,
    Expression<int>? sellingPrice,
    Expression<String>? unit,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hpp != null) 'hpp': hpp,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (unit != null) 'unit': unit,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? hpp,
    Value<int>? sellingPrice,
    Value<String>? unit,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hpp: hpp ?? this.hpp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      unit: unit ?? this.unit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hpp.present) {
      map['hpp'] = Variable<int>(hpp.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<int>(sellingPrice.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hpp: $hpp, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('unit: $unit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyRecordsTable extends DailyRecords
    with TableInfo<$DailyRecordsTable, DailyRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRevenueMeta = const VerificationMeta(
    'totalRevenue',
  );
  @override
  late final GeneratedColumn<int> totalRevenue = GeneratedColumn<int>(
    'total_revenue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<int> totalCost = GeneratedColumn<int>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalProfitMeta = const VerificationMeta(
    'totalProfit',
  );
  @override
  late final GeneratedColumn<int> totalProfit = GeneratedColumn<int>(
    'total_profit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalQuantityMeta = const VerificationMeta(
    'totalQuantity',
  );
  @override
  late final GeneratedColumn<int> totalQuantity = GeneratedColumn<int>(
    'total_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    totalRevenue,
    totalCost,
    totalProfit,
    totalQuantity,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_revenue')) {
      context.handle(
        _totalRevenueMeta,
        totalRevenue.isAcceptableOrUnknown(
          data['total_revenue']!,
          _totalRevenueMeta,
        ),
      );
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    }
    if (data.containsKey('total_profit')) {
      context.handle(
        _totalProfitMeta,
        totalProfit.isAcceptableOrUnknown(
          data['total_profit']!,
          _totalProfitMeta,
        ),
      );
    }
    if (data.containsKey('total_quantity')) {
      context.handle(
        _totalQuantityMeta,
        totalQuantity.isAcceptableOrUnknown(
          data['total_quantity']!,
          _totalQuantityMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date},
  ];
  @override
  DailyRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalRevenue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_revenue'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cost'],
      )!,
      totalProfit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_profit'],
      )!,
      totalQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_quantity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyRecordsTable createAlias(String alias) {
    return $DailyRecordsTable(attachedDatabase, alias);
  }
}

class DailyRecord extends DataClass implements Insertable<DailyRecord> {
  final int id;
  final DateTime date;
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;
  final int totalQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyRecord({
    required this.id,
    required this.date,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.totalQuantity,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['total_revenue'] = Variable<int>(totalRevenue);
    map['total_cost'] = Variable<int>(totalCost);
    map['total_profit'] = Variable<int>(totalProfit);
    map['total_quantity'] = Variable<int>(totalQuantity);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyRecordsCompanion(
      id: Value(id),
      date: Value(date),
      totalRevenue: Value(totalRevenue),
      totalCost: Value(totalCost),
      totalProfit: Value(totalProfit),
      totalQuantity: Value(totalQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalRevenue: serializer.fromJson<int>(json['totalRevenue']),
      totalCost: serializer.fromJson<int>(json['totalCost']),
      totalProfit: serializer.fromJson<int>(json['totalProfit']),
      totalQuantity: serializer.fromJson<int>(json['totalQuantity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'totalRevenue': serializer.toJson<int>(totalRevenue),
      'totalCost': serializer.toJson<int>(totalCost),
      'totalProfit': serializer.toJson<int>(totalProfit),
      'totalQuantity': serializer.toJson<int>(totalQuantity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyRecord copyWith({
    int? id,
    DateTime? date,
    int? totalRevenue,
    int? totalCost,
    int? totalProfit,
    int? totalQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    totalRevenue: totalRevenue ?? this.totalRevenue,
    totalCost: totalCost ?? this.totalCost,
    totalProfit: totalProfit ?? this.totalProfit,
    totalQuantity: totalQuantity ?? this.totalQuantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyRecord copyWithCompanion(DailyRecordsCompanion data) {
    return DailyRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      totalRevenue: data.totalRevenue.present
          ? data.totalRevenue.value
          : this.totalRevenue,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      totalProfit: data.totalProfit.present
          ? data.totalProfit.value
          : this.totalProfit,
      totalQuantity: data.totalQuantity.present
          ? data.totalQuantity.value
          : this.totalQuantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalCost: $totalCost, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    totalRevenue,
    totalCost,
    totalProfit,
    totalQuantity,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.totalRevenue == this.totalRevenue &&
          other.totalCost == this.totalCost &&
          other.totalProfit == this.totalProfit &&
          other.totalQuantity == this.totalQuantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyRecordsCompanion extends UpdateCompanion<DailyRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> totalRevenue;
  final Value<int> totalCost;
  final Value<int> totalProfit;
  final Value<int> totalQuantity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.totalRevenue = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.totalRevenue = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? totalRevenue,
    Expression<int>? totalCost,
    Expression<int>? totalProfit,
    Expression<int>? totalQuantity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (totalRevenue != null) 'total_revenue': totalRevenue,
      if (totalCost != null) 'total_cost': totalCost,
      if (totalProfit != null) 'total_profit': totalProfit,
      if (totalQuantity != null) 'total_quantity': totalQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? totalRevenue,
    Value<int>? totalCost,
    Value<int>? totalProfit,
    Value<int>? totalQuantity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DailyRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalCost: totalCost ?? this.totalCost,
      totalProfit: totalProfit ?? this.totalProfit,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalRevenue.present) {
      map['total_revenue'] = Variable<int>(totalRevenue.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<int>(totalCost.value);
    }
    if (totalProfit.present) {
      map['total_profit'] = Variable<int>(totalProfit.value);
    }
    if (totalQuantity.present) {
      map['total_quantity'] = Variable<int>(totalQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalCost: $totalCost, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyRecordItemsTable extends DailyRecordItems
    with TableInfo<$DailyRecordItemsTable, DailyRecordItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRecordItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dailyRecordIdMeta = const VerificationMeta(
    'dailyRecordId',
  );
  @override
  late final GeneratedColumn<int> dailyRecordId = GeneratedColumn<int>(
    'daily_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_records (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _productNameSnapshotMeta =
      const VerificationMeta('productNameSnapshot');
  @override
  late final GeneratedColumn<String> productNameSnapshot =
      GeneratedColumn<String>(
        'product_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _unitSnapshotMeta = const VerificationMeta(
    'unitSnapshot',
  );
  @override
  late final GeneratedColumn<String> unitSnapshot = GeneratedColumn<String>(
    'unit_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _hppSnapshotMeta = const VerificationMeta(
    'hppSnapshot',
  );
  @override
  late final GeneratedColumn<int> hppSnapshot = GeneratedColumn<int>(
    'hpp_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sellingPriceSnapshotMeta =
      const VerificationMeta('sellingPriceSnapshot');
  @override
  late final GeneratedColumn<int> sellingPriceSnapshot = GeneratedColumn<int>(
    'selling_price_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalRevenueMeta = const VerificationMeta(
    'subtotalRevenue',
  );
  @override
  late final GeneratedColumn<int> subtotalRevenue = GeneratedColumn<int>(
    'subtotal_revenue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalCostMeta = const VerificationMeta(
    'subtotalCost',
  );
  @override
  late final GeneratedColumn<int> subtotalCost = GeneratedColumn<int>(
    'subtotal_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalProfitMeta = const VerificationMeta(
    'subtotalProfit',
  );
  @override
  late final GeneratedColumn<int> subtotalProfit = GeneratedColumn<int>(
    'subtotal_profit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyRecordId,
    productId,
    productNameSnapshot,
    unitSnapshot,
    hppSnapshot,
    sellingPriceSnapshot,
    quantity,
    subtotalRevenue,
    subtotalCost,
    subtotalProfit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_record_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyRecordItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_record_id')) {
      context.handle(
        _dailyRecordIdMeta,
        dailyRecordId.isAcceptableOrUnknown(
          data['daily_record_id']!,
          _dailyRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyRecordIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
        _productNameSnapshotMeta,
        productNameSnapshot.isAcceptableOrUnknown(
          data['product_name_snapshot']!,
          _productNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameSnapshotMeta);
    }
    if (data.containsKey('unit_snapshot')) {
      context.handle(
        _unitSnapshotMeta,
        unitSnapshot.isAcceptableOrUnknown(
          data['unit_snapshot']!,
          _unitSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('hpp_snapshot')) {
      context.handle(
        _hppSnapshotMeta,
        hppSnapshot.isAcceptableOrUnknown(
          data['hpp_snapshot']!,
          _hppSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('selling_price_snapshot')) {
      context.handle(
        _sellingPriceSnapshotMeta,
        sellingPriceSnapshot.isAcceptableOrUnknown(
          data['selling_price_snapshot']!,
          _sellingPriceSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('subtotal_revenue')) {
      context.handle(
        _subtotalRevenueMeta,
        subtotalRevenue.isAcceptableOrUnknown(
          data['subtotal_revenue']!,
          _subtotalRevenueMeta,
        ),
      );
    }
    if (data.containsKey('subtotal_cost')) {
      context.handle(
        _subtotalCostMeta,
        subtotalCost.isAcceptableOrUnknown(
          data['subtotal_cost']!,
          _subtotalCostMeta,
        ),
      );
    }
    if (data.containsKey('subtotal_profit')) {
      context.handle(
        _subtotalProfitMeta,
        subtotalProfit.isAcceptableOrUnknown(
          data['subtotal_profit']!,
          _subtotalProfitMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyRecordItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRecordItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_record_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      productNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name_snapshot'],
      )!,
      unitSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_snapshot'],
      )!,
      hppSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hpp_snapshot'],
      )!,
      sellingPriceSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_snapshot'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      subtotalRevenue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_revenue'],
      )!,
      subtotalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_cost'],
      )!,
      subtotalProfit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_profit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyRecordItemsTable createAlias(String alias) {
    return $DailyRecordItemsTable(attachedDatabase, alias);
  }
}

class DailyRecordItem extends DataClass implements Insertable<DailyRecordItem> {
  final int id;
  final int dailyRecordId;
  final int? productId;
  final String productNameSnapshot;
  final String unitSnapshot;
  final int hppSnapshot;
  final int sellingPriceSnapshot;
  final int quantity;
  final int subtotalRevenue;
  final int subtotalCost;
  final int subtotalProfit;
  final DateTime createdAt;
  const DailyRecordItem({
    required this.id,
    required this.dailyRecordId,
    this.productId,
    required this.productNameSnapshot,
    required this.unitSnapshot,
    required this.hppSnapshot,
    required this.sellingPriceSnapshot,
    required this.quantity,
    required this.subtotalRevenue,
    required this.subtotalCost,
    required this.subtotalProfit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_record_id'] = Variable<int>(dailyRecordId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['product_name_snapshot'] = Variable<String>(productNameSnapshot);
    map['unit_snapshot'] = Variable<String>(unitSnapshot);
    map['hpp_snapshot'] = Variable<int>(hppSnapshot);
    map['selling_price_snapshot'] = Variable<int>(sellingPriceSnapshot);
    map['quantity'] = Variable<int>(quantity);
    map['subtotal_revenue'] = Variable<int>(subtotalRevenue);
    map['subtotal_cost'] = Variable<int>(subtotalCost);
    map['subtotal_profit'] = Variable<int>(subtotalProfit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyRecordItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyRecordItemsCompanion(
      id: Value(id),
      dailyRecordId: Value(dailyRecordId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productNameSnapshot: Value(productNameSnapshot),
      unitSnapshot: Value(unitSnapshot),
      hppSnapshot: Value(hppSnapshot),
      sellingPriceSnapshot: Value(sellingPriceSnapshot),
      quantity: Value(quantity),
      subtotalRevenue: Value(subtotalRevenue),
      subtotalCost: Value(subtotalCost),
      subtotalProfit: Value(subtotalProfit),
      createdAt: Value(createdAt),
    );
  }

  factory DailyRecordItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRecordItem(
      id: serializer.fromJson<int>(json['id']),
      dailyRecordId: serializer.fromJson<int>(json['dailyRecordId']),
      productId: serializer.fromJson<int?>(json['productId']),
      productNameSnapshot: serializer.fromJson<String>(
        json['productNameSnapshot'],
      ),
      unitSnapshot: serializer.fromJson<String>(json['unitSnapshot']),
      hppSnapshot: serializer.fromJson<int>(json['hppSnapshot']),
      sellingPriceSnapshot: serializer.fromJson<int>(
        json['sellingPriceSnapshot'],
      ),
      quantity: serializer.fromJson<int>(json['quantity']),
      subtotalRevenue: serializer.fromJson<int>(json['subtotalRevenue']),
      subtotalCost: serializer.fromJson<int>(json['subtotalCost']),
      subtotalProfit: serializer.fromJson<int>(json['subtotalProfit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyRecordId': serializer.toJson<int>(dailyRecordId),
      'productId': serializer.toJson<int?>(productId),
      'productNameSnapshot': serializer.toJson<String>(productNameSnapshot),
      'unitSnapshot': serializer.toJson<String>(unitSnapshot),
      'hppSnapshot': serializer.toJson<int>(hppSnapshot),
      'sellingPriceSnapshot': serializer.toJson<int>(sellingPriceSnapshot),
      'quantity': serializer.toJson<int>(quantity),
      'subtotalRevenue': serializer.toJson<int>(subtotalRevenue),
      'subtotalCost': serializer.toJson<int>(subtotalCost),
      'subtotalProfit': serializer.toJson<int>(subtotalProfit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyRecordItem copyWith({
    int? id,
    int? dailyRecordId,
    Value<int?> productId = const Value.absent(),
    String? productNameSnapshot,
    String? unitSnapshot,
    int? hppSnapshot,
    int? sellingPriceSnapshot,
    int? quantity,
    int? subtotalRevenue,
    int? subtotalCost,
    int? subtotalProfit,
    DateTime? createdAt,
  }) => DailyRecordItem(
    id: id ?? this.id,
    dailyRecordId: dailyRecordId ?? this.dailyRecordId,
    productId: productId.present ? productId.value : this.productId,
    productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
    unitSnapshot: unitSnapshot ?? this.unitSnapshot,
    hppSnapshot: hppSnapshot ?? this.hppSnapshot,
    sellingPriceSnapshot: sellingPriceSnapshot ?? this.sellingPriceSnapshot,
    quantity: quantity ?? this.quantity,
    subtotalRevenue: subtotalRevenue ?? this.subtotalRevenue,
    subtotalCost: subtotalCost ?? this.subtotalCost,
    subtotalProfit: subtotalProfit ?? this.subtotalProfit,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyRecordItem copyWithCompanion(DailyRecordItemsCompanion data) {
    return DailyRecordItem(
      id: data.id.present ? data.id.value : this.id,
      dailyRecordId: data.dailyRecordId.present
          ? data.dailyRecordId.value
          : this.dailyRecordId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productNameSnapshot: data.productNameSnapshot.present
          ? data.productNameSnapshot.value
          : this.productNameSnapshot,
      unitSnapshot: data.unitSnapshot.present
          ? data.unitSnapshot.value
          : this.unitSnapshot,
      hppSnapshot: data.hppSnapshot.present
          ? data.hppSnapshot.value
          : this.hppSnapshot,
      sellingPriceSnapshot: data.sellingPriceSnapshot.present
          ? data.sellingPriceSnapshot.value
          : this.sellingPriceSnapshot,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      subtotalRevenue: data.subtotalRevenue.present
          ? data.subtotalRevenue.value
          : this.subtotalRevenue,
      subtotalCost: data.subtotalCost.present
          ? data.subtotalCost.value
          : this.subtotalCost,
      subtotalProfit: data.subtotalProfit.present
          ? data.subtotalProfit.value
          : this.subtotalProfit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordItem(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('unitSnapshot: $unitSnapshot, ')
          ..write('hppSnapshot: $hppSnapshot, ')
          ..write('sellingPriceSnapshot: $sellingPriceSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('subtotalRevenue: $subtotalRevenue, ')
          ..write('subtotalCost: $subtotalCost, ')
          ..write('subtotalProfit: $subtotalProfit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyRecordId,
    productId,
    productNameSnapshot,
    unitSnapshot,
    hppSnapshot,
    sellingPriceSnapshot,
    quantity,
    subtotalRevenue,
    subtotalCost,
    subtotalProfit,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRecordItem &&
          other.id == this.id &&
          other.dailyRecordId == this.dailyRecordId &&
          other.productId == this.productId &&
          other.productNameSnapshot == this.productNameSnapshot &&
          other.unitSnapshot == this.unitSnapshot &&
          other.hppSnapshot == this.hppSnapshot &&
          other.sellingPriceSnapshot == this.sellingPriceSnapshot &&
          other.quantity == this.quantity &&
          other.subtotalRevenue == this.subtotalRevenue &&
          other.subtotalCost == this.subtotalCost &&
          other.subtotalProfit == this.subtotalProfit &&
          other.createdAt == this.createdAt);
}

class DailyRecordItemsCompanion extends UpdateCompanion<DailyRecordItem> {
  final Value<int> id;
  final Value<int> dailyRecordId;
  final Value<int?> productId;
  final Value<String> productNameSnapshot;
  final Value<String> unitSnapshot;
  final Value<int> hppSnapshot;
  final Value<int> sellingPriceSnapshot;
  final Value<int> quantity;
  final Value<int> subtotalRevenue;
  final Value<int> subtotalCost;
  final Value<int> subtotalProfit;
  final Value<DateTime> createdAt;
  const DailyRecordItemsCompanion({
    this.id = const Value.absent(),
    this.dailyRecordId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productNameSnapshot = const Value.absent(),
    this.unitSnapshot = const Value.absent(),
    this.hppSnapshot = const Value.absent(),
    this.sellingPriceSnapshot = const Value.absent(),
    this.quantity = const Value.absent(),
    this.subtotalRevenue = const Value.absent(),
    this.subtotalCost = const Value.absent(),
    this.subtotalProfit = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyRecordItemsCompanion.insert({
    this.id = const Value.absent(),
    required int dailyRecordId,
    this.productId = const Value.absent(),
    required String productNameSnapshot,
    this.unitSnapshot = const Value.absent(),
    this.hppSnapshot = const Value.absent(),
    this.sellingPriceSnapshot = const Value.absent(),
    this.quantity = const Value.absent(),
    this.subtotalRevenue = const Value.absent(),
    this.subtotalCost = const Value.absent(),
    this.subtotalProfit = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : dailyRecordId = Value(dailyRecordId),
       productNameSnapshot = Value(productNameSnapshot);
  static Insertable<DailyRecordItem> custom({
    Expression<int>? id,
    Expression<int>? dailyRecordId,
    Expression<int>? productId,
    Expression<String>? productNameSnapshot,
    Expression<String>? unitSnapshot,
    Expression<int>? hppSnapshot,
    Expression<int>? sellingPriceSnapshot,
    Expression<int>? quantity,
    Expression<int>? subtotalRevenue,
    Expression<int>? subtotalCost,
    Expression<int>? subtotalProfit,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyRecordId != null) 'daily_record_id': dailyRecordId,
      if (productId != null) 'product_id': productId,
      if (productNameSnapshot != null)
        'product_name_snapshot': productNameSnapshot,
      if (unitSnapshot != null) 'unit_snapshot': unitSnapshot,
      if (hppSnapshot != null) 'hpp_snapshot': hppSnapshot,
      if (sellingPriceSnapshot != null)
        'selling_price_snapshot': sellingPriceSnapshot,
      if (quantity != null) 'quantity': quantity,
      if (subtotalRevenue != null) 'subtotal_revenue': subtotalRevenue,
      if (subtotalCost != null) 'subtotal_cost': subtotalCost,
      if (subtotalProfit != null) 'subtotal_profit': subtotalProfit,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyRecordItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyRecordId,
    Value<int?>? productId,
    Value<String>? productNameSnapshot,
    Value<String>? unitSnapshot,
    Value<int>? hppSnapshot,
    Value<int>? sellingPriceSnapshot,
    Value<int>? quantity,
    Value<int>? subtotalRevenue,
    Value<int>? subtotalCost,
    Value<int>? subtotalProfit,
    Value<DateTime>? createdAt,
  }) {
    return DailyRecordItemsCompanion(
      id: id ?? this.id,
      dailyRecordId: dailyRecordId ?? this.dailyRecordId,
      productId: productId ?? this.productId,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      unitSnapshot: unitSnapshot ?? this.unitSnapshot,
      hppSnapshot: hppSnapshot ?? this.hppSnapshot,
      sellingPriceSnapshot: sellingPriceSnapshot ?? this.sellingPriceSnapshot,
      quantity: quantity ?? this.quantity,
      subtotalRevenue: subtotalRevenue ?? this.subtotalRevenue,
      subtotalCost: subtotalCost ?? this.subtotalCost,
      subtotalProfit: subtotalProfit ?? this.subtotalProfit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyRecordId.present) {
      map['daily_record_id'] = Variable<int>(dailyRecordId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productNameSnapshot.present) {
      map['product_name_snapshot'] = Variable<String>(
        productNameSnapshot.value,
      );
    }
    if (unitSnapshot.present) {
      map['unit_snapshot'] = Variable<String>(unitSnapshot.value);
    }
    if (hppSnapshot.present) {
      map['hpp_snapshot'] = Variable<int>(hppSnapshot.value);
    }
    if (sellingPriceSnapshot.present) {
      map['selling_price_snapshot'] = Variable<int>(sellingPriceSnapshot.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (subtotalRevenue.present) {
      map['subtotal_revenue'] = Variable<int>(subtotalRevenue.value);
    }
    if (subtotalCost.present) {
      map['subtotal_cost'] = Variable<int>(subtotalCost.value);
    }
    if (subtotalProfit.present) {
      map['subtotal_profit'] = Variable<int>(subtotalProfit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordItemsCompanion(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('unitSnapshot: $unitSnapshot, ')
          ..write('hppSnapshot: $hppSnapshot, ')
          ..write('sellingPriceSnapshot: $sellingPriceSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('subtotalRevenue: $subtotalRevenue, ')
          ..write('subtotalCost: $subtotalCost, ')
          ..write('subtotalProfit: $subtotalProfit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $DailyRecordsTable dailyRecords = $DailyRecordsTable(this);
  late final $DailyRecordItemsTable dailyRecordItems = $DailyRecordItemsTable(
    this,
  );
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final DailyRecordsDao dailyRecordsDao = DailyRecordsDao(
    this as AppDatabase,
  );
  late final DailyRecordItemsDao dailyRecordItemsDao = DailyRecordItemsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    dailyRecords,
    dailyRecordItems,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> hpp,
      Value<int> sellingPrice,
      Value<String> unit,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> hpp,
      Value<int> sellingPrice,
      Value<String> unit,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DailyRecordItemsTable, List<DailyRecordItem>>
  _dailyRecordItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyRecordItems,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.dailyRecordItems.productId,
    ),
  );

  $$DailyRecordItemsTableProcessedTableManager get dailyRecordItemsRefs {
    final manager = $$DailyRecordItemsTableTableManager(
      $_db,
      $_db.dailyRecordItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyRecordItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hpp => $composableBuilder(
    column: $table.hpp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyRecordItemsRefs(
    Expression<bool> Function($$DailyRecordItemsTableFilterComposer f) f,
  ) {
    final $$DailyRecordItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyRecordItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyRecordItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hpp => $composableBuilder(
    column: $table.hpp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get hpp =>
      $composableBuilder(column: $table.hpp, builder: (column) => column);

  GeneratedColumn<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dailyRecordItemsRefs<T extends Object>(
    Expression<T> Function($$DailyRecordItemsTableAnnotationComposer a) f,
  ) {
    final $$DailyRecordItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyRecordItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyRecordItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool dailyRecordItemsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> hpp = const Value.absent(),
                Value<int> sellingPrice = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                hpp: hpp,
                sellingPrice: sellingPrice,
                unit: unit,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> hpp = const Value.absent(),
                Value<int> sellingPrice = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                hpp: hpp,
                sellingPrice: sellingPrice,
                unit: unit,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyRecordItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyRecordItemsRefs) db.dailyRecordItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyRecordItemsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      DailyRecordItem
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._dailyRecordItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).dailyRecordItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool dailyRecordItemsRefs})
    >;
typedef $$DailyRecordsTableCreateCompanionBuilder =
    DailyRecordsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> totalRevenue,
      Value<int> totalCost,
      Value<int> totalProfit,
      Value<int> totalQuantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DailyRecordsTableUpdateCompanionBuilder =
    DailyRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> totalRevenue,
      Value<int> totalCost,
      Value<int> totalProfit,
      Value<int> totalQuantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$DailyRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord> {
  $$DailyRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DailyRecordItemsTable, List<DailyRecordItem>>
  _dailyRecordItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyRecordItems,
    aliasName: $_aliasNameGenerator(
      db.dailyRecords.id,
      db.dailyRecordItems.dailyRecordId,
    ),
  );

  $$DailyRecordItemsTableProcessedTableManager get dailyRecordItemsRefs {
    final manager = $$DailyRecordItemsTableTableManager(
      $_db,
      $_db.dailyRecordItems,
    ).filter((f) => f.dailyRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyRecordItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalProfit => $composableBuilder(
    column: $table.totalProfit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyRecordItemsRefs(
    Expression<bool> Function($$DailyRecordItemsTableFilterComposer f) f,
  ) {
    final $$DailyRecordItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyRecordItems,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyRecordItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalProfit => $composableBuilder(
    column: $table.totalProfit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<int> get totalProfit => $composableBuilder(
    column: $table.totalProfit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dailyRecordItemsRefs<T extends Object>(
    Expression<T> Function($$DailyRecordItemsTableAnnotationComposer a) f,
  ) {
    final $$DailyRecordItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyRecordItems,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyRecordItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyRecordsTable,
          DailyRecord,
          $$DailyRecordsTableFilterComposer,
          $$DailyRecordsTableOrderingComposer,
          $$DailyRecordsTableAnnotationComposer,
          $$DailyRecordsTableCreateCompanionBuilder,
          $$DailyRecordsTableUpdateCompanionBuilder,
          (DailyRecord, $$DailyRecordsTableReferences),
          DailyRecord,
          PrefetchHooks Function({bool dailyRecordItemsRefs})
        > {
  $$DailyRecordsTableTableManager(_$AppDatabase db, $DailyRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> totalRevenue = const Value.absent(),
                Value<int> totalCost = const Value.absent(),
                Value<int> totalProfit = const Value.absent(),
                Value<int> totalQuantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyRecordsCompanion(
                id: id,
                date: date,
                totalRevenue: totalRevenue,
                totalCost: totalCost,
                totalProfit: totalProfit,
                totalQuantity: totalQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> totalRevenue = const Value.absent(),
                Value<int> totalCost = const Value.absent(),
                Value<int> totalProfit = const Value.absent(),
                Value<int> totalQuantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyRecordsCompanion.insert(
                id: id,
                date: date,
                totalRevenue: totalRevenue,
                totalCost: totalCost,
                totalProfit: totalProfit,
                totalQuantity: totalQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyRecordItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyRecordItemsRefs) db.dailyRecordItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyRecordItemsRefs)
                    await $_getPrefetchedData<
                      DailyRecord,
                      $DailyRecordsTable,
                      DailyRecordItem
                    >(
                      currentTable: table,
                      referencedTable: $$DailyRecordsTableReferences
                          ._dailyRecordItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DailyRecordsTableReferences(
                            db,
                            table,
                            p0,
                          ).dailyRecordItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.dailyRecordId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DailyRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyRecordsTable,
      DailyRecord,
      $$DailyRecordsTableFilterComposer,
      $$DailyRecordsTableOrderingComposer,
      $$DailyRecordsTableAnnotationComposer,
      $$DailyRecordsTableCreateCompanionBuilder,
      $$DailyRecordsTableUpdateCompanionBuilder,
      (DailyRecord, $$DailyRecordsTableReferences),
      DailyRecord,
      PrefetchHooks Function({bool dailyRecordItemsRefs})
    >;
typedef $$DailyRecordItemsTableCreateCompanionBuilder =
    DailyRecordItemsCompanion Function({
      Value<int> id,
      required int dailyRecordId,
      Value<int?> productId,
      required String productNameSnapshot,
      Value<String> unitSnapshot,
      Value<int> hppSnapshot,
      Value<int> sellingPriceSnapshot,
      Value<int> quantity,
      Value<int> subtotalRevenue,
      Value<int> subtotalCost,
      Value<int> subtotalProfit,
      Value<DateTime> createdAt,
    });
typedef $$DailyRecordItemsTableUpdateCompanionBuilder =
    DailyRecordItemsCompanion Function({
      Value<int> id,
      Value<int> dailyRecordId,
      Value<int?> productId,
      Value<String> productNameSnapshot,
      Value<String> unitSnapshot,
      Value<int> hppSnapshot,
      Value<int> sellingPriceSnapshot,
      Value<int> quantity,
      Value<int> subtotalRevenue,
      Value<int> subtotalCost,
      Value<int> subtotalProfit,
      Value<DateTime> createdAt,
    });

final class $$DailyRecordItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DailyRecordItemsTable, DailyRecordItem> {
  $$DailyRecordItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyRecordsTable _dailyRecordIdTable(_$AppDatabase db) =>
      db.dailyRecords.createAlias(
        $_aliasNameGenerator(
          db.dailyRecordItems.dailyRecordId,
          db.dailyRecords.id,
        ),
      );

  $$DailyRecordsTableProcessedTableManager get dailyRecordId {
    final $_column = $_itemColumn<int>('daily_record_id')!;

    final manager = $$DailyRecordsTableTableManager(
      $_db,
      $_db.dailyRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dailyRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.dailyRecordItems.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyRecordItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyRecordItemsTable> {
  $$DailyRecordItemsTableFilterComposer({
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

  ColumnFilters<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitSnapshot => $composableBuilder(
    column: $table.unitSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hppSnapshot => $composableBuilder(
    column: $table.hppSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceSnapshot => $composableBuilder(
    column: $table.sellingPriceSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalRevenue => $composableBuilder(
    column: $table.subtotalRevenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCost => $composableBuilder(
    column: $table.subtotalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalProfit => $composableBuilder(
    column: $table.subtotalProfit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyRecordsTableFilterComposer get dailyRecordId {
    final $$DailyRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableFilterComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyRecordItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyRecordItemsTable> {
  $$DailyRecordItemsTableOrderingComposer({
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

  ColumnOrderings<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitSnapshot => $composableBuilder(
    column: $table.unitSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hppSnapshot => $composableBuilder(
    column: $table.hppSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceSnapshot => $composableBuilder(
    column: $table.sellingPriceSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalRevenue => $composableBuilder(
    column: $table.subtotalRevenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCost => $composableBuilder(
    column: $table.subtotalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalProfit => $composableBuilder(
    column: $table.subtotalProfit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyRecordsTableOrderingComposer get dailyRecordId {
    final $$DailyRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyRecordItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyRecordItemsTable> {
  $$DailyRecordItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitSnapshot => $composableBuilder(
    column: $table.unitSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hppSnapshot => $composableBuilder(
    column: $table.hppSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPriceSnapshot => $composableBuilder(
    column: $table.sellingPriceSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get subtotalRevenue => $composableBuilder(
    column: $table.subtotalRevenue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotalCost => $composableBuilder(
    column: $table.subtotalCost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotalProfit => $composableBuilder(
    column: $table.subtotalProfit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DailyRecordsTableAnnotationComposer get dailyRecordId {
    final $$DailyRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyRecordItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyRecordItemsTable,
          DailyRecordItem,
          $$DailyRecordItemsTableFilterComposer,
          $$DailyRecordItemsTableOrderingComposer,
          $$DailyRecordItemsTableAnnotationComposer,
          $$DailyRecordItemsTableCreateCompanionBuilder,
          $$DailyRecordItemsTableUpdateCompanionBuilder,
          (DailyRecordItem, $$DailyRecordItemsTableReferences),
          DailyRecordItem,
          PrefetchHooks Function({bool dailyRecordId, bool productId})
        > {
  $$DailyRecordItemsTableTableManager(
    _$AppDatabase db,
    $DailyRecordItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyRecordItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyRecordItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyRecordItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyRecordId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> productNameSnapshot = const Value.absent(),
                Value<String> unitSnapshot = const Value.absent(),
                Value<int> hppSnapshot = const Value.absent(),
                Value<int> sellingPriceSnapshot = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> subtotalRevenue = const Value.absent(),
                Value<int> subtotalCost = const Value.absent(),
                Value<int> subtotalProfit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyRecordItemsCompanion(
                id: id,
                dailyRecordId: dailyRecordId,
                productId: productId,
                productNameSnapshot: productNameSnapshot,
                unitSnapshot: unitSnapshot,
                hppSnapshot: hppSnapshot,
                sellingPriceSnapshot: sellingPriceSnapshot,
                quantity: quantity,
                subtotalRevenue: subtotalRevenue,
                subtotalCost: subtotalCost,
                subtotalProfit: subtotalProfit,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dailyRecordId,
                Value<int?> productId = const Value.absent(),
                required String productNameSnapshot,
                Value<String> unitSnapshot = const Value.absent(),
                Value<int> hppSnapshot = const Value.absent(),
                Value<int> sellingPriceSnapshot = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> subtotalRevenue = const Value.absent(),
                Value<int> subtotalCost = const Value.absent(),
                Value<int> subtotalProfit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyRecordItemsCompanion.insert(
                id: id,
                dailyRecordId: dailyRecordId,
                productId: productId,
                productNameSnapshot: productNameSnapshot,
                unitSnapshot: unitSnapshot,
                hppSnapshot: hppSnapshot,
                sellingPriceSnapshot: sellingPriceSnapshot,
                quantity: quantity,
                subtotalRevenue: subtotalRevenue,
                subtotalCost: subtotalCost,
                subtotalProfit: subtotalProfit,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyRecordItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyRecordId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dailyRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dailyRecordId,
                                referencedTable:
                                    $$DailyRecordItemsTableReferences
                                        ._dailyRecordIdTable(db),
                                referencedColumn:
                                    $$DailyRecordItemsTableReferences
                                        ._dailyRecordIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$DailyRecordItemsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$DailyRecordItemsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyRecordItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyRecordItemsTable,
      DailyRecordItem,
      $$DailyRecordItemsTableFilterComposer,
      $$DailyRecordItemsTableOrderingComposer,
      $$DailyRecordItemsTableAnnotationComposer,
      $$DailyRecordItemsTableCreateCompanionBuilder,
      $$DailyRecordItemsTableUpdateCompanionBuilder,
      (DailyRecordItem, $$DailyRecordItemsTableReferences),
      DailyRecordItem,
      PrefetchHooks Function({bool dailyRecordId, bool productId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$DailyRecordsTableTableManager get dailyRecords =>
      $$DailyRecordsTableTableManager(_db, _db.dailyRecords);
  $$DailyRecordItemsTableTableManager get dailyRecordItems =>
      $$DailyRecordItemsTableTableManager(_db, _db.dailyRecordItems);
}
