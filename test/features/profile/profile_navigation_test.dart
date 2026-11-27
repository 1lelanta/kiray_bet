import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listings_screen.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kiray_bet/features/profile/presentation/screens/profile_details_screen.dart';
import 'package:kiray_bet/features/profile/presentation/screens/settings_screen.dart';

void main() {
  testWidgets('Profile tab shows the profile in the real app', (tester) async {
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

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProfileDetailsScreen), findsOneWidget);
    expect(find.text('tenant@kiray.demo'), findsOneWidget);

    await tester.tap(find.byKey(const Key('profile-open-settings')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });
}
