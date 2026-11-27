import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_settings.dart';
import 'app_settings_provider.dart';

/// The [ThemeMode] that `KirayBetApp` applies, derived from the theme
/// preference chosen in Settings. Name and type are kept for `app.dart`.
final themeModeProvider = Provider<ThemeMode>(
  (ref) => switch (ref.watch(appSettingsProvider).themePreference) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  },
);
