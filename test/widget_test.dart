import 'package:flutter_test/flutter_test.dart';
import 'package:catat_untung/core/utils/calculation_utils.dart';
import 'package:catat_untung/core/utils/currency_formatter.dart';

void main() {
  group('CalculationUtils', () {
    test('calculateItemRevenue', () {
      expect(CalculationUtils.calculateItemRevenue(5, 10000), 50000);
    });

    test('calculateItemCost', () {
      expect(CalculationUtils.calculateItemCost(3, 5000), 15000);
    });

    test('calculateItemProfit positive', () {
      expect(CalculationUtils.calculateItemProfit(1, 15000, 10000), 5000);
    });

    test('calculateItemProfit negative', () {
      expect(CalculationUtils.calculateItemProfit(1, 8000, 10000), -2000);
    });

    test('calculateItemProfit break even', () {
      expect(CalculationUtils.calculateItemProfit(1, 10000, 10000), 0);
    });

    test('calculateMargin', () {
      expect(CalculationUtils.calculateMargin(100000, 60000), 40);
    });

    test('totalQuantity', () {
      final items = [
        {'quantity': 2, 'sellingPrice': 10000},
        {'quantity': 5, 'sellingPrice': 5000},
      ];
      expect(CalculationUtils.totalQuantity(items), 7);
    });
  });

  group('CurrencyFormatter', () {
    test('formatRupiah', () {
      expect(CurrencyFormatter.formatRupiah(125000), 'Rp 125.000');
    });

    test('formatWithSign positive', () {
      expect(CurrencyFormatter.formatWithSign(50000), '+Rp 50.000');
    });

    test('formatWithSign negative', () {
      expect(CurrencyFormatter.formatWithSign(-30000), '-Rp 30.000');
    });
  });
}
