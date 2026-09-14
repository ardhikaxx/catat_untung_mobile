import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/home_screen.dart';

class AppFloatingNavBar extends ConsumerWidget {
  /// Optional override of which tab is active. If null, uses [currentTabProvider].
  final int? activeIndex;

  const AppFloatingNavBar({super.key, this.activeIndex});

  static const double bottomSpacing = 110.0;

  static const _items = [
    _NavItem(icon: LucideIcons.home, activeIcon: LucideIcons.home, label: 'Beranda'),
    _NavItem(icon: LucideIcons.clipboardList, activeIcon: LucideIcons.clipboardList, label: 'Rekap'),
    _NavItem(icon: LucideIcons.calendar, activeIcon: LucideIcons.calendar, label: 'Riwayat'),
    _NavItem(icon: LucideIcons.barChart3, activeIcon: LucideIcons.barChart3, label: 'Laporan'),
    _NavItem(icon: LucideIcons.settings, activeIcon: LucideIcons.settings, label: 'Setelan'),
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
