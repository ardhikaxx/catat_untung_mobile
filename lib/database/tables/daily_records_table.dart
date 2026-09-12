import 'package:drift/drift.dart';

class DailyRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalRevenue => integer().withDefault(const Constant(0))();
  IntColumn get totalCost => integer().withDefault(const Constant(0))();
  IntColumn get totalProfit => integer().withDefault(const Constant(0))();
  IntColumn get totalQuantity => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [{date}];
}
