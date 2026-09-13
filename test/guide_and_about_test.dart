import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catat_untung/features/guide/quick_guide_screen.dart';
import 'package:catat_untung/features/about/about_screen.dart';

void main() {
  group('QuickGuideScreen & AboutScreen Tests', () {
    testWidgets('QuickGuideScreen renders hero banner and all 4 steps', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: QuickGuideScreen(),
        ),
      );

      expect(find.text('Panduan Singkat'), findsOneWidget);
      expect(find.text('PANDUAN LENGKAP UMKM'), findsOneWidget);
      expect(find.text('ALUR KERJA HARIAN'), findsOneWidget);
      expect(find.text('Daftarkan Katalog & Modal HPP'), findsOneWidget);
      expect(find.text('Catat Rekap Penjualan Harian'), findsOneWidget);
      expect(find.text('Pantau Omzet & Laba Bersih'), findsOneWidget);
      expect(find.text('Analisis Tren & Unduh Laporan'), findsOneWidget);
      expect(find.text('TIPS KEUANGAN UMKM'), findsOneWidget);
      expect(find.text('PERTANYAAN UMUM (FAQ)'), findsOneWidget);
      expect(find.text('Mulai Catat Rekap Penjualan'), findsOneWidget);
    });

    testWidgets('AboutScreen renders brand card and system specs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      expect(find.text('Tentang Aplikasi'), findsOneWidget);
      expect(find.text('Catat Untung'), findsOneWidget);
      expect(find.text('100% Offline Safe'), findsOneWidget);
      expect(find.text('Filosofi & Misi Kami'), findsOneWidget);
      expect(find.text('KEUNGGULAN UTAMA'), findsOneWidget);
      expect(find.text('Spesifikasi Sistem'), findsOneWidget);
      expect(find.text('SQLite Engine via Drift ORM'), findsOneWidget);
      expect(find.text('Salin Info'), findsOneWidget);
      expect(find.text('Buka Panduan'), findsOneWidget);
    });
  });
}
