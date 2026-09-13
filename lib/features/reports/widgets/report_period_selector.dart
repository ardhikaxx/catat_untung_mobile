import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../reports_screen.dart';

class ReportPeriodSelector extends ConsumerWidget {
  const ReportPeriodSelector({super.key});

  Future<void> _selectCustomRange(BuildContext context, WidgetRef ref) async {
    final start = ref.read(customStartDateProvider);
    final end = ref.read(customEndDateProvider);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: start, end: end),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4AB6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(customStartDateProvider.notifier).state = picked.start;
      ref.read(customEndDateProvider.notifier).state = picked.end;
      ref.read(reportPeriodProvider.notifier).state = ReportPeriod.custom;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPeriod = ref.watch(reportPeriodProvider);
    final customStart = ref.watch(customStartDateProvider);
    final customEnd = ref.watch(customEndDateProvider);

    final customLabel = currentPeriod == ReportPeriod.custom
        ? '${DateFormat('d MMM', 'id_ID').format(customStart)} - ${DateFormat('d MMM', 'id_ID').format(customEnd)}'
        : 'Pilih Rentang';

    final options = [
      (period: ReportPeriod.sevenDays, label: '7 Hari Terakhir', icon: Iconsax.clock),
      (period: ReportPeriod.thisWeek, label: 'Minggu Ini', icon: Iconsax.calendar_1),
      (period: ReportPeriod.thisMonth, label: 'Bulan Ini', icon: Iconsax.calendar_2),
      (period: ReportPeriod.lastMonth, label: 'Bulan Lalu', icon: Iconsax.calendar_tick),
      (period: ReportPeriod.custom, label: customLabel, icon: Iconsax.calendar_search),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: options.map((opt) {
          final isSelected = currentPeriod == opt.period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                if (opt.period == ReportPeriod.custom) {
                  _selectCustomRange(context, ref);
                } else {
                  ref.read(reportPeriodProvider.notifier).state = opt.period;
                }
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C4AB6)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6C4AB6).withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      opt.icon,
                      size: 14,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      opt.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
