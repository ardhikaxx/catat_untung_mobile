import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../reports_screen.dart';

class ReportHeroCard extends StatelessWidget {
  final ReportData data;
  final ({DateTime start, DateTime end}) dateRange;

  const ReportHeroCard({
    super.key,
    required this.data,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = data.totalProfit >= 0;
    final startDateStr = DateFormat('d MMM yyyy', 'id_ID').format(dateRange.start);
    final endDateStr = DateFormat('d MMM yyyy', 'id_ID').format(dateRange.end);
    final dateRangeLabel = dateRange.start == dateRange.end
        ? startDateStr
        : '$startDateStr - $endDateStr';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isProfit
              ? const [AppColors.primaryGreen, AppColors.primaryGreenDark]
              : const [Color(0xFFB91C1C), Color(0xFF881337)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (isProfit ? AppColors.primaryGreen : const Color(0xFFB91C1C))
                .withAlpha(55),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Range Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.calendar_1,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateRangeLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isProfit
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                      size: 12,
                      color: isProfit
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data.margin}% Margin',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isProfit
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Net Profit Main KPI
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL LABA BERSIH',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.white.withAlpha(190),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isProfit ? '+' : ''}${CurrencyFormatter.formatRupiah(data.totalProfit)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    Iconsax.trend_up,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withAlpha(35),
          ),
          const SizedBox(height: 14),

          // 3 Sub-metrics (Omzet, Modal, Rata-rata per hari)
          Row(
            children: [
              Expanded(
                child: _buildSubStat(
                  label: 'Total Omzet',
                  value: CurrencyFormatter.formatRupiah(data.totalRevenue),
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(35),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildSubStat(
                    label: 'Total Modal',
                    value: CurrencyFormatter.formatRupiah(data.totalCost),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(35),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildSubStat(
                    label: 'Rata-rata / Hari',
                    value: CurrencyFormatter.formatRupiah(data.avgProfit),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white.withAlpha(170),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
