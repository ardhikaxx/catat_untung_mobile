import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class ProductLivePreviewCard extends StatelessWidget {
  final String productName;
  final int hpp;
  final int sellingPrice;
  final String unit;

  const ProductLivePreviewCard({
    super.key,
    required this.productName,
    required this.hpp,
    required this.sellingPrice,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final profit = sellingPrice - hpp;
    final isProfit = profit >= 0;
    final hasData = sellingPrice > 0 || hpp > 0;
    final marginPercent = sellingPrice > 0
        ? ((profit / sellingPrice) * 100).toStringAsFixed(0)
        : '0';
    final marginDouble = sellingPrice > 0 ? (profit / sellingPrice) * 100 : 0.0;

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (!hasData) {
      statusColor = AppColors.textSecondary;
      statusLabel = 'Simulasi keuntungan akan muncul otomatis saat Anda mengisi modal & harga jual.';
      statusIcon = LucideIcons.info;
    } else if (sellingPrice > 0 && profit < 0) {
      statusColor = AppColors.loss;
      statusLabel = 'Harga jual di bawah modal! Penjualan produk ini akan mengalami rugi.';
      statusIcon = LucideIcons.alertTriangle;
    } else if (marginDouble >= 30) {
      statusColor = AppColors.profit;
      statusLabel = 'Margin sangat sehat (≥ 30%). Bagus untuk ketahanan usaha dan promo.';
      statusIcon = LucideIcons.checkCircle2;
    } else {
      statusColor = const Color(0xFFD97706);
      statusLabel = 'Margin cukup tipis (< 30%). Perhatikan biaya operasional lainnya.';
      statusIcon = LucideIcons.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.greenTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.barChart3,
                      size: 16,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Simulasi Laba per Unit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (hasData)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isProfit
                        ? AppColors.greenTint
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$marginPercent% Margin',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isProfit ? AppColors.profit : AppColors.loss,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Profit Metric
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName.trim().isEmpty
                        ? 'Nama Produk Belum Diisi'
                        : '${productName.trim()} / $unit',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasData
                        ? '${isProfit ? '+' : ''}${CurrencyFormatter.formatRupiah(profit)}'
                        : 'Rp 0',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: hasData
                          ? (isProfit ? AppColors.profit : AppColors.loss)
                          : AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Text(
                'Laba Bersih / $unit',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Breakdown pills
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.greyBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSubItem('Modal (HPP)', CurrencyFormatter.formatRupiah(hpp)),
                Container(width: 1, height: 20, color: AppColors.greyBorder),
                _buildSubItem('Harga Jual', CurrencyFormatter.formatRupiah(sellingPrice)),
                Container(width: 1, height: 20, color: AppColors.greyBorder),
                _buildSubItem('Satuan', unit),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Advice notice
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(statusIcon, size: 15, color: statusColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
