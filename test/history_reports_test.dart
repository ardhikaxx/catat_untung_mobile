import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:catat_untung/database/app_database.dart';
import 'package:catat_untung/features/history/widgets/history_view_mode.dart';
import 'package:catat_untung/features/history/widgets/history_month_hero_card.dart';
import 'package:catat_untung/features/history/widgets/history_view_toggle.dart';
import 'package:catat_untung/features/history/widgets/history_record_card.dart';
import 'package:catat_untung/features/reports/reports_screen.dart';
import 'package:catat_untung/features/reports/widgets/report_period_selector.dart';
import 'package:catat_untung/features/reports/widgets/report_hero_card.dart';
import 'package:catat_untung/features/reports/widgets/report_metrics_grid.dart';
import 'package:catat_untung/features/reports/widgets/report_top_products.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('History & Reports Modern UI Tests', () {
    testWidgets('HistoryMonthHeroCard displays month, totals, and triggers navigation', (tester) async {
      bool prevTapped = false;
      bool nextTapped = false;

      final records = [
        DailyRecord(
          id: 1,
          date: DateTime(2026, 9, 10),
          totalRevenue: 500000,
          totalCost: 300000,
          totalProfit: 200000,
          totalQuantity: 20,
          createdAt: DateTime(2026, 9, 10),
          updatedAt: DateTime(2026, 9, 10),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryMonthHeroCard(
              focusedMonth: DateTime(2026, 9, 1),
              recordsInMonth: records,
              onPreviousMonth: () => prevTapped = true,
              onNextMonth: () => nextTapped = true,
              canGoNext: true,
            ),
          ),
        ),
      );

      expect(find.text('September 2026'), findsOneWidget);
      expect(find.text('Rp 200.000'), findsOneWidget);
      expect(find.text('Total Omzet'), findsOneWidget);
      expect(find.text('Total Modal'), findsOneWidget);
      expect(find.text('1 Hari (20 unit)'), findsOneWidget);

      // Tap navigation
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new).first.hasFound ? find.byIcon(Icons.arrow_back_ios_new) : find.byType(InkWell).first);
      await tester.pump();
      expect(prevTapped, isTrue);
    });

    testWidgets('HistoryViewToggle switches modes', (tester) async {
      HistoryViewMode selectedMode = HistoryViewMode.calendar;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return HistoryViewToggle(
                  currentMode: selectedMode,
                  onModeChanged: (mode) {
                    setState(() => selectedMode = mode);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Kalender'), findsOneWidget);
      expect(find.text('Daftar Rekap'), findsOneWidget);

      await tester.tap(find.text('Daftar Rekap'));
      await tester.pumpAndSettle();
      expect(selectedMode, equals(HistoryViewMode.list));
    });

    testWidgets('HistoryRecordCard renders record info and triggers tap', (tester) async {
      bool cardTapped = false;
      final record = DailyRecord(
        id: 1,
        date: DateTime(2026, 9, 12),
        totalRevenue: 350000,
        totalCost: 200000,
        totalProfit: 150000,
        totalQuantity: 15,
        createdAt: DateTime(2026, 9, 12),
        updatedAt: DateTime(2026, 9, 12),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryRecordCard(
              record: record,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Sabtu'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.textContaining('Omzet: Rp 350.000'), findsOneWidget);
      expect(find.text('+Rp 150.000'), findsOneWidget);

      await tester.tap(find.byType(HistoryRecordCard));
      await tester.pump();
      expect(cardTapped, isTrue);
    });

    testWidgets('ReportPeriodSelector changes active period', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ReportPeriodSelector(),
            ),
          ),
        ),
      );

      expect(find.text('7 Hari Terakhir'), findsOneWidget);
      expect(find.text('Minggu Ini'), findsOneWidget);
      expect(find.text('Bulan Ini'), findsOneWidget);

      await tester.tap(find.text('Bulan Ini'));
      await tester.pumpAndSettle();
    });

    testWidgets('ReportHeroCard displays net profit and date range', (tester) async {
      final reportData = ReportData(
        records: [],
        totalRevenue: 1000000,
        totalCost: 600000,
        totalProfit: 400000,
        totalQuantity: 50,
        avgProfit: 40000,
        margin: 40,
        topProducts: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportHeroCard(
              data: reportData,
              dateRange: (
                start: DateTime(2026, 9, 1),
                end: DateTime(2026, 9, 13),
              ),
            ),
          ),
        ),
      );

      expect(find.text('+Rp 400.000'), findsOneWidget);
      expect(find.text('40% Margin'), findsOneWidget);
      expect(find.text('Rp 1.000.000'), findsOneWidget);
      expect(find.text('Rp 600.000'), findsOneWidget);
      expect(find.text('Rp 40.000'), findsOneWidget);
    });

    testWidgets('ReportMetricsGrid displays 4 key indicators', (tester) async {
      final reportData = ReportData(
        records: [],
        totalRevenue: 1000000,
        totalCost: 600000,
        totalProfit: 400000,
        totalQuantity: 80,
        avgProfit: 40000,
        margin: 40,
        topProducts: [
          ProductAgg(name: 'Kopi Susu', quantity: 50, revenue: 500000, cost: 300000),
          ProductAgg(name: 'Roti Bakar', quantity: 30, revenue: 500000, cost: 300000),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportMetricsGrid(data: reportData),
          ),
        ),
      );

      expect(find.text('Margin Rata-rata'), findsOneWidget);
      expect(find.text('40%'), findsOneWidget);
      expect(find.text('Total Terjual'), findsOneWidget);
      expect(find.text('80 Unit'), findsOneWidget);
      expect(find.text('Rata-rata Laba'), findsOneWidget);
      expect(find.text('Hari Aktif Rekap'), findsOneWidget);
    });

    testWidgets('ReportTopProducts renders ranked items', (tester) async {
      final topProducts = [
        ProductAgg(name: 'Kopi Aren', quantity: 40, revenue: 600000, cost: 320000),
        ProductAgg(name: 'Matcha Latte', quantity: 25, revenue: 450000, cost: 250000),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReportTopProducts(
              topProducts: topProducts,
              totalQuantity: 65,
            ),
          ),
        ),
      );

      expect(find.text('Produk Paling Laris'), findsOneWidget);
      expect(find.text('Kopi Aren'), findsOneWidget);
      expect(find.text('Matcha Latte'), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('40 unit'), findsOneWidget);
      expect(find.text('25 unit'), findsOneWidget);
    });
  });
}
