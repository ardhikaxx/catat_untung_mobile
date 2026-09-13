import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/calculation_utils.dart';
import '../../../database/app_database.dart';

class RekapSavedView extends StatelessWidget {
  final DailyRecord record;
  final List<DailyRecordItem> items;
  final DateTime selectedDate;
  final VoidCallback onEditRekap;
  final VoidCallback onViewHistory;
  final double bottomPadding;

  const RekapSavedView({
    super.key,
    required this.record,
    required this.items,
    required this.selectedDate,
    required this.onEditRekap,
    required this.onViewHistory,
    this.bottomPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final margin = CalculationUtils.calculateMarginDouble(
      record.totalRevenue,
      record.totalCost,
    );
    final isProfitPositive = record.totalProfit > 0;
    final isProfitZero = record.totalProfit == 0;

    return Column(
      children: [
        // Scrollable content (Status, KPI Card, and Item List)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            children: [
              // 1. Success Status Capsule
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.tick_circle5,
                      size: 20,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rekap Sudah Tersimpan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15803D),
                            ),
                          ),
                          Text(
                            'Pembaruan: ${DateFormat('d MMMM yyyy • HH:mm', 'id_ID').format(record.updatedAt)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Saved Hero KPI Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                                .format(selectedDate),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${record.totalQuantity} Item Terjual',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Total Omzet',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE0E7FF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.formatRupiah(record.totalRevenue),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
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
                                  CurrencyFormatter.formatRupiah(
                                      record.totalCost),
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

                          // Laba Bersih
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
                                          : (isProfitZero
                                              ? Iconsax.minus
                                              : Iconsax.trend_down),
                                      size: 13,
                                      color: isProfitPositive
                                          ? const Color(0xFF4ADE80)
                                          : (isProfitZero
                                              ? Colors.white70
                                              : const Color(0xFFF87171)),
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
                                      CurrencyFormatter.formatRupiah(
                                          record.totalProfit),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: isProfitPositive
                                            ? const Color(0xFF4ADE80)
                                            : (isProfitZero
                                                ? Colors.white
                                                : const Color(0xFFF87171)),
                                      ),
                                    ),
                                    if (record.totalRevenue > 0) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (isProfitPositive
                                                  ? const Color(0xFF16A34A)
                                                  : const Color(0xFFDC2626))
                                              .withAlpha(80),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
              ),

              const SizedBox(height: 16),

              // 3. Section Title: Rincian Produk
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rincian Produk Terjual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${items.length} Menu',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Item Cards List
              ...items.map((item) {
                final isItemProfitPositive = item.subtotalProfit > 0;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Iconsax.box_1,
                          size: 20,
                          color: Color(0xFF6C4AB6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productNameSnapshot,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.quantity} ${item.unitSnapshot} × ${CurrencyFormatter.formatRupiah(item.sellingPriceSnapshot)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.formatRupiah(
                                item.subtotalRevenue),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Laba: ${CurrencyFormatter.formatRupiah(item.subtotalProfit)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isItemProfitPositive
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        // 4. Action Buttons (Docked right above navbottom!)
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 14,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onEditRekap,
                  icon: const Icon(Iconsax.edit_2, size: 18),
                  label: const Text(
                    'Ubah / Tambah Rekap Ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4AB6),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0xFF6C4AB6).withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: onViewHistory,
                  icon: const Icon(Iconsax.calendar_1, size: 18),
                  label: const Text(
                    'Buka Riwayat Penjualan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
