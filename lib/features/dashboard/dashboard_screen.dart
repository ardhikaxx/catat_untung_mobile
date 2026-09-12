import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/daily_record_provider.dart';
import '../../providers/product_provider.dart';
import '../../shared/widgets/summary_card.dart';
import '../../shared/widgets/profit_indicator.dart';
import '../../shared/widgets/loading_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayRecord = ref.watch(todayRecordProvider);
    final productCount = ref.watch(productCountProvider);
    final allRecords = ref.watch(allRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Untung'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.box),
            tooltip: 'Master Produk',
            onPressed: () => context.push('/products'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayRecordProvider);
          ref.invalidate(allRecordsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildGreeting(today),
            const SizedBox(height: 16),
            _buildTodaySummary(todayRecord, productCount),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildRecentChart(allRecords),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(DateTime today) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormatter.greeting(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormatter.formatFull(today),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySummary(AsyncValue recordAsync, AsyncValue countAsync) {
    return recordAsync.when(
      loading: () => const LoadingState(),
      error: (e, s) => const Center(child: Text('Gagal memuat data')),
      data: (record) {
        final totalRevenue = record?.totalRevenue ?? 0;
        final totalCost = record?.totalCost ?? 0;
        final totalProfit = record?.totalProfit ?? 0;
        final totalQty = record?.totalQuantity ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performa Hari Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Omzet',
                    value: CurrencyFormatter.formatRupiah(totalRevenue),
                    icon: Iconsax.wallet_3,
                    iconColor: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SummaryCard(
                    title: 'Total Modal',
                    value: CurrencyFormatter.formatRupiah(totalCost),
                    icon: Iconsax.bag,
                    iconColor: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Laba Bersih',
                    value: CurrencyFormatter.formatRupiah(totalProfit),
                    valueColor: totalProfit > 0
                        ? AppColors.profit
                        : totalProfit < 0
                            ? AppColors.loss
                            : AppColors.breakEven,
                    icon: totalProfit >= 0
                        ? Iconsax.arrow_up_3
                        : Iconsax.arrow_down3,
                    iconColor: totalProfit > 0
                        ? AppColors.profit
                        : totalProfit < 0
                            ? AppColors.loss
                            : AppColors.breakEven,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SummaryCard(
                    title: 'Unit Terjual',
                    value: '$totalQty',
                    icon: Iconsax.box,
                    iconColor: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (record != null) ProfitIndicator(amount: totalProfit),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/daily-rekap'),
            icon: const Icon(Iconsax.edit_2),
            label: const Text('Rekap Penjualan Hari Ini'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentChart(AsyncValue recordsAsync) {
    return recordsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
      data: (records) {
        if (records.isEmpty) {
          return const SizedBox.shrink();
        }

        final last7 = records.length > 7 ? records.sublist(0, 7) : records;
        final chartData = last7.reversed.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tren Laba 7 Hari Terakhir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(chartData),
                      minY: _getMinY(chartData),
                      barGroups: List.generate(chartData.length, (index) {
                        final record = chartData[index];
                        final profit = record.totalProfit.toDouble();
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: profit,
                              color: profit >= 0
                                  ? AppColors.chartGreen
                                  : AppColors.chartRed,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
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
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx >= 0 && idx < chartData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    DateFormatter.formatDayMonth(
                                        chartData[idx].date),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                CurrencyFormatter.formatRupiahCompact(
                                    value.toInt()),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getMaxY(List records) {
    if (records.isEmpty) return 100;
    final maxProfit = records
        .map<double>((r) => r.totalProfit.toDouble())
        .fold<double>(0, (a, b) => a > b ? a : b);
    return maxProfit > 0 ? maxProfit * 1.2 : 100;
  }

  double _getMinY(List records) {
    if (records.isEmpty) return 0;
    final minProfit = records
        .map<double>((r) => r.totalProfit.toDouble())
        .fold<double>(0, (a, b) => a < b ? a : b);
    return minProfit < 0 ? minProfit * 1.2 : 0;
  }
}
