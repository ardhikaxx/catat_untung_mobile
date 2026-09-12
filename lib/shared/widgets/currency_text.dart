import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/theme/app_colors.dart';

class CurrencyText extends StatelessWidget {
  final int amount;
  final TextStyle? style;
  final bool showSign;
  final bool compact;

  const CurrencyText({
    super.key,
    required this.amount,
    this.style,
    this.showSign = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = compact
        ? CurrencyFormatter.formatRupiahCompact(amount)
        : CurrencyFormatter.formatRupiah(amount);
    final displayText = showSign ? CurrencyFormatter.formatWithSign(amount) : text;

    Color? color;
    if (showSign) {
      if (amount > 0) {
        color = AppColors.profit;
      } else if (amount < 0) {
        color = AppColors.loss;
      }
    }

    return Text(
      displayText,
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}
