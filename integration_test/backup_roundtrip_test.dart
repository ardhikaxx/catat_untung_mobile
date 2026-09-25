import 'dart:convert';
import 'dart:io';

import 'package:catat_untung/data/repositories/daily_record_repository.dart';
import 'package:catat_untung/data/services/backup_service.dart';
import 'package:catat_untung/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// End-to-end backup round trip against a real on-disk SQLite file, using the
/// same engine as the app in production (WAL, foreign keys, drift migrations).
///
/// Run with a device or emulator attached:
///   flutter test integration_test/backup_roundtrip_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase db;
  late DailyRecordRepository records;
  late BackupService backup;

  Future<AppDatabase> openFileDatabase(String name) async {
    final file = File('${tempDir.path}/$name');
    return AppDatabase.forTesting(NativeDatabase.createInBackground(file));
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('catat_reathe_it');
    db = await openFileDatabase('source.db');
    records = DailyRecordRepository(db);
    backup = BackupService(db);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('rekap -> backup file -> restore on a second install', () async {
    final productId = await db.into(db.products).insert(
          ProductsCompanion.insert(
            name: 'Kopi Susu',
            hpp: const Value(9000),
            sellingPrice: const Value(18000),
            unit: const Value('cup'),
          ),
        );
    await records.saveDailyRecord(
      date: DateTime(2026, 9, 20),
      items: [
        DailyRecordItemData(
          productId: productId,
          productName: 'Kopi Susu',
          unit: 'cup',
          hpp: 9000,
          sellingPrice: 18000,
          quantity: 4,
          subtotalRevenue: 72000,
          subtotalCost: 36000,
          subtotalProfit: 36000,
        ),
      ],
    );

    // Write the backup file exactly like the app does.
    final payload = await backup.exportData();
    final file = File('${tempDir.path}/backup.json');
    await file.writeAsString(jsonEncode(payload));

    // A second "install" restores from that file.
    final target = await openFileDatabase('target.db');
    addTearDown(target.close);
    final restored = await BackupService(target).restoreData(
      jsonDecode(await file.readAsString()) as Map<String, dynamic>,
    );

    expect(restored.products, 1);
    expect(restored.records, 1);
    expect(restored.items, 1);

    final targetRecords = DailyRecordRepository(target);
    final record = await targetRecords.getRecordByDate(DateTime(2026, 9, 20));
    expect(record?.totalRevenue, 72000);
    expect(record?.totalProfit, 36000);

    final items = await targetRecords.getItemsByRecordId(record!.id);
    expect(items.single.productNameSnapshot, 'Kopi Susu');
    expect(items.single.unitSnapshot, 'cup');
    expect(items.single.quantity, 4);
  });

  test('corrupted backup file is rejected without data loss', () async {
    await db.into(db.products).insert(
          ProductsCompanion.insert(name: 'Teh Manis', hpp: const Value(3000)),
        );

    final payload = await backup.exportData();
    final corrupted = jsonDecode(jsonEncode(payload)) as Map<String, dynamic>;
    (corrupted['dailyRecords'] as List).clear();

    await expectLater(
      backup.restoreData(corrupted),
      throwsA(isA<BackupFormatException>()),
    );
    expect(await db.select(db.products).get(), hasLength(1));
  });
}
