import 'package:catat_untung/data/repositories/daily_record_repository.dart';
import 'package:catat_untung/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DailyRecordRepository repo;

  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final yesterday = todayOnly.subtract(const Duration(days: 1));
  final twoDaysAgo = todayOnly.subtract(const Duration(days: 2));

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DailyRecordRepository(db);
    await repo.saveDailyRecord(
      date: todayOnly,
      items: [
        DailyRecordItemData(
          productId: null,
          productName: 'Kopi Susu',
          unit: 'cup',
          hpp: 8000,
          sellingPrice: 15000,
          quantity: 2,
          subtotalRevenue: 30000,
          subtotalCost: 16000,
          subtotalProfit: 14000,
        ),
      ],
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('getRecordByDate(today) returns today record', () async {
    final record = await repo.getRecordByDate(todayOnly);
    expect(record, isNotNull);
    expect(record!.date.year, todayOnly.year);
    expect(record.date.month, todayOnly.month);
    expect(record.date.day, todayOnly.day);
  });

  test('getRecordByDate(yesterday) returns null when only today exists', () async {
    final record = await repo.getRecordByDate(yesterday);
    expect(record, isNull);
  });

  test('getRecordByDate does not leak adjacent days when both have data', () async {
    await repo.saveDailyRecord(
      date: yesterday,
      items: [
        DailyRecordItemData(
          productId: null,
          productName: 'Teh',
          unit: 'cup',
          hpp: 3000,
          sellingPrice: 5000,
          quantity: 1,
          subtotalRevenue: 5000,
          subtotalCost: 3000,
          subtotalProfit: 2000,
        ),
      ],
    );

    final todayRecord = await repo.getRecordByDate(todayOnly);
    final yesterdayRecord = await repo.getRecordByDate(yesterday);
    final emptyDay = await repo.getRecordByDate(twoDaysAgo);

    expect(todayRecord, isNotNull);
    expect(yesterdayRecord, isNotNull);
    expect(todayRecord!.totalQuantity, 2);
    expect(yesterdayRecord!.totalQuantity, 1);
    expect(emptyDay, isNull);
  });

  test('saveDailyRecord on a past date does not overwrite today record', () async {
    await repo.saveDailyRecord(
      date: yesterday,
      items: [
        DailyRecordItemData(
          productId: null,
          productName: 'Es Teh',
          unit: 'cup',
          hpp: 2000,
          sellingPrice: 4000,
          quantity: 5,
          subtotalRevenue: 20000,
          subtotalCost: 10000,
          subtotalProfit: 10000,
        ),
      ],
    );

    final todayRecord = await repo.getRecordByDate(todayOnly);
    final yesterdayRecord = await repo.getRecordByDate(yesterday);

    expect(todayRecord, isNotNull);
    expect(todayRecord!.totalQuantity, 2);
    expect(yesterdayRecord, isNotNull);
    expect(yesterdayRecord!.totalQuantity, 5);
    expect(yesterdayRecord.id, isNot(todayRecord.id));
  });

  test('getRecordsBetween includes end day but not the day after it', () async {
    final records =
        await repo.getRecordsBetween(twoDaysAgo, yesterday);
    final dates = records.map((r) => r.date).toList();

    expect(dates.any((d) =>
        d.year == todayOnly.year &&
        d.month == todayOnly.month &&
        d.day == todayOnly.day), isFalse);
    expect(records.length, 0);

    await repo.saveDailyRecord(date: yesterday, items: []);
    final withYesterday =
        await repo.getRecordsBetween(twoDaysAgo, yesterday);
    expect(withYesterday.length, 1);
    expect(withYesterday.first.date.day, yesterday.day);
  });
}
