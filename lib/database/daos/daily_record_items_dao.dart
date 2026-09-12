import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/daily_record_items_table.dart';
import '../tables/daily_records_table.dart';

part 'daily_record_items_dao.g.dart';

@DriftAccessor(tables: [DailyRecordItems, DailyRecords])
class DailyRecordItemsDao extends DatabaseAccessor<AppDatabase> with _$DailyRecordItemsDaoMixin {
  DailyRecordItemsDao(super.db);

  Future<List<DailyRecordItem>> getItemsByRecordId(int recordId) =>
      (select(dailyRecordItems)
            ..where((t) => t.dailyRecordId.equals(recordId)))
          .get();

  Stream<List<DailyRecordItem>> watchItemsByRecordId(int recordId) =>
      (select(dailyRecordItems)
            ..where((t) => t.dailyRecordId.equals(recordId)))
          .watch();

  Future<int> insertItem(DailyRecordItemsCompanion item) =>
      into(dailyRecordItems).insert(item);

  Future<void> insertItems(List<DailyRecordItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(dailyRecordItems, items);
    });
  }

  Future<void> deleteItemsByRecordId(int recordId) async {
    await (delete(dailyRecordItems)..where((t) => t.dailyRecordId.equals(recordId))).go();
  }

  Future<int> deleteItem(int id) =>
      (delete(dailyRecordItems)..where((t) => t.id.equals(id))).go();

  Future<List<DailyRecordItem>> getItemsByProductId(int productId) =>
      (select(dailyRecordItems)
            ..where((t) => t.productId.equals(productId)))
          .get();

  Future<List<DailyRecordItem>> getItemsBetween(DateTime start, DateTime end) async {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    final query = select(dailyRecordItems).join([
      innerJoin(dailyRecords, dailyRecords.id.equalsExp(dailyRecordItems.dailyRecordId)),
    ])
      ..where(dailyRecords.date.isBetweenValues(startDay, endDay));
    final results = await query.get();
    return results.map((row) => row.readTable(dailyRecordItems)).toList();
  }

  Stream<List<DailyRecordItem>> watchItemsBetween(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    final query = select(dailyRecordItems).join([
      innerJoin(dailyRecords, dailyRecords.id.equalsExp(dailyRecordItems.dailyRecordId)),
    ])
      ..where(dailyRecords.date.isBetweenValues(startDay, endDay));
    return query.watch().map((rows) => rows.map((row) => row.readTable(dailyRecordItems)).toList());
  }
}
