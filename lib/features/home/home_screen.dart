import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../dashboard/dashboard_screen.dart';
import '../daily_rekap/daily_rekap_screen.dart';
import '../history/history_screen.dart';
import '../reports/reports_screen.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          ref.read(currentTabProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home_2),
            selectedIcon: Icon(Iconsax.home_25),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.edit),
            selectedIcon: Icon(Iconsax.edit_25),
            label: 'Rekap',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.calendar),
            selectedIcon: Icon(Iconsax.calendar5),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.chart_21),
            selectedIcon: Icon(Iconsax.chart_25),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
