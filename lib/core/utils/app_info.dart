import 'package:package_info_plus/package_info_plus.dart';

/// Single source of truth for the app version.
///
/// The value is read from the package metadata (generated from `pubspec.yaml`)
/// at startup, so the About screen, Settings and exported reports can never
/// drift from the version that was actually published.
class AppInfo {
  AppInfo._();

  static const String _unknown = '—';

  static String _version = '';
  static String _buildNumber = '';

  /// Version name without the build number, e.g. `1.1.0`.
  static String get version => _version.isEmpty ? _unknown : _version;

  /// Android version code / iOS CFBundleVersion, e.g. `3`.
  static String get buildNumber => _buildNumber.isEmpty ? _unknown : _buildNumber;

  /// `1.1.0 (3)` when the build number is known, otherwise just `1.1.0`.
  static String get versionWithBuild => _buildNumber.isEmpty
      ? version
      : '$version ($_buildNumber)';

  /// `Catat Untung v1.1.0 (3)`
  static String get titleWithVersion => 'Catat Untung v$versionWithBuild';

  /// Reads the version from the platform. Safe to call more than once.
  ///
  /// Never throws: if the platform channel is unavailable (for example in unit
  /// tests) the getters fall back to an em dash instead of crashing the UI.
  static Future<void> load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version.trim();
      _buildNumber = info.buildNumber.trim();
    } catch (_) {
      _version = '';
      _buildNumber = '';
    }
  }
}
