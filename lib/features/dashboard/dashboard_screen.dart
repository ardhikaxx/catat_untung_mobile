import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../database/app_database.dart';
import '../../providers/daily_record_provider.dart';
import '../../shared/widgets/loading_state.dart';
import '../home/home_screen.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/omzet_hero_card.dart';
import 'widgets/dashboard_action_bar.dart';
import 'widgets/performance_list_section.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final todayRecord = ref.watch(todayRecordProvider);
    final todayItems = ref.watch(todayItemsProvider);
    final allRecords = ref.watch(allRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardHeader(
        onMenuTap: () => _showQuickMenu(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayRecordProvider);
          ref.invalidate(todayItemsProvider);
          ref.invalidate(allRecordsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            // 1. Hero Total Omzet Card (Semua Data)
              allRecords.when(
                loading: () => const SizedBox(
                  height: 222,
                  child: LoadingState(),
                ),
                error: (e, s) => Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text('Gagal memuat data omzet'),
                ),
                data: (records) {
                  final totalRevenue = records.fold<int>(0, (sum, r) => sum + r.totalRevenue);
                  final totalProfit = records.fold<int>(0, (sum, r) => sum + r.totalProfit);
                  final totalQty = records.fold<int>(0, (sum, r) => sum + r.totalQuantity);

                  return OmzetHeroCard(
                    totalRevenue: totalRevenue,
                    totalProfit: totalProfit,
                    totalQuantity: totalQty,
                    badgeLabel: 'Semua Data',
                    onRekapTap: () {
                      ref.read(currentTabProvider.notifier).state = 1;
                    },
                  );
                },
              ),
              const SizedBox(height: 18),

              // 3. Quick Action Buttons Container (Rekap, Riwayat, Produk, HPP)
              DashboardActionBar(
                onRekap: () {
                  ref.read(currentTabProvider.notifier).state = 1;
                },
                onRiwayat: () {
                  ref.read(currentTabProvider.notifier).state = 2;
                },
                onProduk: () => context.push('/products'),
                onKalkulator: () => context.push('/calculator'),
              ),
              const SizedBox(height: 24),

              // 4. Performance Breakdown List ("Manage Expenses" style)
              todayRecord.when(
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
                data: (record) {
                  final totalRevenue = record?.totalRevenue ?? 0;
                  final totalCost = record?.totalCost ?? 0;
                  final totalProfit = record?.totalProfit ?? 0;
                  final totalQty = record?.totalQuantity ?? 0;
                  final items = todayItems.valueOrNull ?? [];

                  return PerformanceListSection(
                    totalRevenue: totalRevenue,
                    totalCost: totalCost,
                    totalProfit: totalProfit,
                    totalQuantity: totalQty,
                    todayItems: items,
                    onViewAll: () {
                      ref.read(currentTabProvider.notifier).state = 2;
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // 5. 7-Day Profit Trend Chart
              _buildRecentChart(allRecords),

              // Spacing at the bottom for floating bottom navigation bar
              const SizedBox(height: 110),
            ],
          ),
        ),
      );
  }

  Widget _buildRecentChart(AsyncValue<List<DailyRecord>> recordsAsync) {
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                              ? AppColors.profit
                              : AppColors.loss,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
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
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                DateFormatter.formatDayMonth(
                                  chartData[idx].date,
                                ),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
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
                        reservedSize: 52,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            CurrencyFormatter.formatRupiahCompact(
                              value.toInt(),
                            ),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getMaxY(List<DailyRecord> records) {
    if (records.isEmpty) return 100;
    final maxProfit = records
        .map<double>((r) => r.totalProfit.toDouble())
        .fold<double>(0, (a, b) => a > b ? a : b);
    return maxProfit > 0 ? maxProfit * 1.2 : 100;
  }

  double _getMinY(List<DailyRecord> records) {
    if (records.isEmpty) return 0;
    final minProfit = records
        .map<double>((r) => r.totalProfit.toDouble())
        .fold<double>(0, (a, b) => a < b ? a : b);
    return minProfit < 0 ? minProfit * 1.2 : 0;
  }

  void _showQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          AppConstants.appLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Menu Cepat Catat Untung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                ListTile(
                  leading: const Icon(LucideIcons.package, color: Color(0xFF2563EB)),
                  title: const Text('Master Produk'),
                  subtitle: const Text('Kelola daftar barang dagangan & HPP'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/products');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.edit, color: Color(0xFF16A34A)),
                  title: const Text('Rekap Penjualan'),
                  subtitle: const Text('Catat penjualan harian toko'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ref.read(currentTabProvider.notifier).state = 1;
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.calculator, color: Color(0xFFF59E0B)),
                  title: const Text('Kalkulator HPP'),
                  subtitle: const Text('Hitung harga pokok & margin untung'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/calculator');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.fileDown, color: AppColors.primaryGreen),
                  title: const Text('Ekspor Laporan'),
                  subtitle: const Text('Unduh laporan PDF & CSV'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/export');
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.settings, color: Color(0xFF475569)),
                  title: const Text('Pengaturan'),
                  subtitle: const Text('Setelan toko & cadangan data'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/settings');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
