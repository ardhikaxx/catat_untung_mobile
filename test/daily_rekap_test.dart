import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:catat_untung/features/daily_rekap/daily_rekap_screen.dart';
import 'package:catat_untung/features/daily_rekap/widgets/rekap_date_selector.dart';
import 'package:catat_untung/features/daily_rekap/widgets/rekap_live_summary_card.dart';
import 'package:catat_untung/features/daily_rekap/widgets/rekap_item_tile.dart';
import 'package:catat_untung/features/daily_rekap/widgets/rekap_bottom_action_panel.dart';
import 'package:catat_untung/features/daily_rekap/widgets/rekap_saved_view.dart';
import 'package:catat_untung/database/app_database.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('Daily Rekap Widgets Tests', () {
    testWidgets('RekapDateSelector renders date and handles navigation', (tester) async {
      DateTime selected = DateTime(2026, 9, 10);
      bool selectDateTapped = false;
      DateTime? changedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RekapDateSelector(
              selectedDate: selected,
              onSelectDate: () {
                selectDateTapped = true;
              },
              onDateChanged: (d) {
                changedDate = d;
              },
            ),
          ),
        ),
      );

      // Verify date is formatted and shown
      expect(find.textContaining('10 Sep 2026'), findsOneWidget);

      // Tap date capsule
      await tester.tap(find.textContaining('10 Sep 2026'));
      await tester.pump();
      expect(selectDateTapped, isTrue);

      // Tap previous day button (left arrow)
      await tester.tap(find.byTooltip('Hari Sebelumnya'));
      await tester.pump();
      expect(changedDate, equals(DateTime(2026, 9, 9)));
    });

    testWidgets('RekapLiveSummaryCard displays revenue, modal, and profit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RekapLiveSummaryCard(
              totalRevenue: 250000,
              totalCost: 150000,
              totalProfit: 100000,
              itemCount: 2,
              totalQuantity: 10,
            ),
          ),
        ),
      );

      expect(find.text('ESTIMASI REKAP'), findsOneWidget);
      expect(find.text('Rp 250.000'), findsOneWidget);
      expect(find.text('Total Modal'), findsOneWidget);
      expect(find.text('Rp 150.000'), findsOneWidget);
      expect(find.text('Laba Bersih'), findsOneWidget);
      expect(find.text('Rp 100.000'), findsOneWidget);
      expect(find.text('2 Produk (10 item)'), findsOneWidget);
    });

    testWidgets('RekapItemTile stepper increments and decrements quantity', (tester) async {
      final item = RekapItem(
        productId: 1,
        productName: 'Kopi Susu',
        unit: 'cup',
        hpp: 8000,
        sellingPrice: 15000,
        quantity: 3,
      );

      int? updatedQty;
      bool removed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RekapItemTile(
              item: item,
              index: 0,
              onQuantityChanged: (qty) => updatedQty = qty,
              onPriceChanged: (p) {},
              onRemove: () => removed = true,
            ),
          ),
        ),
      );

      expect(find.text('Kopi Susu'), findsOneWidget);
      expect(find.text('cup'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Tap plus button
      await tester.tap(find.byKey(const Key('btn_step_plus')));
      await tester.pump();
      expect(updatedQty, equals(4));

      // Tap trash / remove button
      await tester.tap(find.byTooltip('Hapus Item'));
      await tester.pump();
      expect(removed, isTrue);
    });

    testWidgets('RekapBottomActionPanel renders totals and triggers actions', (tester) async {
      bool addTapped = false;
      bool saveTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RekapBottomActionPanel(
              totalRevenue: 300000,
              totalCost: 180000,
              totalProfit: 120000,
              itemCount: 2,
              totalQuantity: 8,
              isLoading: false,
              onSave: () => saveTapped = true,
              onAddProduct: () => addTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Rp 300.000'), findsOneWidget);
      expect(find.text('Rp 120.000'), findsOneWidget);

      await tester.tap(find.text('Tambah'));
      await tester.pump();
      expect(addTapped, isTrue);

      await tester.tap(find.text('Simpan Rekap'));
      await tester.pump();
      expect(saveTapped, isTrue);
    });

    testWidgets('RekapSavedView renders KPI, items, and docked action buttons', (tester) async {
      bool editTapped = false;
      bool historyTapped = false;

      final record = DailyRecord(
        id: 1,
        date: DateTime(2026, 9, 12),
        totalRevenue: 500000,
        totalCost: 300000,
        totalProfit: 200000,
        totalQuantity: 10,
        createdAt: DateTime(2026, 9, 12, 10, 0),
        updatedAt: DateTime(2026, 9, 12, 18, 30),
      );

      final items = [
        DailyRecordItem(
          id: 1,
          dailyRecordId: 1,
          productId: 101,
          productNameSnapshot: 'Kopi Susu Gula Aren',
          unitSnapshot: 'cup',
          hppSnapshot: 8000,
          sellingPriceSnapshot: 15000,
          quantity: 10,
          subtotalRevenue: 150000,
          subtotalCost: 80000,
          subtotalProfit: 70000,
          createdAt: DateTime(2026, 9, 12),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RekapSavedView(
              record: record,
              items: items,
              selectedDate: DateTime(2026, 9, 12),
              onEditRekap: () => editTapped = true,
              onViewHistory: () => historyTapped = true,
              bottomSpacing: 100.0,
            ),
          ),
        ),
      );

      expect(find.text('Rekap Sudah Tersimpan'), findsOneWidget);
      expect(find.text('Rp 500.000'), findsOneWidget);
      expect(find.text('Kopi Susu Gula Aren'), findsOneWidget);
      expect(find.text('Ubah / Tambah Rekap Ini'), findsOneWidget);
      expect(find.text('Buka Riwayat Penjualan'), findsOneWidget);

      await tester.tap(find.text('Ubah / Tambah Rekap Ini'));
      await tester.pump();
      expect(editTapped, isTrue);

      await tester.tap(find.text('Buka Riwayat Penjualan'));
      await tester.pump();
      expect(historyTapped, isTrue);
    });
  });
}
