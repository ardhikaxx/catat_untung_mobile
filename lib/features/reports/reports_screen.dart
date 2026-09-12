import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/database_provider.dart';
import '../../database/app_database.dart';
import '../../shared/widgets/loading_state.dart';
import '../../shared/widgets/empty_state.dart';

enum ReportPeriod { sevenDays, thisWeek, thisMonth, lastMonth, custom }

final reportPeriodProvider = StateProvider<ReportPeriod>((ref) => ReportPeriod.sevenDays);
final customStartDateProvider = StateProvider<DateTime>((ref) => DateTime.now().subtract(const Duration(days: 30)));
final customEndDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final reportDateRangeProvider = Provider<({DateTime start, DateTime end})>((ref) {
  final period = ref.watch(reportPeriodProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return switch (period) {
    ReportPeriod.sevenDays => (
      start: today.subtract(const Duration(days: 6)),
      end: today,
    ),
    ReportPeriod.thisWeek => (
      start: today.subtract(Duration(days: today.weekday - 1)),
      end: today,
    ),
    ReportPeriod.thisMonth => (
      start: DateTime(now.year, now.month, 1),
      end: today,
    ),
    ReportPeriod.lastMonth => (
      start: DateTime(now.year, now.month - 1, 1),
      end: DateTime(now.year, now.month, 0),
    ),
    ReportPeriod.custom => (
      start: ref.watch(customStartDateProvider),
      end: ref.watch(customEndDateProvider),
    ),
  };
});

final reportDataProvider = FutureProvider<ReportData>((ref) async {
  final range = ref.watch(reportDateRangeProvider);
  final repo = ref.watch(dailyRecordRepositoryProvider);
  final records = await repo.getRecordsBetween(range.start, range.end);
  final items = await repo.getItemsBetween(range.start, range.end);

  final totalRevenue = records.fold<int>(0, (sum, r) => sum + r.totalRevenue);
  final totalCost = records.fold<int>(0, (sum, r) => sum + r.totalCost);
  final totalProfit = totalRevenue - totalCost;
  final totalQuantity = records.fold<int>(0, (sum, r) => sum + r.totalQuantity);
  final daysWithData = records.length;
  final avgProfit = daysWithData > 0 ? totalProfit ~/ daysWithData : 0;
  final margin = totalRevenue > 0
      ? ((totalProfit / totalRevenue) * 100).round()
      : 0;

  final productSales = <int, ProductAgg>{};
  for (final item in items) {
    final key = item.productId ?? 0;
    final existing = productSales[key];
    if (existing != null) {
      existing.quantity += item.quantity;
      existing.revenue += item.subtotalRevenue;
      existing.cost += item.subtotalCost;
    } else {
      productSales[key] = ProductAgg(
        name: item.productNameSnapshot,
        quantity: item.quantity,
        revenue: item.subtotalRevenue,
        cost: item.subtotalCost,
      );
    }
  }

  final topProducts = productSales.values.toList()
    ..sort((a, b) => b.quantity.compareTo(a.quantity));

  return ReportData(
    records: records,
    totalRevenue: totalRevenue,
    totalCost: totalCost,
    totalProfit: totalProfit,
    totalQuantity: totalQuantity,
    avgProfit: avgProfit,
    margin: margin,
    topProducts: topProducts,
  );
});

class ReportData {
  final List<DailyRecord> records;
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;
  final int totalQuantity;
  final int avgProfit;
  final int margin;
  final List<ProductAgg> topProducts;

  ReportData({
    required this.records,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.totalQuantity,
    required this.avgProfit,
    required this.margin,
    required this.topProducts,
  });
}

class ProductAgg {
  final String name;
  int quantity;
  int revenue;
  int cost;

  ProductAgg({
    required this.name,
    required this.quantity,
    required this.revenue,
    required this.cost,
  });

  int get profit => revenue - cost;
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(reportPeriodProvider);
    final reportAsync = ref.watch(reportDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan & Tren'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPeriodSelector(ref, period),
          const SizedBox(height: 16),
          reportAsync.when(
            loading: () => const LoadingState(message: 'Memuat laporan...'),
            error: (e, s) => const Center(child: Text('Gagal memuat laporan')),
            data: (data) {
              if (data.records.isEmpty) {
                return const EmptyState(
                  icon: Icons.analytics_outlined,
                  title: 'Belum Ada Data',
                  subtitle: 'Belum ada rekap penjualan pada periode ini',
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummarySection(data),
                  const SizedBox(height: 16),
                  _buildChartSection(data),
                  const SizedBox(height: 16),
                  _buildTopProductsSection(data),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(WidgetRef ref, ReportPeriod current) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _PeriodChip(
            label: '7 Hari',
            selected: current == ReportPeriod.sevenDays,
            onTap: () => ref.read(reportPeriodProvider.notifier).state = ReportPeriod.sevenDays,
          ),
          const SizedBox(width: 8),
          _PeriodChip(
            label: 'Minggu Ini',
            selected: current == ReportPeriod.thisWeek,
            onTap: () => ref.read(reportPeriodProvider.notifier).state = ReportPeriod.thisWeek,
          ),
          const SizedBox(width: 8),
          _PeriodChip(
            label: 'Bulan Ini',
            selected: current == ReportPeriod.thisMonth,
            onTap: () => ref.read(reportPeriodProvider.notifier).state = ReportPeriod.thisMonth,
          ),
          const SizedBox(width: 8),
          _PeriodChip(
            label: 'Bulan Lalu',
            selected: current == ReportPeriod.lastMonth,
            onTap: () => ref.read(reportPeriodProvider.notifier).state = ReportPeriod.lastMonth,
          ),
          const SizedBox(width: 8),
          _PeriodChip(
            label: 'Custom',
            selected: current == ReportPeriod.custom,
            onTap: () => ref.read(reportPeriodProvider.notifier).state = ReportPeriod.custom,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ReportData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Total Omzet',
                value: CurrencyFormatter.formatRupiah(data.totalRevenue),
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                title: 'Total Modal',
                value: CurrencyFormatter.formatRupiah(data.totalCost),
                icon: Icons.shopping_cart_outlined,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Laba Bersih',
                value: CurrencyFormatter.formatRupiah(data.totalProfit),
                icon: data.totalProfit >= 0 ? Icons.trending_up : Icons.trending_down,
                color: data.totalProfit > 0
                    ? AppColors.profit
                    : data.totalProfit < 0
                        ? AppColors.loss
                        : AppColors.breakEven,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                title: 'Rata-rata/Hari',
                value: CurrencyFormatter.formatRupiah(data.avgProfit),
                icon: Icons.today,
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Total Unit',
                value: '${data.totalQuantity}',
                icon: Icons.inventory_outlined,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                title: 'Margin',
                value: '${data.margin}%',
                icon: Icons.percent,
                color: data.margin > 0 ? AppColors.profit : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartSection(ReportData data) {
    if (data.records.isEmpty) return const SizedBox.shrink();

    final chartData = data.records.reversed.toList();
    final maxY = chartData.map((r) => r.totalProfit.toDouble()).fold<double>(
        0, (a, b) => a > b ? a : b);
    final minY = chartData.map((r) => r.totalProfit.toDouble()).fold<double>(
        0, (a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tren Laba Harian',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY > 0 ? maxY * 1.2 : 100,
                  minY: minY < 0 ? minY * 1.2 : 0,
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
                          width: chartData.length > 14 ? 12 : 20,
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
                                DateFormatter.formatDayMonth(chartData[idx].date),
                                style: const TextStyle(
                                  fontSize: 9,
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
                            CurrencyFormatter.formatRupiahCompact(value.toInt()),
                            style: const TextStyle(
                              fontSize: 9,
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
  }

  Widget _buildTopProductsSection(ReportData data) {
    if (data.topProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Sales / Produk Paling Laris',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(data.topProducts.length, (index) {
          final product = data.topProducts[index];
          final rank = index + 1;
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: rank <= 3
                    ? AppColors.primaryGreen.withAlpha(25)
                    : AppColors.textHint.withAlpha(25),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: rank <= 3 ? AppColors.primaryGreen : AppColors.textSecondary,
                  ),
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${product.quantity} unit • Omzet ${CurrencyFormatter.formatRupiah(product.revenue)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                CurrencyFormatter.formatRupiah(product.profit),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: product.profit >= 0 ? AppColors.profit : AppColors.loss,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryGreen.withAlpha(25),
      checkmarkColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        color: selected ? AppColors.primaryGreen : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
