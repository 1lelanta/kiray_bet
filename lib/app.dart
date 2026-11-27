import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/localization/common_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/providers/theme_mode_provider.dart';
import 'features/authentication/presentation/providers/selected_language_provider.dart';
import 'core/localization/l10n.dart';
import 'features/authentication/presentation/authentication_strings.dart';

final _rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class KirayBetApp extends ConsumerWidget {
  const KirayBetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<GuardMessage?>(guardMessageProvider, (_, message) {
      if (message == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messenger = _rootScaffoldMessengerKey.currentState;
        if (messenger == null) return;
        messenger.showSnackBar(
          SnackBar(content: Text(CommonStrings.accessDenied)),
        );
        ref.read(guardMessageProvider.notifier).clear();
      });
    });

    final languageCode = ref.watch(selectedLanguageProvider);
    L10n.languageCode = languageCode;
    return MaterialApp.router(
      routerConfig: ref.watch(appRouterProvider),
      scaffoldMessengerKey: _rootScaffoldMessengerKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      locale: Locale(languageCode),
      supportedLocales: const [Locale('en'), Locale('am')],
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: AuthenticationStrings.appName,
    );
  }
}
