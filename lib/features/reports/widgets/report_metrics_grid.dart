import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../reports_screen.dart';

class ReportMetricsGrid extends StatelessWidget {
  final ReportData data;

  const ReportMetricsGrid({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              // 1. Margin
              Expanded(
                child: _buildMetricTile(
                  icon: Iconsax.percentage_circle,
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFDCFCE7),
                  label: 'Margin Rata-rata',
                  value: '${data.margin}%',
                  subtitle: data.margin >= 30
                      ? 'Margin Sehat'
                      : data.margin > 0
                          ? 'Perlu Ditingkatkan'
                          : 'Rugi',
                  subtitleColor: data.margin >= 30
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFEA580C),
                ),
              ),
              const SizedBox(width: 10),
              // 2. Volume Sold
              Expanded(
                child: _buildMetricTile(
                  icon: Iconsax.box,
                  iconColor: const Color(0xFF6C4AB6),
                  iconBg: const Color(0xFFF3E8FF),
                  label: 'Total Terjual',
                  value: '${data.totalQuantity} Unit',
                  subtitle: '${data.topProducts.length} Variasi Produk',
                  subtitleColor: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // 3. Rata-rata laba per hari
              Expanded(
                child: _buildMetricTile(
                  icon: Iconsax.calendar_tick,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFDBEAFE),
                  label: 'Rata-rata Laba',
                  value: CurrencyFormatter.formatRupiah(data.avgProfit),
                  subtitle: 'Per hari jualan',
                  subtitleColor: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 10),
              // 4. Hari Aktif
              Expanded(
                child: _buildMetricTile(
                  icon: Iconsax.chart_success,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFFEF3C7),
                  label: 'Hari Aktif Rekap',
                  value: '${data.records.length} Hari',
                  subtitle: 'Tercatat di sistem',
                  subtitleColor: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required String subtitle,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
