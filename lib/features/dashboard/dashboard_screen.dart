import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../database/app_database.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/daily_record_provider.dart';
import '../../shared/widgets/loading_state.dart';
import '../home/home_screen.dart';
import 'widgets/dashboard_action_bar.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/omzet_hero_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayRecord = ref.watch(todayRecordProvider);
    final allRecords = ref.watch(allRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardHeader(
        onMenuTap: () => _showQuickMenu(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayRecordProvider);
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
                error: (e, s) {
                  AppLogger.record('Dashboard.omzet', e, s);
                  return _errorCard(
                    l10n?.dashLoadOmzetFailed ?? 'Gagal memuat data omzet',
                    () => ref.invalidate(allRecordsProvider),
                  );
                },
                data: (records) {
                  final totalRevenue = records.fold<int>(0, (sum, r) => sum + r.totalRevenue);
                  final totalProfit = records.fold<int>(0, (sum, r) => sum + r.totalProfit);
                  final totalQty = records.fold<int>(0, (sum, r) => sum + r.totalQuantity);

                  return OmzetHeroCard(
                    totalRevenue: totalRevenue,
                    totalProfit: totalProfit,
                    totalQuantity: totalQty,
                    badgeLabel: l10n?.dashAllData ?? 'Semua Data',
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

              // 4. 7-Day Profit Trend Chart (langsung terlihat tanpa scroll)
              _buildRecentChart(allRecords),

              const SizedBox(height: 24),

              // 5. Kartu Rekap Hari Ini
              todayRecord.when(
                loading: () => Container(
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                error: (e, s) {
                  AppLogger.record('Dashboard.rekapHariIni', e, s);
                  return _errorCard(
                    l10n?.dashLoadTodayRecapFailed ??
                        'Gagal memuat rekap hari ini',
                    () => ref.invalidate(todayRecordProvider),
                    height: 88,
                  );
                },
                data: _buildTodayRecapCard,
              ),
              // Spacing at the bottom for floating bottom navigation bar
              const SizedBox(height: 110),
            ],
          ),
        ),
      );
  }

  Widget _buildTodayRecapCard(DailyRecord? record) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (record == null) {
      final yesterday = today.subtract(const Duration(days: 1));
      DailyRecord? yesterdayRecord;
      for (final r in ref.read(allRecordsProvider).valueOrNull ?? []) {
        final d = DateTime(r.date.year, r.date.month, r.date.day);
        if (d == yesterday) {
          yesterdayRecord = r;
          break;
        }
      }

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.greyBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.greenTint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                LucideIcons.clipboardList,
                size: 22,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.dashTodayRecap ?? 'Rekap Hari Ini',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _statusChip(
                        l10n?.dashNotRecapped ?? 'Belum Rekap',
                        AppColors.warning,
                        AppColors.greyBg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    yesterdayRecord != null
                        ? 'Laba kemarin ${CurrencyFormatter.formatRupiah(yesterdayRecord.totalProfit)} — yuk isi rekap hari ini.'
                        : l10n?.dashRecordTodayPrompt ??
                            'Yuk, catat penjualan hari ini.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                ref.read(currentTabProvider.notifier).state = 1;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(l10n?.dashFillNow ?? 'Isi Sekarang'),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () => context.push('/detail-rekap/${today.toIso8601String()}'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.greyBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n?.dashTodayRecap ?? 'Rekap Hari Ini',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                _statusChip(
                  l10n?.dashAlreadyRecapped ?? 'Sudah Rekap',
                  AppColors.primaryGreen,
                  AppColors.greenTint,
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.textHint,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _todayStat(
                  l10n?.dashOmzet ?? 'Omzet',
                  CurrencyFormatter.formatRupiah(record.totalRevenue),
                  AppColors.textPrimary,
                ),
                _todayStat(
                  l10n?.dashProfit ?? 'Laba',
                  CurrencyFormatter.formatRupiah(record.totalProfit),
                  record.totalProfit < 0 ? AppColors.loss : AppColors.profit,
                ),
                _todayStat(
                  l10n?.dashSold ?? 'Terjual',
                  '${record.totalQuantity} item',
                  AppColors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _todayStat(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _errorCard(String message, VoidCallback onRetry, {double height = 140}) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(l10n?.dashRetry ?? 'Coba lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChart(AsyncValue<List<DailyRecord>> recordsAsync) {
    final l10n = AppLocalizations.of(context);
    return recordsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) {
        AppLogger.record('Dashboard.tren', e, s);
        return _errorCard(
          l10n?.dashLoadProfitTrendFailed ?? 'Gagal memuat tren laba',
          () => ref.invalidate(allRecordsProvider),
          height: 88,
        );
      },
      data: (records) {
        if (records.isEmpty) {
          return const SizedBox.shrink();
        }

        final last7 = records.length > 7 ? records.sublist(0, 7) : records;
        final chartData = last7.reversed.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.dashProfitTrendTitle ?? 'Tren Laba 7 Hari Terakhir',
              style: const TextStyle(
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
                        final dateStr = DateFormatter.formatDayMonth(record.date);
                        final profitStr =
                            '${record.totalProfit >= 0 ? '+' : ''}${CurrencyFormatter.formatRupiah(record.totalProfit)}';

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
    final l10n = AppLocalizations.of(context);
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
                    Text(
                      l10n?.dashQuickMenuTitle ?? 'Menu Cepat Catat Untung',
                      style: const TextStyle(
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
                  title: Text(l10n?.dashMasterProducts ?? 'Master Produk'),
                  subtitle: Text(
                    l10n?.dashMasterProductsSubtitle ??
                        'Kelola daftar barang dagangan & HPP',
                  ),
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
                  title: Text(l10n?.dashSalesRecap ?? 'Rekap Penjualan'),
                  subtitle: Text(
                    l10n?.dashSalesRecapSubtitle ??
                        'Catat penjualan harian toko',
                  ),
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
                  title: Text(l10n?.dashHppCalculator ?? 'Kalkulator HPP'),
                  subtitle: Text(
                    l10n?.dashHppCalculatorSubtitle ??
                        'Hitung harga pokok & margin untung',
                  ),
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
                  title: Text(l10n?.dashExportReport ?? 'Ekspor Laporan'),
                  subtitle: Text(
                    l10n?.dashExportReportSubtitle ?? 'Unduh laporan PDF & CSV',
                  ),
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
                  title: Text(l10n?.dashSettings ?? 'Pengaturan'),
                  subtitle: Text(
                    l10n?.dashSettingsSubtitle ?? 'Setelan toko & cadangan data',
                  ),
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
