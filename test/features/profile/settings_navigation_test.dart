import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/core/router/app_router.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kiray_bet/features/profile/presentation/screens/account_settings_screen.dart';

void main() {
  testWidgets('Settings route shows settings and signs out in the real app', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(
            InMemoryOnboardingRepository(hasSeenOnboarding: true),
          ),
          authenticationRepositoryProvider.overrideWithValue(
            InMemoryAuthenticationRepository()..signIn(
              email: 'owner@kiray.demo',
              password: InMemoryAuthenticationRepository.demoPassword,
            ),
          ),
        ],
        child: const KirayBetApp(),
      ),
    );
    await tester.pumpAndSettle();

    ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
        .read(appRouterProvider)
        .go(RoutePaths.settings);
    await tester.pumpAndSettle();
    expect(find.byType(AccountSettingsScreen), findsOneWidget);
    expect(find.byKey(const Key('settings-my-listings')), findsOneWidget);

    await tester.tap(find.byKey(const Key('settings-sign-out')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-sign-out-confirm')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
