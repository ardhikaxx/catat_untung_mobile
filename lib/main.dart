import 'dart:async';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/app_locale_provider.dart';
import 'routing/app_router.dart';

void main() {
  // Binding init and runApp must run in the SAME zone (runZonedGuarded's
  // zone), otherwise Flutter's debug zone check throws a "Zone mismatch".
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        AppLogger.record('FlutterError', details.exception, details.stack);
        FlutterError.presentError(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.report('Uncaught', error, stack);
        return true;
      };

      await initializeDateFormatting('id_ID', null);
      final savedLocale = await loadAppLocale();
      runApp(
        ProviderScope(
          overrides: [
            appLocaleProvider.overrideWith((ref) => savedLocale),
          ],
          child: const CatatUntungApp(),
        ),
      );
    },
    (error, stack) {
      AppLogger.report('ZoneError', error, stack);
    },
  );
}

class CatatUntungApp extends ConsumerWidget {
  const CatatUntungApp({super.key});

  /// Indonesian first: unsupported device locales fall back to Indonesian.
  static const _supportedLocales = [Locale('id'), Locale('en')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'Catat Untung',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      locale: locale,
      supportedLocales: _supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
