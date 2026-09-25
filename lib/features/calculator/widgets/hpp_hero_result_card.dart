import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/generated/app_localizations.dart';

class HppHeroResultCard extends StatelessWidget {
  final double hppPerUnit;
  final double totalBiaya;
  final int jumlahProduk;
  final double biayaBahan;
  final double biayaKemasan;
  final double biayaLain;

  const HppHeroResultCard({
    super.key,
    required this.hppPerUnit,
    required this.totalBiaya,
    required this.jumlahProduk,
    required this.biayaBahan,
    required this.biayaKemasan,
    required this.biayaLain,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasData = totalBiaya > 0 && jumlahProduk > 0;

    // Percentages of cost components
    final pctBahan = totalBiaya > 0 ? (biayaBahan / totalBiaya) : 0.0;
    final pctKemasan = totalBiaya > 0 ? (biayaKemasan / totalBiaya) : 0.0;
    final pctLain = totalBiaya > 0 ? (biayaLain / totalBiaya) : 0.0;

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
          // Header Badge
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
                  children: [
                    const Icon(
                      LucideIcons.calculator,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n?.calcAutoHppBadge ?? 'KALKULASI HPP OTOMATIS',
                      style: const TextStyle(
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
                      LucideIcons.checkCircle2,
                      size: 12,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n?.calcRealtimeBadge ?? 'Real-time',
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

          // Main KPI: HPP per unit
          Text(
            l10n?.calcHppHeading ?? 'HARGA POKOK PRODUKSI (HPP)',
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
                hasData
                    ? CurrencyFormatter.formatRupiah(hppPerUnit.round())
                    : 'Rp 0',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n?.calcPerUnitLabel ?? '/ unit produk',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(210),
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

          // Sub-metrics (Total Biaya, Hasil Jadi, Rata-rata)
          Row(
            children: [
              Expanded(
                child: _buildSubStat(
                  label: l10n?.calcTotalProductionCost ?? 'Total Biaya Produksi',
                  value: CurrencyFormatter.formatRupiah(totalBiaya.round()),
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
                    label: l10n?.calcTargetYieldTotal ?? 'Jumlah Target Jadi',
                    value: jumlahProduk > 0 ? '$jumlahProduk Unit' : '0 Unit',
                  ),
                ),
              ),
            ],
          ),

          // Proportional Cost Bar (if has data)
          if (hasData) ...[
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.white.withAlpha(35),
            ),
            const SizedBox(height: 12),

            Text(
              l10n?.calcCostCompositionHeading ?? 'Komposisi Beban Biaya Produksi',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white.withAlpha(190),
              ),
            ),
            const SizedBox(height: 6),

            // Segmented Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    if (pctBahan > 0)
                      Expanded(
                        flex: (pctBahan * 100).round().clamp(1, 100),
                        child: Container(color: Colors.white),
                      ),
                    if (pctKemasan > 0)
                      Expanded(
                        flex: (pctKemasan * 100).round().clamp(1, 100),
                        child: Container(color: const Color(0xFFFDE047)),
                      ),
                    if (pctLain > 0)
                      Expanded(
                        flex: (pctLain * 100).round().clamp(1, 100),
                        child: Container(color: const Color(0xFF93C5FD)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem(
                  color: Colors.white,
                  label: 'Bahan ${(pctBahan * 100).round()}%',
                ),
                _buildLegendItem(
                  color: const Color(0xFFFDE047),
                  label: 'Kemasan ${(pctKemasan * 100).round()}%',
                ),
                _buildLegendItem(
                  color: const Color(0xFF93C5FD),
                  label: 'Lain ${(pctLain * 100).round()}%',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withAlpha(180),
            fontWeight: FontWeight.w500,
          ),
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

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withAlpha(210),
          ),
        ),
      ],
    );
  }
}
