import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:catat_untung/features/dashboard/widgets/omzet_hero_card.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('OmzetHeroCard renders revenue, profit, total quantity, and triggers rekap tap', (tester) async {
    bool rekapTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OmzetHeroCard(
            totalRevenue: 3922000,
            totalProfit: 1250000,
            totalQuantity: 15,
            date: DateTime(2026, 9, 12),
            onRekapTap: () {
              rekapTapped = true;
            },
          ),
        ),
      ),
    );

    // Verify revenue is displayed
    expect(find.text('Total Omzet'), findsOneWidget);
    expect(find.text('Rp 3.922.000'), findsOneWidget);

    // Verify profit and total quantity are displayed
    expect(find.text('Laba Bersih'), findsOneWidget);
    expect(find.text('Total Terjual'), findsOneWidget);
    expect(find.text('15 Produk'), findsOneWidget);

    // Verify Rekap Baru button is present and tap works
    expect(find.text('Rekap Baru'), findsOneWidget);
    await tester.tap(find.text('Rekap Baru'));
    expect(rekapTapped, isTrue);
  });
}
