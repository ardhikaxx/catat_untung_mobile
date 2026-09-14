import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';

enum ProfitStatus { untung, rugi, impas }

class ProfitIndicator extends StatelessWidget {
  final int amount;
  final bool showLabel;
  final TextStyle? style;

  const ProfitIndicator({
    super.key,
    required this.amount,
    this.showLabel = true,
    this.style,
  });

  ProfitStatus get status {
    if (amount > 0) return ProfitStatus.untung;
    if (amount < 0) return ProfitStatus.rugi;
    return ProfitStatus.impas;
  }

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ProfitStatus.untung => AppColors.profit,
      ProfitStatus.rugi => AppColors.loss,
      ProfitStatus.impas => AppColors.breakEven,
    };

    final icon = switch (status) {
      ProfitStatus.untung => LucideIcons.arrowUp,
      ProfitStatus.rugi => LucideIcons.arrowDown,
      ProfitStatus.impas => LucideIcons.minus,
    };

    final label = switch (status) {
      ProfitStatus.untung => 'Untung',
      ProfitStatus.rugi => 'Rugi',
      ProfitStatus.impas => 'Impas',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            showLabel ? '$label • ${CurrencyFormatter.formatRupiah(amount.abs())}' : CurrencyFormatter.formatRupiah(amount),
            style: (style ?? const TextStyle()).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
