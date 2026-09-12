import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../daily_rekap/daily_rekap_screen.dart';
import '../history/history_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    DailyRekapScreen(),
    HistoryScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  final _items = const [
    _NavItem(icon: Iconsax.home_2, activeIcon: Iconsax.home_2, label: 'Beranda'),
    _NavItem(icon: Iconsax.note_1, activeIcon: Iconsax.note_1, label: 'Rekap'),
    _NavItem(icon: Iconsax.calendar, activeIcon: Iconsax.calendar, label: 'Riwayat'),
    _NavItem(icon: Iconsax.chart, activeIcon: Iconsax.chart, label: 'Laporan'),
    _NavItem(icon: Iconsax.setting, activeIcon: Iconsax.setting, label: 'Setelan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = _currentIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = index);
                  ref.read(currentTabProvider.notifier).state = index;
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryGreen.withAlpha(25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color: isActive
                            ? AppColors.primaryGreen
                            : AppColors.textSecondary,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
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
