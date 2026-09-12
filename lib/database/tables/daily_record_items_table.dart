import 'package:drift/drift.dart';
import 'daily_records_table.dart';
import 'products_table.dart';

class DailyRecordItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyRecordId => integer().references(DailyRecords, #id)();
  IntColumn get productId => integer().nullable().references(Products, #id)();
  TextColumn get productNameSnapshot => text()();
  TextColumn get unitSnapshot => text().withDefault(const Constant('pcs'))();
  IntColumn get hppSnapshot => integer().withDefault(const Constant(0))();
  IntColumn get sellingPriceSnapshot => integer().withDefault(const Constant(0))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  IntColumn get subtotalRevenue => integer().withDefault(const Constant(0))();
  IntColumn get subtotalCost => integer().withDefault(const Constant(0))();
  IntColumn get subtotalProfit => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
