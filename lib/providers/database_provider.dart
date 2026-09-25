import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/daily_record_repository.dart';
import '../data/repositories/product_repository.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(databaseProvider));
});

final dailyRecordRepositoryProvider = Provider<DailyRecordRepository>((ref) {
  return DailyRecordRepository(ref.watch(databaseProvider));
});
