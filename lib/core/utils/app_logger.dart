import 'dart:io';

import 'package:flutter/foundation.dart';

/// In-memory error buffer.
///
/// The app ships without any network permission, so nothing is ever uploaded.
/// Errors are kept locally and the user can share them from Settings when they
/// report a problem.
class AppLogger {
  AppLogger._();

  static const int _maxEntries = 50;
  static final List<String> recentErrors = [];

  /// Store an error for later inspection. Does not print: callers that print
  /// themselves (e.g. [FlutterError.presentError]) should use this.
  static void record(String scope, Object error, StackTrace? stack) {
    final entry =
        '[${DateTime.now().toIso8601String()}] [$scope] $error\n${stack ?? StackTrace.empty}';
    recentErrors.add(entry);
    if (recentErrors.length > _maxEntries) {
      recentErrors.removeAt(0);
    }
  }

  /// Store an error and print it to the console.
  static void report(String scope, Object error, StackTrace? stack) {
    record(scope, error, stack);
    debugPrint('[$scope] $error\n${stack ?? StackTrace.empty}');
  }

  static bool get hasEntries => recentErrors.isNotEmpty;

  static void clear() => recentErrors.clear();

  /// Plain-text crash report, ready to be shared by the user through any app.
  static String buildReport({required String appVersion}) {
    final buffer = StringBuffer()
      ..writeln('Catat Untung - Laporan Error')
      ..writeln('Versi aplikasi: $appVersion')
      ..writeln('Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}')
      ..writeln('Waktu laporan: ${DateTime.now().toIso8601String()}')
      ..writeln('Jumlah error: ${recentErrors.length}')
      ..writeln('---');
    if (recentErrors.isEmpty) {
      buffer.writeln('Tidak ada error yang tercatat.');
    } else {
      buffer.writeln(recentErrors.join('\n\n'));
    }
    return buffer.toString();
  }
}
