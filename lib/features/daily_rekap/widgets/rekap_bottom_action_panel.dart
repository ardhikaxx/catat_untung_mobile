import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/generated/app_localizations.dart';

class RekapBottomActionPanel extends StatelessWidget {
  final int totalRevenue;
  final int totalCost;
  final int totalProfit;
  final int itemCount;
  final int totalQuantity;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onAddProduct;
  final double bottomPadding;

  const RekapBottomActionPanel({
    super.key,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.itemCount,
    required this.totalQuantity,
    required this.isLoading,
    required this.onSave,
    required this.onAddProduct,
    this.bottomPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isProfitPositive = totalProfit > 0;
    final isProfitZero = totalProfit == 0;
    final canSave = itemCount > 0 && !isLoading;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            // Quick Mini-Summary Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.rekapOmzetLabel ?? 'Omzet: ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatRupiah(totalRevenue),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        l10n?.rekapLabaLabel ?? 'Laba: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isProfitPositive
                              ? const Color(0xFF16A34A)
                              : (isProfitZero
                                  ? AppColors.textSecondary
                                  : const Color(0xFFDC2626)),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatRupiah(totalProfit),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isProfitPositive
                              ? const Color(0xFF16A34A)
                              : (isProfitZero
                                  ? AppColors.textPrimary
                                  : const Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                // Tambah Produk Button
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onAddProduct,
                      icon: const Icon(LucideIcons.plus, size: 18),
                      label: Text(
                        l10n?.commonAdd ?? 'Tambah',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00AA13),
                        backgroundColor: const Color(0xFFE8F8EA),
                        side: const BorderSide(
                          color: Color(0xFFB9F0C2),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Simpan Rekap Button
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: canSave ? onSave : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(LucideIcons.checkCircle2, size: 18),
                      label: Text(
                        isLoading
                            ? l10n?.rekapSaving ?? 'Menyimpan...'
                            : l10n?.rekapSaveRecap ?? 'Simpan Rekap',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AA13),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE5E5E5),
                        disabledForegroundColor: Colors.white70,
                        elevation: canSave ? 2 : 0,
                        shadowColor: const Color(0xFF00AA13).withAlpha(100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
