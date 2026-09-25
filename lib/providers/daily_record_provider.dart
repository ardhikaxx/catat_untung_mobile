import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final todayRecordProvider = StreamProvider<DailyRecord?>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return ref.watch(dailyRecordRepositoryProvider).watchRecordByDate(today);
});

final allRecordsProvider = StreamProvider<List<DailyRecord>>((ref) {
  return ref.watch(dailyRecordRepositoryProvider).watchAllRecords();
});

final recordByDateProvider =
    StreamProvider.autoDispose.family<DailyRecord?, DateTime>((ref, date) {
  return ref.watch(dailyRecordRepositoryProvider).watchRecordByDate(date);
});

final itemsByRecordIdProvider =
    StreamProvider.autoDispose.family<List<DailyRecordItem>, int>(
        (ref, recordId) {
  return ref.watch(dailyRecordRepositoryProvider).watchItemsByRecordId(recordId);
});
