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

  Future<void> seed() async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Kopi Susu'));
    final recordId = await db.into(db.dailyRecords).insert(
          DailyRecordsCompanion.insert(date: DateTime(2026, 9, 20)),
        );
    await db.into(db.dailyRecordItems).insert(
          DailyRecordItemsCompanion.insert(
            dailyRecordId: recordId,
            productId: Value(productId),
            productNameSnapshot: 'Kopi Susu',
            quantity: const Value(3),
            subtotalProfit: const Value(15000),
          ),
        );
  }

  test('export → restore into empty db keeps ids and data (FK intact)',
      () async {
    await seed();
    final json = await service.exportData();

    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(target.close);
    await BackupService(target).restoreData(json);

    final products = await target.select(target.products).get();
    final records = await target.select(target.dailyRecords).get();
    final items = await target.select(target.dailyRecordItems).get();

    expect(products.single.name, 'Kopi Susu');
    expect(records, hasLength(1));
    expect(items.single.dailyRecordId, records.single.id);
    expect(items.single.productId, products.single.id);
    expect(items.single.quantity, 3);
    expect(items.single.subtotalProfit, 15000);
  });

  test('restore rejects foreign file and leaves data untouched', () async {
    await seed();
    final json = await service.exportData();
    json['appName'] = 'Aplikasi Lain';

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );

    final products = await db.select(db.products).get();
    expect(products.single.name, 'Kopi Susu');
  });

  test('restore rejects unsupported version', () async {
    await seed();
    final json = await service.exportData();
    json['version'] = 99;

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );
    expect(await db.select(db.products).get(), hasLength(1));
  });

  test('restore rejects broken FK reference before any destructive write',
      () async {
    await seed();
    final json = await service.exportData();
    (json['dailyRecordItems'] as List).first['dailyRecordId'] = 9999;

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );

    // Data still intact: wipe never happened.
    expect(await db.select(db.products).get(), hasLength(1));
    expect(await db.select(db.dailyRecordItems).get(), hasLength(1));
  });

  test('restore rejects duplicate record dates', () async {
    await seed();
    final json = await service.exportData();
    final records = json['dailyRecords'] as List;
    final copy = Map<String, Object>.from(records.first as Map);
    copy['id'] = 999;
    records.add(copy);

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );
    expect(await db.select(db.dailyRecords).get(), hasLength(1));
  });

  test('restore rejects malformed item payload', () async {
    await seed();
    final json = await service.exportData();
    (json['dailyRecordItems'] as List).first['productNameSnapshot'] = '';

    await expectLater(
      service.restoreData(json),
      throwsA(isA<BackupFormatException>()),
    );
    expect(await db.select(db.dailyRecordItems).get(), hasLength(1));
  });
}
