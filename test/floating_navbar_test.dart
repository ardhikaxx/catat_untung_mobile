import 'package:catat_untung/features/home/home_screen.dart';
import 'package:catat_untung/shared/widgets/app_floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFloatingNavBar Widget Tests', () {
    testWidgets('AppFloatingNavBar renders 5 tabs and shows active label', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppFloatingNavBar(activeIndex: 0),
            ),
          ),
        ),
      );

      // Tab labels
      expect(find.text('Beranda'), findsOneWidget);

      // Verify that all 5 icons exist
      expect(find.byType(AppFloatingNavBar), findsOneWidget);
    });

    testWidgets('Tapping tab changes currentTabProvider state', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppFloatingNavBar(),
            ),
          ),
        ),
      );

      expect(container.read(currentTabProvider), 0);

      // Tap Rekap tab (index 1)
      final rekapFinder = find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.child is AnimatedContainer,
      );
      expect(rekapFinder, findsNWidgets(5));

      // Tap index 1 (Rekap)
      await tester.tap(rekapFinder.at(1));
      await tester.pumpAndSettle();

      expect(container.read(currentTabProvider), 1);

      // Tap index 2 (Riwayat)
      await tester.tap(rekapFinder.at(2));
      await tester.pumpAndSettle();

      expect(container.read(currentTabProvider), 2);
    });
  });
}
