import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/home_screen.dart';

class AppFloatingNavBar extends ConsumerWidget {
  /// Optional override of which tab is active. If null, uses [currentTabProvider].
  final int? activeIndex;

  const AppFloatingNavBar({super.key, this.activeIndex});

  static const double bottomSpacing = 110.0;

  static const _items = [
    _NavItem(icon: Iconsax.home_2, activeIcon: Iconsax.home_2, label: 'Beranda'),
    _NavItem(icon: Iconsax.note_1, activeIcon: Iconsax.note_1, label: 'Rekap'),
    _NavItem(icon: Iconsax.calendar, activeIcon: Iconsax.calendar, label: 'Riwayat'),
    _NavItem(icon: Iconsax.chart_21, activeIcon: Iconsax.chart_21, label: 'Laporan'),
    _NavItem(icon: Iconsax.setting_2, activeIcon: Iconsax.setting_2, label: 'Setelan'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-hide floating navbar when virtual keyboard is visible
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      return const SizedBox.shrink();
    }

    final currentIndex = activeIndex ?? ref.watch(currentTabProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isActive = currentIndex == index;

            return GestureDetector(
              onTap: () {
                ref.read(currentTabProvider.notifier).state = index;
                final isRoot = ModalRoute.of(context)?.isFirst ?? true;
                if (!isRoot) {
                  context.go('/');
                }
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 14 : 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      size: 20,
                      color: isActive
                          ? Colors.white
                          : const Color(0xFF808080),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
