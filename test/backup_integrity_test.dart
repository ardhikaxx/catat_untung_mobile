import 'package:catat_untung/data/services/backup_service.dart';
import 'package:catat_untung/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late BackupService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = BackupService(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> seed({required String productName, required DateTime date}) async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: productName));
    final recordId = await db.into(db.dailyRecords).insert(
          DailyRecordsCompanion.insert(date: date),
        );
    await db.into(db.dailyRecordItems).insert(
          DailyRecordItemsCompanion.insert(
            dailyRecordId: recordId,
            productId: Value(productId),
            productNameSnapshot: productName,
            quantity: const Value(2),
            subtotalProfit: const Value(20000),
          ),
        );
    return recordId;
  }

  test('export writes a checksum that matches the payload', () async {
    await seed(productName: 'Kopi Susu', date: DateTime(2026, 9, 20));
    final json = await service.exportData();

    expect(json['version'], BackupService.formatVersion);
    expect(json['checksum'], isA<String>());
    expect(json['checksum'], BackupService.checksumOf(json));
  });

  test('restore rejects a tampered file via checksum', () async {
    await seed(productName: 'Kopi Susu', date: DateTime(2026, 9, 20));
    final json = await service.exportData();
    (json['dailyRecords'] as List).first['totalProfit'] = 999999999;

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );
    expect(await db.select(db.dailyRecords).get(), hasLength(1));
  });

  test('restore rejects a file with the checksum removed', () async {
    await seed(productName: 'Kopi Susu', date: DateTime(2026, 9, 20));
    final json = await service.exportData();
    json.remove('checksum');

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );
  });

  test('legacy v1 file without checksum still restores', () async {
    await seed(productName: 'Kopi Susu', date: DateTime(2026, 9, 20));
    final json = await service.exportData();
    json['version'] = 1;
    json.remove('checksum');

    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(target.close);
    final result = await BackupService(target).restoreData(json);

    expect(result.items, 1);
    expect(await target.select(target.products).get(), hasLength(1));
  });

  group('merge mode', () {
    test('adds only the days that are missing locally', () async {
      await seed(productName: 'Kopi Susu', date: DateTime(2026, 9, 20));
      final json = await service.exportData();

      final target = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(target.close);
      await BackupService(target).restoreData(
        json,
        mode: RestoreMode.merge,
      );

      final targetService = BackupService(target);
      // Same day again: nothing may be duplicated.
      final second = await targetService.restoreData(
        json,
        mode: RestoreMode.merge,
      );
      expect(second.skippedRecords, 1);
      expect(second.records, 0);
      expect(second.items, 0);
      expect(await target.select(target.dailyRecords).get(), hasLength(1));
      expect(await target.select(target.dailyRecordItems).get(), hasLength(1));

      // A brand new day in the same file gets added.
      final extended = await service.exportData();
      (extended['dailyRecords'] as List).add({
        'id': 9999,
        'date': DateTime(2026, 9, 21).toIso8601String(),
        'totalRevenue': 0,
        'totalCost': 0,
        'totalProfit': 0,
        'totalQuantity': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      (extended['dailyRecordItems'] as List).add({
        'id': 9998,
        'dailyRecordId': 9999,
        'productId': 1,
        'productNameSnapshot': 'Kopi Susu',
        'unitSnapshot': 'pcs',
        'hppSnapshot': 5000,
        'sellingPriceSnapshot': 10000,
        'quantity': 1,
        'subtotalRevenue': 10000,
        'subtotalCost': 5000,
        'subtotalProfit': 5000,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Re-checksum so the file passes validation.
      final merged = await targetService.restoreData(
        {...extended, 'checksum': BackupService.checksumOf(extended)},
        mode: RestoreMode.merge,
      );
      expect(merged.records, 1);
      expect(merged.items, 1);
      expect(merged.skippedRecords, 1);
      expect(await target.select(target.dailyRecords).get(), hasLength(2));
    });

    test('reuses existing products by name instead of duplicating them',
        () async {
      await seed(productName: 'Kopi Susu', date: DateTime(2026, 9, 20));
      final json = await service.exportData();

      final target = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(target.close);
      await target.into(target.products).insert(
            ProductsCompanion.insert(name: 'Kopi Susu'),
          );
      final result =
          await BackupService(target).restoreData(json, mode: RestoreMode.merge);

      expect(result.products, 0);
      expect(await target.select(target.products).get(), hasLength(1));
    });
  });
}
