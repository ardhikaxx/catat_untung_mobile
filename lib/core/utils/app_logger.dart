import 'package:flutter/foundation.dart';

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
}
