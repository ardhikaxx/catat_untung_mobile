import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
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
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
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
    final l10n = AppLocalizations.of(context);

    final customLabel = currentPeriod == ReportPeriod.custom
        ? '${DateFormat('d MMM', 'id_ID').format(customStart)} - ${DateFormat('d MMM', 'id_ID').format(customEnd)}'
        : l10n?.repsPickRange ?? 'Pilih Rentang';

    final options = [
      (period: ReportPeriod.sevenDays, label: l10n?.repsLast7Days ?? '7 Hari Terakhir', icon: LucideIcons.clock),
      (period: ReportPeriod.thisWeek, label: l10n?.repsThisWeek ?? 'Minggu Ini', icon: LucideIcons.calendar),
      (period: ReportPeriod.thisMonth, label: l10n?.repsThisMonth ?? 'Bulan Ini', icon: LucideIcons.calendar),
      (period: ReportPeriod.lastMonth, label: l10n?.repsLastMonth ?? 'Bulan Lalu', icon: LucideIcons.calendarCheck),
      (period: ReportPeriod.custom, label: customLabel, icon: LucideIcons.calendarSearch),
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
                      ? AppColors.primaryGreen
                      : AppColors.greyBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGreen.withAlpha(50),
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
                      color: isSelected ? Colors.white : AppColors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      opt.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
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
