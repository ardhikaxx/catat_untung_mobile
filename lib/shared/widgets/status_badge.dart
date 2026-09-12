import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum BadgeType { profit, loss, breakEven, info, warning }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (type) {
      BadgeType.profit => (AppColors.profit, AppColors.profit.withAlpha(25)),
      BadgeType.loss => (AppColors.loss, AppColors.loss.withAlpha(25)),
      BadgeType.breakEven => (AppColors.breakEven, AppColors.breakEven.withAlpha(25)),
      BadgeType.info => (AppColors.info, AppColors.info.withAlpha(25)),
      BadgeType.warning => (AppColors.warning, AppColors.warning.withAlpha(25)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
