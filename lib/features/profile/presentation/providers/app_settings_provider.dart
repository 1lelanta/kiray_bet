import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_settings.dart';

/// In-memory app settings. They reset when the app restarts.
final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setThemePreference(AppThemePreference preference) =>
      state = state.copyWith(themePreference: preference);

  void setNotificationsEnabled(bool enabled) =>
      state = state.copyWith(notificationsEnabled: enabled);
}
