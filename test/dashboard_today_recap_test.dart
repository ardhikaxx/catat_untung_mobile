import 'package:catat_untung/database/app_database.dart';
import 'package:catat_untung/features/dashboard/dashboard_screen.dart';
import 'package:catat_untung/providers/daily_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: const MaterialApp(home: Scaffold(body: DashboardScreen())),
    );
  }

  testWidgets('kartu rekap hari ini: status belum rekap + tombol Isi Sekarang',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap([
      todayRecordProvider
          .overrideWith((ref) => Stream<DailyRecord?>.value(null)),
      allRecordsProvider.overrideWith((ref) => const Stream.empty()),
    ]));
    await tester.pump();

    expect(find.text('Rekap Hari Ini'), findsOneWidget);
    expect(find.text('Belum Rekap'), findsOneWidget);
    expect(find.text('Isi Sekarang'), findsOneWidget);
  });

  testWidgets('kartu rekap hari ini: ringkasan saat sudah rekap',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final now = DateTime.now();
    final record = DailyRecord(
      id: 1,
      date: now,
      totalRevenue: 50000,
      totalCost: 30000,
      totalProfit: 20000,
      totalQuantity: 4,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(wrap([
      todayRecordProvider.overrideWith((ref) => Stream.value(record)),
      allRecordsProvider.overrideWith((ref) => Stream.value([record])),
    ]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();

    expect(find.text('Rekap Hari Ini'), findsOneWidget);
    expect(find.text('Sudah Rekap'), findsOneWidget);
    expect(find.text('Rp 50.000'), findsWidgets); // Omzet (juga tampil di hero)
    expect(find.text('Rp 20.000'), findsWidgets); // Laba (juga di hero/chart)
    expect(find.text('4 item'), findsOneWidget);
  });
}
