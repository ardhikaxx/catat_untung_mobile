import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../database/app_database.dart';

class ProductHeroCard extends StatelessWidget {
  final List<Product> allProducts;

  const ProductHeroCard({
    super.key,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = allProducts.length;
    final activeCount = allProducts.where((p) => p.isActive).length;
    final inactiveCount = totalCount - activeCount;

    // Calculate average margin of active products where selling price > 0
    final activeWithPrice = allProducts
        .where((p) => p.isActive && p.sellingPrice > 0)
        .toList();

    double avgMargin = 0;
    if (activeWithPrice.isNotEmpty) {
      final totalMarginPercent = activeWithPrice.fold<double>(
        0.0,
        (sum, p) => sum + (((p.sellingPrice - p.hpp) / p.sellingPrice) * 100),
      );
      avgMargin = totalMarginPercent / activeWithPrice.length;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreenDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withAlpha(50),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Iconsax.box,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'KATALOG MASTER PRODUK',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.trend_up,
                      size: 12,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Avg ${avgMargin.toStringAsFixed(0)}% Margin',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Total Products Hero Stat
          Text(
            'TOTAL DAFTAR PRODUK',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Colors.white.withAlpha(190),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$totalCount',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Barang Dagangan Terdaftar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withAlpha(35),
          ),
          const SizedBox(height: 14),

          // 3 Sub-stat columns
          Row(
            children: [
              Expanded(
                child: _buildSubStat(
                  label: 'Produk Aktif',
                  value: '$activeCount Item',
                  icon: Iconsax.tick_circle,
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(35),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildSubStat(
                    label: 'Nonaktif',
                    value: '$inactiveCount Item',
                    icon: Iconsax.minus_cirlce,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(35),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildSubStat(
                    label: 'Siap Jual',
                    value: '${totalCount > 0 ? ((activeCount / totalCount) * 100).round() : 0}%',
                    icon: Iconsax.bag_tick,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white.withAlpha(180)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white.withAlpha(180),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
