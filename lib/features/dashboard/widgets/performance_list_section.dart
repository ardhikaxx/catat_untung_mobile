import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../database/app_database.dart';

class PerformanceListSection extends StatelessWidget {
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;
  final int totalQuantity;
  final List<DailyRecordItem> todayItems;
  final VoidCallback onViewAll;

  const PerformanceListSection({
    super.key,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.totalQuantity,
    required this.todayItems,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedTimeDate = '${DateFormatter.formatShort(now)} • Hari Ini';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Performa Hari Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Container holding items
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          child: Column(
            children: [
              // 1. Total Modal (HPP)
              _PerformanceTile(
                icon: Iconsax.bag_2,
                iconBgColor: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
                title: 'Total Modal (HPP)',
                subtitle: 'Biaya pokok penjualan • $formattedTimeDate',
                amount: CurrencyFormatter.formatRupiah(totalCost),
                amountColor: AppColors.textPrimary,
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // 2. Laba Bersih
              _PerformanceTile(
                icon: totalProfit >= 0 ? Iconsax.arrow_up_3 : Iconsax.arrow_down3,
                iconBgColor: totalProfit >= 0
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFFEE2E2),
                iconColor: totalProfit >= 0
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
                title: 'Laba Bersih',
                subtitle: totalProfit >= 0
                    ? 'Keuntungan bersih • $formattedTimeDate'
                    : 'Defisit usaha • $formattedTimeDate',
                amount: totalProfit >= 0
                    ? '+${CurrencyFormatter.formatRupiah(totalProfit)}'
                    : CurrencyFormatter.formatRupiah(totalProfit),
                amountColor: totalProfit >= 0
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // 3. Unit Terjual
              _PerformanceTile(
                icon: Iconsax.box_1,
                iconBgColor: const Color(0xFFDBEAFE),
                iconColor: const Color(0xFF2563EB),
                title: 'Unit Terjual',
                subtitle: 'Total kuantitas barang • $formattedTimeDate',
                amount: '$totalQuantity unit',
                amountColor: AppColors.textPrimary,
              ),

              // If there are sold product items today, show up to 3 of them
              if (todayItems.isNotEmpty) ...[
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ...todayItems.take(3).map((item) {
                  return Column(
                    children: [
                      _PerformanceTile(
                        icon: Iconsax.receipt_item,
                        iconBgColor: const Color(0xFFF3E8FF),
                        iconColor: const Color(0xFF7C3AED),
                        title: item.productNameSnapshot,
                        subtitle:
                            '${item.quantity} ${item.unitSnapshot} x ${CurrencyFormatter.formatRupiahCompact(item.sellingPriceSnapshot)}',
                        amount: CurrencyFormatter.formatRupiah(
                          item.subtotalRevenue,
                        ),
                        amountColor: AppColors.textPrimary,
                      ),
                      if (item != todayItems.take(3).last)
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ],
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;

  const _PerformanceTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
