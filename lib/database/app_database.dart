import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../core/constants/app_constants.dart';
import 'tables/products_table.dart';
import 'tables/daily_records_table.dart';
import 'tables/daily_record_items_table.dart';
import 'daos/products_dao.dart';
import 'daos/daily_records_dao.dart';
import 'daos/daily_record_items_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products, DailyRecords, DailyRecordItems], daos: [ProductsDao, DailyRecordsDao, DailyRecordItemsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {},
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
