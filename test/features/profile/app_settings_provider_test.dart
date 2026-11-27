import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listings_screen.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kiray_bet/features/profile/domain/app_settings.dart';
import 'package:kiray_bet/features/profile/presentation/providers/app_settings_provider.dart';
import 'package:kiray_bet/features/profile/presentation/providers/theme_mode_provider.dart';

void main() {
  group('appSettingsProvider', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('defaults to the system theme with notifications on', () {
      expect(container.read(appSettingsProvider), const AppSettings());
      expect(
        container.read(appSettingsProvider).themePreference,
        AppThemePreference.system,
      );
      expect(container.read(appSettingsProvider).notificationsEnabled, isTrue);
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('theme preference drives themeModeProvider', () {
      final notifier = container.read(appSettingsProvider.notifier);

      notifier.setThemePreference(AppThemePreference.light);
      expect(container.read(themeModeProvider), ThemeMode.light);

      notifier.setThemePreference(AppThemePreference.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);

      notifier.setThemePreference(AppThemePreference.system);
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('notifications preference is stored in memory', () {
      container
          .read(appSettingsProvider.notifier)
          .setNotificationsEnabled(false);
      expect(container.read(appSettingsProvider).notificationsEnabled, isFalse);
      expect(
        container.read(appSettingsProvider).themePreference,
        AppThemePreference.system,
      );
    });
  });

  testWidgets('the real KirayBetApp applies the chosen theme preference', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(
            InMemoryOnboardingRepository(hasSeenOnboarding: true),
          ),
          authenticationRepositoryProvider.overrideWithValue(
            InMemoryAuthenticationRepository()..signIn(
              email: 'tenant@kiray.demo',
              password: InMemoryAuthenticationRepository.demoPassword,
            ),
          ),
        ],
        child: const KirayBetApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ListingsScreen), findsOneWidget);

    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app().themeMode, ThemeMode.system);

    ProviderScope.containerOf(tester.element(find.byType(ListingsScreen)))
        .read(appSettingsProvider.notifier)
        .setThemePreference(AppThemePreference.dark);
    await tester.pumpAndSettle();

    expect(app().themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(ListingsScreen))).brightness,
      Brightness.dark,
    );
  });
}
