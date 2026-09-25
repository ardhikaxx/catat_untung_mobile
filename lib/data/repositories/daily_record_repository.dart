import 'package:drift/drift.dart';
import '../../database/app_database.dart';

class DailyRecordRepository {
  final AppDatabase _db;

  DailyRecordRepository(this._db);

  Future<DailyRecord?> getRecordByDate(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nextDay = dateOnly.add(const Duration(days: 1));
    final records = await (_db.select(_db.dailyRecords)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(dateOnly) &
              t.date.isSmallerThanValue(nextDay))
          ..orderBy([(t) => OrderingTerm.asc(t.date)])
          ..limit(1))
        .get();
    return records.isNotEmpty ? records.first : null;
  }

  Stream<DailyRecord?> watchRecordByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nextDay = dateOnly.add(const Duration(days: 1));
    return (_db.select(_db.dailyRecords)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(dateOnly) &
              t.date.isSmallerThanValue(nextDay))
          ..orderBy([(t) => OrderingTerm.asc(t.date)])
          ..limit(1))
        .watch()
        .map((rows) => rows.isNotEmpty ? rows.first : null);
  }

  Future<List<DailyRecord>> getAllRecords() =>
      (_db.select(_db.dailyRecords)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Stream<List<DailyRecord>> watchAllRecords() =>
      (_db.select(_db.dailyRecords)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<List<DailyRecord>> getRecordsBetween(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    return (_db.select(_db.dailyRecords)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(startDay) &
              t.date.isSmallerThanValue(endDay))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<List<DailyRecordItem>> getItemsByRecordId(int recordId) =>
      (_db.select(_db.dailyRecordItems)
            ..where((t) => t.dailyRecordId.equals(recordId)))
          .get();

  Stream<List<DailyRecordItem>> watchItemsByRecordId(int recordId) =>
      (_db.select(_db.dailyRecordItems)
            ..where((t) => t.dailyRecordId.equals(recordId)))
          .watch();

  Future<int> saveDailyRecord({
    required DateTime date,
    required List<DailyRecordItemData> items,
  }) async {
    return await _db.transaction(() async {
      final totalRevenue = items.fold<int>(0, (sum, i) => sum + i.subtotalRevenue);
      final totalCost = items.fold<int>(0, (sum, i) => sum + i.subtotalCost);
      final totalProfit = totalRevenue - totalCost;
      final totalQuantity = items.fold<int>(0, (sum, i) => sum + i.quantity);

      final dateOnly = DateTime(date.year, date.month, date.day);
      final existing = await getRecordByDate(dateOnly);

      int recordId;
      if (existing != null) {
        await (_db.update(_db.dailyRecords)..where((t) => t.id.equals(existing.id))).write(
              DailyRecordsCompanion(
                totalRevenue: Value(totalRevenue),
                totalCost: Value(totalCost),
                totalProfit: Value(totalProfit),
                totalQuantity: Value(totalQuantity),
                updatedAt: Value(DateTime.now()),
              ),
            );
        recordId = existing.id;
        await (_db.delete(_db.dailyRecordItems)
              ..where((t) => t.dailyRecordId.equals(recordId)))
            .go();
      } else {
        recordId = await _db.into(_db.dailyRecords).insert(
              DailyRecordsCompanion.insert(
                date: dateOnly,
                totalRevenue: Value(totalRevenue),
                totalCost: Value(totalCost),
                totalProfit: Value(totalProfit),
                totalQuantity: Value(totalQuantity),
              ),
            );
      }

      if (items.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.dailyRecordItems,
            items.map((item) {
              return DailyRecordItemsCompanion.insert(
                dailyRecordId: recordId,
                productId: Value(item.productId),
                productNameSnapshot: item.productName,
                unitSnapshot: Value(item.unit),
                hppSnapshot: Value(item.hpp),
                sellingPriceSnapshot: Value(item.sellingPrice),
                quantity: Value(item.quantity),
                subtotalRevenue: Value(item.subtotalRevenue),
                subtotalCost: Value(item.subtotalCost),
                subtotalProfit: Value(item.subtotalProfit),
              );
            }).toList(),
          );
        });
      }

      return recordId;
    });
  }

  Future<void> deleteDailyRecord(int recordId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.dailyRecordItems)
            ..where((t) => t.dailyRecordId.equals(recordId)))
          .go();
      await (_db.delete(_db.dailyRecords)..where((t) => t.id.equals(recordId))).go();
    });
  }

  Future<List<DailyRecordItem>> getItemsBetween(DateTime start, DateTime end) async {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    final query = _db.select(_db.dailyRecordItems).join([
      innerJoin(_db.dailyRecords, _db.dailyRecords.id.equalsExp(_db.dailyRecordItems.dailyRecordId)),
    ])
      ..where(_db.dailyRecords.date.isBiggerOrEqualValue(startDay) &
          _db.dailyRecords.date.isSmallerThanValue(endDay));
    final results = await query.get();
    return results.map((row) => row.readTable(_db.dailyRecordItems)).toList();
  }
}

class DailyRecordItemData {
  final int? productId;
  final String productName;
  final String unit;
  final int hpp;
  final int sellingPrice;
  final int quantity;
  final int subtotalRevenue;
  final int subtotalCost;
  final int subtotalProfit;

  DailyRecordItemData({
    this.productId,
    required this.productName,
    required this.unit,
    required this.hpp,
    required this.sellingPrice,
    required this.quantity,
    required this.subtotalRevenue,
    required this.subtotalCost,
    required this.subtotalProfit,
  });
}
