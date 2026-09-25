import 'package:catat_untung/features/settings/settings_screen.dart';
import 'package:catat_untung/providers/app_locale_provider.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    // Each test mounts its own ProviderScope (own AppDatabase instance).
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('language tile opens dialog, switches to English, and persists', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Default: follow system
    expect(find.text('Bahasa Tampilan'), findsOneWidget);
    expect(find.text('Ikuti sistem'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);

    // Open the language dialog
    await tester.tap(find.text('Bahasa Tampilan'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Bahasa'), findsOneWidget);
    expect(find.text('Ikuti Sistem'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Pick English
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Dialog closed, tile updated, provider + preference persisted
    expect(find.text('Pilih Bahasa'), findsNothing);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    expect(container.read(appLocaleProvider), const Locale('en'));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(kLocalePrefKey), 'en');
  });

  testWidgets('switching back to system clears the locale override', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(appLocaleProvider.notifier).state = const Locale('en');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);

    await tester.tap(find.text('Bahasa Tampilan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ikuti Sistem'));
    await tester.pumpAndSettle();

    expect(container.read(appLocaleProvider), isNull);
    expect(find.text('Ikuti sistem'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(kLocalePrefKey), 'system');
  });
}
