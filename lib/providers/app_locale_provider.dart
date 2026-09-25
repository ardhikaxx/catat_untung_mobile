import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preference key for the selected app locale.
/// Stored values: `'system'` (follow device), `'id'`, or `'en'`.
const kLocalePrefKey = 'app_locale';

/// Current UI locale. `null` means "follow the system locale".
final appLocaleProvider = StateProvider<Locale?>((ref) => null);

/// Maps a stored preference code to a [Locale]. `null` (or unknown) = system.
Locale? localeFromPrefCode(String? code) {
  switch (code) {
    case 'id':
      return const Locale('id');
    case 'en':
      return const Locale('en');
    default:
      return null;
  }
}

/// Persists the language choice (`'system' | 'id' | 'en'`) and updates
/// [appLocaleProvider] so the UI rebuilds immediately.
Future<void> saveAppLocale(StateController<Locale?> notifier, String code) async {
  notifier.state = localeFromPrefCode(code);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(kLocalePrefKey, code);
}

/// Reads the persisted language choice at startup (call before `runApp`).
Future<Locale?> loadAppLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return localeFromPrefCode(prefs.getString(kLocalePrefKey));
}
