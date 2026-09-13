import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/calculation_utils.dart';
import '../../../database/app_database.dart';

class HistoryMonthHeroCard extends StatelessWidget {
  final DateTime focusedMonth;
  final List<DailyRecord> recordsInMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canGoNext;

  const HistoryMonthHeroCard({
    super.key,
    required this.focusedMonth,
    required this.recordsInMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    int totalRevenue = 0;
    int totalCost = 0;
    int totalProfit = 0;
    int totalQuantity = 0;

    for (final r in recordsInMonth) {
      totalRevenue += r.totalRevenue;
      totalCost += r.totalCost;
      totalProfit += r.totalProfit;
      totalQuantity += r.totalQuantity;
    }

    final margin = CalculationUtils.calculateMargin(totalRevenue, totalCost);
    final isProfit = totalProfit >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreenDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withAlpha(50),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Selector Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Month Button
              InkWell(
                onTap: onPreviousMonth,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.arrow_left_2,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

              // Current Month Label
              Row(
                children: [
                  const Icon(
                    Iconsax.calendar_2,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormatter.formatMonthYear(focusedMonth),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),

              // Next Month Button
              InkWell(
                onTap: canGoNext ? onNextMonth : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: canGoNext
                        ? Colors.white.withAlpha(40)
                        : Colors.white.withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Iconsax.arrow_right_3,
                    color: canGoNext
                        ? Colors.white
                        : Colors.white.withAlpha(80),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Main KPI: Net Profit
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL LABA BULAN INI',
                    style: TextStyle(
                      color: Colors.white.withAlpha(190),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.formatRupiah(totalProfit),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              // Margin Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isProfit
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                      size: 13,
                      color: isProfit
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$margin% Margin',
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
          Container(
            height: 1,
            color: Colors.white.withAlpha(35),
          ),
          const SizedBox(height: 14),

          // Sub-metrics (Omzet, Modal, Aktivitas)
          Row(
            children: [
              // Omzet
              Expanded(
                child: _buildSubMetric(
                  label: 'Total Omzet',
                  value: CurrencyFormatter.formatRupiah(totalRevenue),
                ),
              ),

              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(35),
              ),

              // Modal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildSubMetric(
                    label: 'Total Modal',
                    value: CurrencyFormatter.formatRupiah(totalCost),
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(35),
              ),

              // Aktif
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildSubMetric(
                    label: 'Hari Tercatat',
                    value: '${recordsInMonth.length} Hari ($totalQuantity unit)',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubMetric({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(180),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
