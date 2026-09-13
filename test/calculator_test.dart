import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catat_untung/features/calculator/widgets/hpp_hero_result_card.dart';
import 'package:catat_untung/features/calculator/widgets/hpp_target_margin_card.dart';

void main() {
  group('HPP Calculator Widgets Tests', () {
    testWidgets('HppHeroResultCard renders zero state properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HppHeroResultCard(
              hppPerUnit: 0,
              totalBiaya: 0,
              jumlahProduk: 0,
              biayaBahan: 0,
              biayaKemasan: 0,
              biayaLain: 0,
            ),
          ),
        ),
      );

      expect(find.text('KALKULASI HPP OTOMATIS'), findsOneWidget);
      expect(find.text('HARGA POKOK PRODUKSI (HPP)'), findsOneWidget);
      expect(find.text('Rp 0'), findsNWidgets(2)); // HPP and Total Biaya
      expect(find.text('0 Unit'), findsOneWidget);
    });

    testWidgets('HppHeroResultCard renders calculation results and composition bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HppHeroResultCard(
              hppPerUnit: 10000,
              totalBiaya: 300000,
              jumlahProduk: 30,
              biayaBahan: 210000,
              biayaKemasan: 60000,
              biayaLain: 30000,
            ),
          ),
        ),
      );

      expect(find.text('Rp 10.000'), findsOneWidget);
      expect(find.text('Rp 300.000'), findsOneWidget);
      expect(find.text('30 Unit'), findsOneWidget);
      expect(find.text('Komposisi Beban Biaya Produksi'), findsOneWidget);
      expect(find.text('Bahan 70%'), findsOneWidget);
      expect(find.text('Kemasan 20%'), findsOneWidget);
      expect(find.text('Lain 10%'), findsOneWidget);
    });

    testWidgets('HppTargetMarginCard renders recommended price and chip interactions', (tester) async {
      double currentMargin = 0.30;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: HppTargetMarginCard(
                  hppPerUnit: 10000,
                  selectedMargin: currentMargin,
                  onMarginChanged: (newMargin) {
                    setState(() => currentMargin = newMargin);
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Simulator Margin & Harga Jual'), findsOneWidget);
      expect(find.text('30%'), findsOneWidget);
      expect(find.text('Ideal'), findsOneWidget);

      // Selling price for 10,000 / (1 - 0.30) = 14,285.7 -> rounded to nearest 500 = 14,500
      expect(find.text('Rp 14.500'), findsOneWidget);
      // Profit: 14,500 - 10,000 = 4,500
      expect(find.text('+Rp 4.500'), findsOneWidget);

      // Tap 50% chip
      await tester.tap(find.text('50%'));
      await tester.pumpAndSettle();

      expect(currentMargin, 0.50);
      // Selling price for 10,000 / (1 - 0.50) = 20,000
      expect(find.text('Rp 20.000'), findsOneWidget);
      // Profit: 20,000 - 10,000 = 10,000
      expect(find.text('+Rp 10.000'), findsOneWidget);
    });
  });
}
