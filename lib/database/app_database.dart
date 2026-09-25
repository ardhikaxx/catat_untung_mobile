import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import 'daos/products_dao.dart';
import 'tables/daily_record_items_table.dart';
import 'tables/daily_records_table.dart';
import 'tables/products_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products, DailyRecords, DailyRecordItems], daos: [ProductsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2: index foreign keys used by record/item lookups
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_daily_record_items_record '
              'ON daily_record_items (daily_record_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_daily_record_items_product '
              'ON daily_record_items (product_id)',
            );
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode=WAL');
          await customStatement('PRAGMA foreign_keys=ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.dbName));
    return NativeDatabase.createInBackground(file);
  });
}
