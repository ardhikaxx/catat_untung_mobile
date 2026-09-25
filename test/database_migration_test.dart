import 'dart:io';

import 'package:catat_untung/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('catat_migration_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<List<String>> indexNames(AppDatabase db) async {
    final rows = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name LIKE 'idx_daily_record_items%' ORDER BY name",
        )
        .get();
    return rows.map((r) => r.read<String>('name')).toList();
  }

  test('upgrade from v1 creates indexes and preserves existing data', () async {
    final file = File(p.join(tempDir.path, 'migration.db'));

    // 1. Existing database with data (current schema)
    final db1 = AppDatabase.forTesting(NativeDatabase(file));
    final productId = await db1
        .into(db1.products)
        .insert(ProductsCompanion.insert(name: 'Kopi Susu'));
    final recordId = await db1.into(db1.dailyRecords).insert(
          DailyRecordsCompanion.insert(date: DateTime(2026, 9, 24)),
        );
    await db1.into(db1.dailyRecordItems).insert(
          DailyRecordItemsCompanion.insert(
            dailyRecordId: recordId,
            productId: Value(productId),
            productNameSnapshot: 'Kopi Susu',
            quantity: const Value(2),
          ),
        );
    expect(await indexNames(db1), hasLength(2));

    // 2. Simulate an old v1 database: no indexes, user_version = 1
    await db1.customStatement(
        'DROP INDEX IF EXISTS idx_daily_record_items_record');
    await db1.customStatement(
        'DROP INDEX IF EXISTS idx_daily_record_items_product');
    await db1.customStatement('PRAGMA user_version = 1');
    expect(await indexNames(db1), isEmpty);
    await db1.close();

    // 3. Reopen: migration v1 -> v2 must run
    final db2 = AppDatabase.forTesting(NativeDatabase(file));
    expect(
      await indexNames(db2),
      containsAll(['idx_daily_record_items_record', 'idx_daily_record_items_product']),
    );

    final versionRow = await db2.customSelect('PRAGMA user_version').getSingle();
    expect(versionRow.data.values.first, 2);

    // Existing data survived the upgrade
    final products = await db2.select(db2.products).get();
    expect(products, hasLength(1));
    expect(products.single.name, 'Kopi Susu');

    final items = await db2.select(db2.dailyRecordItems).get();
    expect(items, hasLength(1));
    expect(items.single.dailyRecordId, recordId);
    expect(items.single.productId, productId);

    await db2.close();
  });

  test('new database is created at schemaVersion 2 with indexes', () async {
    final file = File(p.join(tempDir.path, 'fresh.db'));

    final db = AppDatabase.forTesting(NativeDatabase(file));
    await db.select(db.products).get();

    final versionRow = await db.customSelect('PRAGMA user_version').getSingle();
    expect(versionRow.data.values.first, 2);
    expect(await indexNames(db), hasLength(2));

    await db.close();
  });
}
