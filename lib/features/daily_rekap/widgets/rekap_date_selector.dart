import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';

class RekapDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final ValueChanged<DateTime> onDateChanged;

  const RekapDateSelector({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onDateChanged,
  });

  bool get _isToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Hari Sebelumnya
          _NavArrowButton(
            icon: LucideIcons.chevronLeft,
            tooltip: 'Hari Sebelumnya',
            onTap: () {
              onDateChanged(
                selectedDate.subtract(const Duration(days: 1)),
              );
            },
          ),

          // Tombol Tanggal (Capsule Modern)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSelectDate,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F8EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.calendar,
                        size: 16,
                        color: Color(0xFF00AA13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('EEEE, d MMM yyyy', 'id_ID').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_isToday) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8EA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Hari Ini',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00AA13),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Tombol Hari Berikutnya (dinonaktifkan jika hari ini)
          _NavArrowButton(
            icon: LucideIcons.chevronRight,
            tooltip: 'Hari Berikutnya',
            onTap: _isToday
                ? null
                : () {
                    onDateChanged(
                      selectedDate.add(const Duration(days: 1)),
                    );
                  },
          ),
        ],
      ),
    );
  }
}

class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const _NavArrowButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : Colors.white.withAlpha(120),
              shape: BoxShape.circle,
              boxShadow: [
                if (isEnabled)
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Icon(
              icon,
              size: 18,
              color: isEnabled
                  ? const Color(0xFF1E293B)
                  : const Color(0xFF94A3B8).withAlpha(100),
            ),
          ),
        ),
      ),
    );
  }
}
