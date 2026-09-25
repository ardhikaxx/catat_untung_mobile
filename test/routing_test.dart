import 'package:catat_untung/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpAt(WidgetTester tester, String location) async {
    final container = ProviderContainer();
    final router = container.read(goRouterProvider);
    router.go(location);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  testWidgets('unknown route shows friendly error page', (tester) async {
    await pumpAt(tester, '/rute-tidak-ada');

    expect(find.text('Ups, halaman tidak ditemukan'), findsOneWidget);
    expect(find.text('Kembali ke Beranda'), findsOneWidget);
  });

  testWidgets('invalid product id shows error page instead of crashing',
      (tester) async {
    await pumpAt(tester, '/products/edit/abc');

    expect(find.text('ID produk tidak valid.'), findsOneWidget);
    expect(find.text('Kembali ke Beranda'), findsOneWidget);
  });
}
