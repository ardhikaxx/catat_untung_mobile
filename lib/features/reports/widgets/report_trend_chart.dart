import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../reports_screen.dart';

class ReportTrendChart extends StatelessWidget {
  final ReportData data;

  const ReportTrendChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (data.records.isEmpty) return const SizedBox.shrink();

    // Chronological order (oldest to newest)
    final chartData = List.of(data.records)..sort((a, b) => a.date.compareTo(b.date));

    final maxY = chartData
        .map((r) => r.totalProfit.toDouble())
        .fold<double>(0, (a, b) => a > b ? a : b);
    final minY = chartData
        .map((r) => r.totalProfit.toDouble())
        .fold<double>(0, (a, b) => a < b ? a : b);

    final topLimit = maxY > 0 ? maxY * 1.25 : 100000.0;
    final bottomLimit = minY < 0 ? minY * 1.25 : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.repsTrendTitle ?? 'Tren Laba Harian',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n?.repsTrendSubtitle ?? 'Pergerakan laba bersih harian',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegendDot(AppColors.profit, l10n?.repsProfit ?? 'Untung'),
                  const SizedBox(width: 10),
                  _buildLegendDot(AppColors.loss, l10n?.repsLoss ?? 'Rugi'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: topLimit,
                minY: bottomLimit,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => AppColors.black,
                    tooltipRoundedRadius: 10,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final record = chartData[group.x];
                      final isProfit = record.totalProfit >= 0;
                      final dateStr = DateFormat('d MMM', 'id_ID').format(record.date);
                      final profitStr =
                          '${isProfit ? '+' : ''}${CurrencyFormatter.formatRupiah(record.totalProfit)}';

                      return BarTooltipItem(
                        '$dateStr\n$profitStr',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: topLimit > 0 ? (topLimit / 3) : 50000,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Color(0xFFF1F5F9),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < chartData.length) {
                          // If too many items, show every 2nd or 3rd
                          if (chartData.length > 10 && idx % 2 != 0) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('d/M', 'id_ID').format(chartData[idx].date),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          CurrencyFormatter.formatRupiahCompact(value.toInt()),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(chartData.length, (index) {
                  final record = chartData[index];
                  final profit = record.totalProfit.toDouble();
                  final isProfit = profit >= 0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: profit,
                        color: isProfit
                            ? AppColors.profit
                            : AppColors.loss,
                        width: chartData.length > 14
                            ? 8
                            : chartData.length > 7
                                ? 14
                                : 22,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
