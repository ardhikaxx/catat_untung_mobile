import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/daily_records_table.dart';

part 'daily_records_dao.g.dart';

@DriftAccessor(tables: [DailyRecords])
class DailyRecordsDao extends DatabaseAccessor<AppDatabase> with _$DailyRecordsDaoMixin {
  DailyRecordsDao(super.db);

  Future<DailyRecord?> getRecordByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nextDay = dateOnly.add(const Duration(days: 1));
    return (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(dateOnly, nextDay))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<DailyRecord?> watchRecordByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nextDay = dateOnly.add(const Duration(days: 1));
    return (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(dateOnly, nextDay))
          ..limit(1))
        .watch()
        .map((rows) => rows.firstOrNull);
  }

  Future<List<DailyRecord>> getAllRecords() =>
      (select(dailyRecords)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<DailyRecord>> watchAllRecords() =>
      (select(dailyRecords)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<List<DailyRecord>> getRecordsBetween(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    return (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(startDay, endDay))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Stream<List<DailyRecord>> watchRecordsBetween(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    return (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(startDay, endDay))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }

  Future<int> insertRecord(DailyRecordsCompanion record) =>
      into(dailyRecords).insert(record);

  Future<bool> updateRecord(DailyRecordsCompanion record) =>
      update(dailyRecords).replace(record);

  Future<int> deleteRecord(int id) =>
      (delete(dailyRecords)..where((t) => t.id.equals(id))).go();

  Future<List<DailyRecord>> getRecordsWithProfit() =>
      (select(dailyRecords)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
}
