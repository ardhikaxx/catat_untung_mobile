import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullDateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final DateFormat _shortDateFormat = DateFormat('d MMM yyyy', 'id_ID');
  static final DateFormat _dayFormat = DateFormat('EEEE', 'id_ID');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'id_ID');
  static final DateFormat _dayMonthFormat = DateFormat('d MMM', 'id_ID');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');

  static String formatFull(DateTime date) {
    return _fullDateFormat.format(date);
  }

  static String formatShort(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatDay(DateTime date) {
    return _dayFormat.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String formatDayMonth(DateTime date) {
    return _dayMonthFormat.format(date);
  }

  static String formatIso(DateTime date) {
    return _isoFormat.format(date);
  }

  static DateTime parseIso(String dateStr) {
    return _isoFormat.parse(dateStr);
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
