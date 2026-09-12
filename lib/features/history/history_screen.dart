import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/daily_record_provider.dart';
import '../../database/app_database.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(allRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
      ),
      body: recordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text('Gagal memuat data')),
        data: (records) {
          final recordDates = <DateTime, DailyRecord>{};
          for (final r in records) {
            final dateOnly = DateTime(r.date.year, r.date.month, r.date.day);
            recordDates[dateOnly] = r;
          }

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime.now(),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  final dateOnly = DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  );
                  if (recordDates.containsKey(dateOnly)) {
                    context.push('/detail-rekap/${dateOnly.toIso8601String()}');
                  }
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primaryGreenDark,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final dateOnly = DateTime(day.year, day.month, day.day);
                    final record = recordDates[dateOnly];
                    if (record != null) {
                      final isProfit = record.totalProfit > 0;
                      final isLoss = record.totalProfit < 0;
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isProfit
                                ? AppColors.profit
                                : isLoss
                                    ? AppColors.loss
                                    : AppColors.breakEven,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              if (_selectedDay != null)
                Expanded(
                  child: _buildSelectedDaySummary(_selectedDay!, recordDates),
                ),
              if (_selectedDay == null)
                Expanded(
                  child: _buildRecordList(records),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedDaySummary(
      DateTime day, Map<DateTime, DailyRecord> recordDates) {
    final dateOnly = DateTime(day.year, day.month, day.day);
    final record = recordDates[dateOnly];

    if (record == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 48, color: AppColors.textHint),
            const SizedBox(height: 8),
            Text(
              'Tidak ada rekap pada ${DateFormatter.formatShort(day)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormatter.formatFull(day),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _SummaryItem(
                  label: 'Omzet',
                  value: CurrencyFormatter.formatRupiah(record.totalRevenue),
                ),
                const SizedBox(width: 16),
                _SummaryItem(
                  label: 'Modal',
                  value: CurrencyFormatter.formatRupiah(record.totalCost),
                ),
                const SizedBox(width: 16),
                _SummaryItem(
                  label: 'Laba',
                  value: CurrencyFormatter.formatRupiah(record.totalProfit),
                  color: record.totalProfit > 0
                      ? AppColors.profit
                      : record.totalProfit < 0
                          ? AppColors.loss
                          : AppColors.breakEven,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${record.totalQuantity} unit terjual',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordList(List<DailyRecord> records) {
    if (records.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_outlined, size: 48, color: AppColors.textHint),
            SizedBox(height: 8),
            Text(
              'Belum ada riwayat',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              DateFormatter.formatShort(record.date),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Omzet: ${CurrencyFormatter.formatRupiah(record.totalRevenue)} • ${record.totalQuantity} unit',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: record.totalProfit > 0
                    ? AppColors.profit.withAlpha(25)
                    : record.totalProfit < 0
                        ? AppColors.loss.withAlpha(25)
                        : AppColors.breakEven.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                CurrencyFormatter.formatRupiah(record.totalProfit),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: record.totalProfit > 0
                      ? AppColors.profit
                      : record.totalProfit < 0
                          ? AppColors.loss
                          : AppColors.breakEven,
                ),
              ),
            ),
            onTap: () {
              final dateOnly = DateTime(
                record.date.year,
                record.date.month,
                record.date.day,
              );
              context.push('/detail-rekap/${dateOnly.toIso8601String()}');
            },
          ),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
