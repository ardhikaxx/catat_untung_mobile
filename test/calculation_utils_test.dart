import 'package:catat_untung/core/utils/calculation_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculationUtils', () {
    group('calculateItemRevenue', () {
      test('should calculate revenue correctly', () {
        expect(CalculationUtils.calculateItemRevenue(5, 10000), 50000);
      });

      test('should return 0 when quantity is 0', () {
        expect(CalculationUtils.calculateItemRevenue(0, 10000), 0);
      });

      test('should return 0 when price is 0', () {
        expect(CalculationUtils.calculateItemRevenue(5, 0), 0);
      });
    });

    group('calculateItemCost', () {
      test('should calculate cost correctly', () {
        expect(CalculationUtils.calculateItemCost(3, 5000), 15000);
      });

      test('should return 0 when quantity is 0', () {
        expect(CalculationUtils.calculateItemCost(0, 5000), 0);
      });
    });

    group('calculateItemProfit', () {
      test('should calculate positive profit', () {
        expect(CalculationUtils.calculateItemProfit(1, 15000, 10000), 5000);
      });

      test('should calculate negative profit (loss)', () {
        expect(CalculationUtils.calculateItemProfit(1, 8000, 10000), -2000);
      });

      test('should return 0 for break even', () {
        expect(CalculationUtils.calculateItemProfit(1, 10000, 10000), 0);
      });

      test('should calculate correctly with multiple quantity', () {
        expect(CalculationUtils.calculateItemProfit(3, 15000, 10000), 15000);
      });
    });

    group('calculateTotalRevenue', () {
      test('should sum all item revenues', () {
        final items = [
          {'quantity': 2, 'sellingPrice': 10000},
          {'quantity': 3, 'sellingPrice': 5000},
        ];
        expect(CalculationUtils.calculateTotalRevenue(items), 35000);
      });

      test('should return 0 for empty list', () {
        expect(CalculationUtils.calculateTotalRevenue([]), 0);
      });
    });

    group('calculateTotalCost', () {
      test('should sum all item costs', () {
        final items = [
          {'quantity': 2, 'hpp': 8000},
          {'quantity': 1, 'hpp': 3000},
        ];
        expect(CalculationUtils.calculateTotalCost(items), 19000);
      });
    });

    group('calculateMargin', () {
      test('should calculate margin percentage', () {
        expect(CalculationUtils.calculateMargin(100000, 60000), 40);
      });

      test('should return 0 when revenue is 0', () {
        expect(CalculationUtils.calculateMargin(0, 0), 0);
      });

      test('should handle negative profit margin', () {
        expect(CalculationUtils.calculateMargin(50000, 60000), -20);
      });
    });

    group('totalQuantity', () {
      test('should sum all quantities', () {
        final items = [
          {'quantity': 2, 'sellingPrice': 10000},
          {'quantity': 5, 'sellingPrice': 5000},
        ];
        expect(CalculationUtils.totalQuantity(items), 7);
      });

      test('should return 0 for empty list', () {
        expect(CalculationUtils.totalQuantity([]), 0);
      });
    });

    group('real-world scenario', () {
      test('daily sales calculation', () {
        final items = [
          {'quantity': 10, 'sellingPrice': 15000, 'hpp': 8000},
          {'quantity': 5, 'sellingPrice': 12000, 'hpp': 6000},
          {'quantity': 3, 'sellingPrice': 20000, 'hpp': 12000},
        ];

        final totalRevenue = CalculationUtils.calculateTotalRevenue(items);
        final totalCost = CalculationUtils.calculateTotalCost(items);
        final totalProfit = totalRevenue - totalCost;
        final margin = CalculationUtils.calculateMargin(totalRevenue, totalCost);

        expect(totalRevenue, 270000);
        expect(totalCost, 146000);
        expect(totalProfit, 124000);
        expect(margin, 46);
      });
    });
  });
}
