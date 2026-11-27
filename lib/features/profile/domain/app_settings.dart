import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// The appearance the user chose for the app.
enum AppThemePreference { system, light, dark }

/// Device-level preferences shown on the Settings screen.
///
/// Held in memory only. The language preference is not stored here: it is
/// owned by the shared `selectedLanguageProvider`.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemePreference.system) AppThemePreference themePreference,
    @Default(true) bool notificationsEnabled,
  }) = _AppSettings;
}
