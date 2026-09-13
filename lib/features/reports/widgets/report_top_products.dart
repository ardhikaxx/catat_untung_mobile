import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../reports_screen.dart';

class ReportTopProducts extends StatelessWidget {
  final List<ProductAgg> topProducts;
  final int totalQuantity;

  const ReportTopProducts({
    super.key,
    required this.topProducts,
    required this.totalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    if (topProducts.isEmpty) return const SizedBox.shrink();

    final displayedProducts = topProducts.take(10).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.cup,
                      size: 16,
                      color: Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Produk Paling Laris',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Peringkat penjualan & kontribusi laba',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${topProducts.length} Produk',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Product List
          ...displayedProducts.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            final rank = index + 1;
            final percentage = totalQuantity > 0
                ? (product.quantity / totalQuantity).clamp(0.0, 1.0)
                : 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Rank Badge
                      _buildRankBadge(rank),
                      const SizedBox(width: 12),

                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Omzet: ${CurrencyFormatter.formatRupiah(product.revenue)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Sold Quantity & Profit
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E7FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product.quantity} unit',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4338CA),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+${CurrencyFormatter.formatRupiah(product.profit)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Progress bar share of units
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        rank == 1
                            ? const Color(0xFFD97706)
                            : rank == 2
                                ? const Color(0xFF6C4AB6)
                                : const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color bg;
    Color text;

    if (rank == 1) {
      bg = const Color(0xFFFEF3C7);
      text = const Color(0xFFD97706);
    } else if (rank == 2) {
      bg = const Color(0xFFE2E8F0);
      text = const Color(0xFF475569);
    } else if (rank == 3) {
      bg = const Color(0xFFFFEDD5);
      text = const Color(0xFFEA580C);
    } else {
      bg = const Color(0xFFF1F5F9);
      text = const Color(0xFF94A3B8);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: text,
          ),
        ),
      ),
    );
  }
}
