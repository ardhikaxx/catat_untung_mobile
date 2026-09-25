import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class DashboardActionBar extends StatelessWidget {
  final VoidCallback onRekap;
  final VoidCallback onRiwayat;
  final VoidCallback onProduk;
  final VoidCallback onKalkulator;

  const DashboardActionBar({
    super.key,
    required this.onRekap,
    required this.onRiwayat,
    required this.onProduk,
    required this.onKalkulator,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            icon: LucideIcons.send,
            label: l10n?.dashRekap ?? 'Rekap',
            onTap: onRekap,
          ),
          _ActionButton(
            icon: LucideIcons.arrowDownLeft,
            label: l10n?.dashRiwayat ?? 'Riwayat',
            onTap: onRiwayat,
          ),
          _ActionButton(
            icon: LucideIcons.package,
            label: l10n?.dashProduk ?? 'Produk',
            onTap: onProduk,
          ),
          _ActionButton(
            icon: LucideIcons.calculator,
            label: l10n?.dashHpp ?? 'HPP',
            onTap: onKalkulator,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.greyBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
