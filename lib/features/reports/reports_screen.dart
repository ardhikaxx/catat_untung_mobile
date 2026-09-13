import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../shared/widgets/loading_state.dart';
import 'widgets/report_period_selector.dart';
import 'widgets/report_hero_card.dart';
import 'widgets/report_trend_chart.dart';
import 'widgets/report_metrics_grid.dart';
import 'widgets/report_top_products.dart';

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
    final dateRange = ref.watch(reportDateRangeProvider);
    final reportAsync = ref.watch(reportDataProvider);
    final canPop = Navigator.canPop(context);
    final bottomSpacing = canPop ? 24.0 : 110.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        leading: canPop
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0.5,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.maybePop(context),
                    child: const Center(
                      child: Icon(
                        Iconsax.arrow_left_2,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.chart_21,
                    size: 20,
                    color: Color(0xFF6C4AB6),
                  ),
                ),
              ),
        title: const Text(
          'Laporan & Tren',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Ekspor Laporan',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.export_3,
                size: 18,
                color: Color(0xFF6C4AB6),
              ),
            ),
            onPressed: () => context.push('/export'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF6C4AB6),
        onRefresh: () async {
          ref.invalidate(reportDataProvider);
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. Period Selector Bar
            const ReportPeriodSelector(),

            const SizedBox(height: 4),

            // 2. Report Content
            reportAsync.when(
              loading: () => const SizedBox(
                height: 350,
                child: LoadingState(message: 'Memuat analisis laporan & tren...'),
              ),
              error: (e, s) => Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Icon(Iconsax.warning_2, size: 40, color: AppColors.error),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal Memuat Laporan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(reportDataProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4AB6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
              data: (data) {
                if (data.records.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3E8FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.chart_21,
                            size: 34,
                            color: Color(0xFF6C4AB6),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Belum Ada Data Rekap',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tidak ada catatan penjualan pada rentang waktu ini. Silakan pilih rentang waktu lain atau rekap penjualan Anda hari ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/daily-rekap'),
                            icon: const Icon(Iconsax.add_circle, size: 18),
                            label: const Text(
                              'Rekap Penjualan Sekarang',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4AB6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Summary Hero Card
                    ReportHeroCard(data: data, dateRange: dateRange),

                    // B. Interactive Daily Profit Bar Chart
                    ReportTrendChart(data: data),

                    // C. Business Health & Efficiency Metrics Grid
                    ReportMetricsGrid(data: data),

                    // D. Ranked Best Selling Products
                    ReportTopProducts(
                      topProducts: data.topProducts,
                      totalQuantity: data.totalQuantity,
                    ),
                  ],
                );
              },
            ),

            // Bottom clearance for floating navbar
            SizedBox(height: bottomSpacing),
          ],
        ),
      ),
    );
  }
}
