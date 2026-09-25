import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/app_logger.dart';
import '../features/about/about_screen.dart';
import '../features/backup/backup_screen.dart';
import '../features/calculator/hpp_calculator_screen.dart';
import '../features/daily_rekap/daily_rekap_screen.dart';
import '../features/export/export_screen.dart';
import '../features/guide/quick_guide_screen.dart';
import '../features/history/detail_rekap_screen.dart';
import '../features/history/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/products/product_form_screen.dart';
import '../features/products/products_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../l10n/generated/app_localizations.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    errorBuilder: (context, state) {
      AppLogger.record(
        'Router',
        'Halaman tidak ditemukan: ${state.uri}',
        StackTrace.empty,
      );
      return RouteErrorScreen(
        message: 'Halaman "${state.uri}" tidak ditemukan.',
        location: '/',
      );
    },
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
          final l10n = AppLocalizations.of(context);
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            AppLogger.record(
              'Router',
              'id produk tidak valid: ${state.pathParameters['id']}',
              StackTrace.empty,
            );
            return RouteErrorScreen(
              message: l10n?.routeInvalidProductId ?? 'ID produk tidak valid.',
              location: '/products',
            );
          }
          return ProductFormScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/daily-rekap',
        builder: (context, state) {
          final dateStr = state.uri.queryParameters['date'];
          final initialDate = dateStr != null ? DateTime.tryParse(dateStr) : null;
          return DailyRekapScreen(initialDate: initialDate);
        },
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

class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({
    super.key,
    required this.message,
    this.location,
  });

  final String message;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n?.routeNotFoundTitle ?? 'Ups, halaman tidak ditemukan',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.go(location ?? '/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(l10n?.routeBackToHome ?? 'Kembali ke Beranda'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
