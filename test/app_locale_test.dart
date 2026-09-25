import 'package:catat_untung/providers/app_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('localeFromPrefCode', () {
    test('maps stored codes to locales', () {
      expect(localeFromPrefCode('id'), const Locale('id'));
      expect(localeFromPrefCode('en'), const Locale('en'));
      expect(localeFromPrefCode('system'), isNull);
      expect(localeFromPrefCode(null), isNull);
      expect(localeFromPrefCode('unknown'), isNull);
    });
  });

  group('saveAppLocale', () {
    test('updates provider and persists the choice', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(appLocaleProvider.notifier);

      await saveAppLocale(notifier, 'en');
      expect(container.read(appLocaleProvider), const Locale('en'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(kLocalePrefKey), 'en');

      await saveAppLocale(notifier, 'system');
      expect(container.read(appLocaleProvider), isNull);
      expect(prefs.getString(kLocalePrefKey), 'system');
    });
  });

  group('loadAppLocale', () {
    test('reads the persisted locale at startup', () async {
      SharedPreferences.setMockInitialValues({kLocalePrefKey: 'id'});
      expect(await loadAppLocale(), const Locale('id'));

      SharedPreferences.setMockInitialValues({kLocalePrefKey: 'en'});
      expect(await loadAppLocale(), const Locale('en'));

      SharedPreferences.setMockInitialValues({kLocalePrefKey: 'system'});
      expect(await loadAppLocale(), isNull);

      SharedPreferences.setMockInitialValues({});
      expect(await loadAppLocale(), isNull);
    });
  });
}
