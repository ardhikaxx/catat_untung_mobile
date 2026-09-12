import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/database_provider.dart';
import '../../providers/daily_record_provider.dart';
import '../../database/app_database.dart';

class DetailRekapScreen extends ConsumerWidget {
  final String dateStr;

  const DetailRekapScreen({super.key, required this.dateStr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateTime.parse(dateStr);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final recordAsync = ref.watch(recordByDateProvider(dateOnly));

    return recordAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        body: Center(child: Text('Gagal memuat data: $e')),
      ),
      data: (record) {
        if (record == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Detail Rekap'),
            ),
            body: const Center(child: Text('Data tidak ditemukan')),
          );
        }

        final itemsAsync = ref.watch(itemsByRecordIdProvider(record.id));

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(DateFormatter.formatFull(dateOnly)),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.edit_2),
                onPressed: () => context.push('/daily-rekap'),
              ),
              IconButton(
                icon: const Icon(Iconsax.trash),
                onPressed: () => _showDeleteDialog(context, ref, record),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatusBadge(record),
              const SizedBox(height: 16),
              _buildSummaryCards(record),
              const SizedBox(height: 16),
              const Text(
                'Detail Produk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              itemsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Text('Gagal memuat item'),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada item'),
                    );
                  }

                  return Column(
                    children: items.map((item) {
                      final profit = item.subtotalRevenue - item.subtotalCost;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.productNameSnapshot,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity} ${item.unitSnapshot}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _DetailItem(
                                    label: 'HPP/Unit',
                                    value: CurrencyFormatter.formatRupiah(item.hppSnapshot),
                                  ),
                                  const SizedBox(width: 12),
                                  _DetailItem(
                                    label: 'Jual/Unit',
                                    value: CurrencyFormatter.formatRupiah(item.sellingPriceSnapshot),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _DetailItem(
                                    label: 'Omzet',
                                    value: CurrencyFormatter.formatRupiah(item.subtotalRevenue),
                                  ),
                                  const SizedBox(width: 12),
                                  _DetailItem(
                                    label: 'Laba',
                                    value: CurrencyFormatter.formatRupiah(profit),
                                    color: profit >= 0 ? AppColors.profit : AppColors.loss,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(DailyRecord record) {
    final profit = record.totalProfit;
    final status = profit > 0 ? 'Untung' : profit < 0 ? 'Rugi' : 'Impas';
    final color = profit > 0
        ? AppColors.profit
        : profit < 0
            ? AppColors.loss
            : AppColors.breakEven;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            profit > 0
                ? Iconsax.arrow_up_3
                : profit < 0
                    ? Iconsax.arrow_down3
                    : Iconsax.minus,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                CurrencyFormatter.formatRupiah(profit.abs()),
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(DailyRecord record) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Omzet',
            value: CurrencyFormatter.formatRupiah(record.totalRevenue),
            icon: Iconsax.wallet_3,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: 'Modal',
            value: CurrencyFormatter.formatRupiah(record.totalCost),
            icon: Iconsax.bag,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: 'Unit',
            value: '${record.totalQuantity}',
            icon: Iconsax.box,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, DailyRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Rekap?'),
        content: const Text(
          'Semua data rekap pada tanggal ini akan dihapus. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(dailyRecordRepositoryProvider)
                  .deleteDailyRecord(record.id);
              ref.invalidate(allRecordsProvider);
              ref.invalidate(todayRecordProvider);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rekap dihapus')),
                );
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
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
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _DetailItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
