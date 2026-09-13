import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/products/products_screen.dart';
import '../features/products/product_form_screen.dart';
import '../features/daily_rekap/daily_rekap_screen.dart';
import '../features/history/history_screen.dart';
import '../features/history/detail_rekap_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/export/export_screen.dart';
import '../features/backup/backup_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/calculator/hpp_calculator_screen.dart';
import '../features/guide/quick_guide_screen.dart';
import '../features/about/about_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/products/add',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProductFormScreen(
            initialHpp: extra?['initialHpp'] as double?,
            initialSellingPrice: extra?['initialSellingPrice'] as double?,
          );
        },
      ),
      GoRoute(
        path: '/products/edit/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductFormScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/daily-rekap',
        builder: (context, state) => const DailyRekapScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/detail-rekap/:date',
        builder: (context, state) {
          final date = state.pathParameters['date']!;
          return DetailRekapScreen(dateStr: date);
        },
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/export',
        builder: (context, state) => const ExportScreen(),
      ),
      GoRoute(
        path: '/backup',
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/calculator',
        builder: (context, state) => const HppCalculatorScreen(),
      ),
      GoRoute(
        path: '/guide',
        builder: (context, state) => const QuickGuideScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
