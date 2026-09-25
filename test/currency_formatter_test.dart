import 'package:catat_untung/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter', () {
    group('formatRupiah', () {
      test('should format positive amount', () {
        expect(CurrencyFormatter.formatRupiah(125000), 'Rp 125.000');
      });

      test('should format zero', () {
        expect(CurrencyFormatter.formatRupiah(0), 'Rp 0');
      });

      test('should format large number', () {
        expect(CurrencyFormatter.formatRupiah(1000000), 'Rp 1.000.000');
      });

      test('should format small number', () {
        expect(CurrencyFormatter.formatRupiah(5000), 'Rp 5.000');
      });
    });

    group('formatWithSign', () {
      test('should add + for positive', () {
        expect(CurrencyFormatter.formatWithSign(50000), '+Rp 50.000');
      });

      test('should add - for negative', () {
        expect(CurrencyFormatter.formatWithSign(-30000), '-Rp 30.000');
      });

      test('should not add sign for zero', () {
        expect(CurrencyFormatter.formatWithSign(0), 'Rp 0');
      });
    });
  });
}
