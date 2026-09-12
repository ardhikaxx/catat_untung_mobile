import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final todayRecordProvider = StreamProvider<DailyRecord?>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(dailyRecordRepositoryProvider).watchRecordByDate(date);
});

final todayItemsProvider = StreamProvider<List<DailyRecordItem>>((ref) {
  final record = ref.watch(todayRecordProvider).valueOrNull;
  if (record == null) return Stream.value([]);
  return ref.watch(dailyRecordRepositoryProvider).watchItemsByRecordId(record.id);
});

final allRecordsProvider = StreamProvider<List<DailyRecord>>((ref) {
  return ref.watch(dailyRecordRepositoryProvider).watchAllRecords();
});

final recordByDateProvider = StreamProvider.family<DailyRecord?, DateTime>((ref, date) {
  return ref.watch(dailyRecordRepositoryProvider).watchRecordByDate(date);
});

final itemsByRecordIdProvider = StreamProvider.family<List<DailyRecordItem>, int>((ref, recordId) {
  return ref.watch(dailyRecordRepositoryProvider).watchItemsByRecordId(recordId);
});

final recordsBetweenProvider = StreamProvider.family<List<DailyRecord>, ({DateTime start, DateTime end})>((ref, params) {
  return ref.watch(dailyRecordRepositoryProvider).watchRecordsBetween(params.start, params.end);
});
