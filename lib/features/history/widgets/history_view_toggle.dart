import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'history_view_mode.dart';

class HistoryViewToggle extends StatelessWidget {
  final HistoryViewMode currentMode;
  final ValueChanged<HistoryViewMode> onModeChanged;

  const HistoryViewToggle({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleItem(
              mode: HistoryViewMode.calendar,
              title: 'Kalender',
              icon: LucideIcons.calendar,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildToggleItem(
              mode: HistoryViewMode.list,
              title: 'Daftar Rekap',
              icon: LucideIcons.receipt,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required HistoryViewMode mode,
    required String title,
    required IconData icon,
  }) {
    final isSelected = currentMode == mode;

    return GestureDetector(
      onTap: () => onModeChanged(mode),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
