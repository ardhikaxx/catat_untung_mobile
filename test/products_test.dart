import 'package:catat_untung/database/app_database.dart';
import 'package:catat_untung/features/products/widgets/product_card.dart';
import 'package:catat_untung/features/products/widgets/product_hero_card.dart';
import 'package:catat_untung/features/products/widgets/product_live_preview_card.dart';
import 'package:catat_untung/features/products/widgets/product_search_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testProduct1 = Product(
    id: 1,
    name: 'Kopi Susu Gula Aren',
    hpp: 6000,
    sellingPrice: 15000,
    unit: 'cup',
    isActive: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  final testProduct2 = Product(
    id: 2,
    name: 'Roti Bakar Cokelat',
    hpp: 8000,
    sellingPrice: 12000,
    unit: 'porsi',
    isActive: false,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  group('Master Produk Modern Widgets Tests', () {
    testWidgets('ProductHeroCard renders stats correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductHeroCard(
              allProducts: [testProduct1, testProduct2],
            ),
          ),
        ),
      );

      expect(find.text('KATALOG MASTER PRODUK'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Total count
      expect(find.text('1 Item'), findsNWidgets(2)); // 1 active, 1 inactive
      expect(find.textContaining('Avg 60% Margin'), findsOneWidget);
    });

    testWidgets('ProductCard renders product details and triggers onTap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct1,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Kopi Susu Gula Aren'), findsOneWidget);
      expect(find.text('Satuan: cup'), findsOneWidget);
      expect(find.text('Aktif'), findsOneWidget);
      expect(find.text('Modal HPP'), findsOneWidget);
      expect(find.text('Harga Jual'), findsOneWidget);
      expect(find.text('Laba (60%)'), findsOneWidget);

      await tester.tap(find.byType(ProductCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('ProductSearchFilterBar renders search and filter chips', (tester) async {
      final controller = TextEditingController();
      ProductFilterStatus selectedStatus = ProductFilterStatus.all;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchFilterBar(
              searchController: controller,
              onSearchChanged: (_) {},
              currentFilter: selectedStatus,
              onFilterChanged: (s) => selectedStatus = s,
              currentSort: ProductSortOption.nameAsc,
              onSortChanged: (_) {},
              totalCount: 10,
              activeCount: 8,
              inactiveCount: 2,
            ),
          ),
        ),
      );

      expect(find.text('Cari produk atau satuan...'), findsOneWidget);
      expect(find.text('Semua (10)'), findsOneWidget);
      expect(find.text('Aktif (8)'), findsOneWidget);
      expect(find.text('Nonaktif (2)'), findsOneWidget);

      await tester.tap(find.text('Aktif (8)'));
      await tester.pumpAndSettle();

      expect(selectedStatus, equals(ProductFilterStatus.active));
    });

    testWidgets('ProductLivePreviewCard calculates live margin and healthy advice', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductLivePreviewCard(
              productName: 'Kopi Susu',
              hpp: 5000,
              sellingPrice: 15000,
              unit: 'cup',
            ),
          ),
        ),
      );

      expect(find.text('Simulasi Laba per Unit'), findsOneWidget);
      expect(find.text('67% Margin'), findsOneWidget);
      expect(find.text('+Rp 10.000'), findsOneWidget);
      expect(find.textContaining('Margin sangat sehat'), findsOneWidget);
    });
  });
}
