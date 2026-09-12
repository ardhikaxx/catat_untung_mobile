import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/calculation_utils.dart';

class RekapLiveSummaryCard extends StatelessWidget {
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;
  final int itemCount;
  final int totalQuantity;

  const RekapLiveSummaryCard({
    super.key,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.itemCount,
    required this.totalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final margin = CalculationUtils.calculateMarginDouble(
      totalRevenue,
      totalCost,
    );
    final isProfitPositive = totalProfit > 0;
    final isProfitZero = totalProfit == 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5B2E91),
            Color(0xFF7B3FB9),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C4AB6).withAlpha(70),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Badge Live + Total Item Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ESTIMASI REKAP',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$itemCount Produk ($totalQuantity item)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Total Omzet
          const Text(
            'Total Estimasi Omzet',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE0E7FF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.formatRupiah(totalRevenue),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Bottom Bar: Modal & Laba Bersih
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Modal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.wallet_2,
                            size: 13,
                            color: Colors.white.withAlpha(180),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Total Modal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        CurrencyFormatter.formatRupiah(totalCost),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withAlpha(40),
                ),
                const SizedBox(width: 14),

                // Laba Bersih & Margin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            isProfitPositive
                                ? Iconsax.trend_up
                                : (isProfitZero ? Iconsax.minus : Iconsax.trend_down),
                            size: 13,
                            color: isProfitPositive
                                ? const Color(0xFF4ADE80)
                                : (isProfitZero ? Colors.white70 : const Color(0xFFF87171)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Laba Bersih',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.formatRupiah(totalProfit),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isProfitPositive
                                  ? const Color(0xFF4ADE80)
                                  : (isProfitZero ? Colors.white : const Color(0xFFF87171)),
                            ),
                          ),
                          if (totalRevenue > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: (isProfitPositive
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFDC2626))
                                    .withAlpha(80),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
