import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _compactFormat = NumberFormat.compactCurrency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _percentFormat = NumberFormat.percentPattern('id_ID');

  static String formatRupiah(int amount) {
    return _rupiahFormat.format(amount);
  }

  static String formatRupiahCompact(int amount) {
    if (amount.abs() >= 1000000) {
      return _compactFormat.format(amount);
    }
    return _rupiahFormat.format(amount);
  }

  static String formatPercent(double value) {
    return _percentFormat.format(value);
  }

  static String formatWithSign(int amount) {
    final prefix = amount > 0 ? '+' : '';
    return '$prefix${_rupiahFormat.format(amount)}';
  }
}
