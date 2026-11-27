import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/providers/theme_mode_provider.dart';
import 'features/authentication/presentation/providers/selected_language_provider.dart';
import 'core/localization/l10n.dart';

class KirayBetApp extends ConsumerWidget {
  const KirayBetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(selectedLanguageProvider);
    L10n.languageCode = languageCode;
    return MaterialApp.router(
      routerConfig: ref.watch(appRouterProvider),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      locale: Locale(languageCode),
      supportedLocales: const [Locale('en'), Locale('am')],
      localizationsDelegates: const [GlobalWidgetsLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      debugShowCheckedModeBanner: false,
      title: 'Kiray Bet',
    );
  }
}
