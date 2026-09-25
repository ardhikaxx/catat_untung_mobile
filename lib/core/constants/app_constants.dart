class AppConstants {
  AppConstants._();

  static const String appName = 'Catat Untung';
  static const String appTagline = 'Rekap Penjualan Harian Tanpa Internet';
  static const String appLogo = 'assets/logo.png';
  static const String authorName = 'Yanuar Ardhika Rahmadhani Ubaidillah';
  static const String copyright = 'Copyright (c) 2026 Yanuar Ardhika Rahmadhani Ubaidillah';

  static const String dbName = 'catat_untung.db';

  /// Units offered as one-tap chips in the product form. The unit itself is
  /// free text, so sellers are not limited to this list.
  static const List<String> quickUnitSuggestions = [
    'pcs',
    'porsi',
    'cup',
    'botol',
    'box',
    'paket',
    'kg',
    'unit',
  ];
}
