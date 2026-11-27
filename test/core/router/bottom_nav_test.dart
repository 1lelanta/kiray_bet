import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/core/localization/l10n.dart';
import 'package:kiray_bet/core/router/app_router.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  tearDown(() => L10n.languageCode = 'en');

  testWidgets('tenant sees five role tabs in the required order', (
    tester,
  ) async {
    final harness = await _pumpAsRole(tester, 'tenant@kiray.demo');
    addTearDown(() => _disposeHarness(tester, harness));

    expect(_tabLabels(tester), [
      'Browse',
      'Map',
      'Favourites',
      'Viewing requests',
      'Profile and Settings',
    ]);

    final router = harness.container.read(appRouterProvider);
    final bar = find.byType(NavigationBar);
    await tester.tap(find.descendant(of: bar, matching: find.text('Map')));
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      RoutePaths.listingMap,
    );

    router.go(RoutePaths.viewingRequests);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: bar, matching: find.text('Viewing requests')),
    );
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      RoutePaths.viewingRequests,
    );
  });

  testWidgets('owner sees four role tabs in the required order', (
    tester,
  ) async {
    final harness = await _pumpAsRole(tester, 'owner@kiray.demo');
    addTearDown(() => _disposeHarness(tester, harness));

    expect(_tabLabels(tester), [
      'My listings',
      'Browse',
      'Viewing requests',
      'Profile and Settings',
    ]);
  });

  testWidgets('admin sees three role tabs in the required order', (
    tester,
  ) async {
    final harness = await _pumpAsRole(tester, 'admin@kiray.demo');
    addTearDown(() => _disposeHarness(tester, harness));

    expect(_tabLabels(tester), [
      'Moderation',
      'Browse',
      'Profile and Settings',
    ]);
  });

  testWidgets('navigation labels render in Amharic', (tester) async {
    final harness = await _pumpAsRole(
      tester,
      'tenant@kiray.demo',
      language: 'am',
    );
    addTearDown(() => _disposeHarness(tester, harness));

    expect(_tabLabels(tester), [
      'የቤት ኪራይ ይፈልጉ',
      'ካርታ',
      'ተወዳጆች',
      'የማየት ጥያቄዎች',
      'መገለጫ እና ቅንብሮች',
    ]);
  });

  testWidgets('switching from tenant to owner updates the tabs', (
    tester,
  ) async {
    final harness = await _pumpAsRole(tester, 'tenant@kiray.demo');
    addTearDown(() => _disposeHarness(tester, harness));
    final authentication = harness.container.read(currentUserProvider.notifier);

    expect(_tabLabels(tester), hasLength(5));

    authentication.signOut();
    await tester.pumpAndSettle();
    authentication.signIn(
      email: 'owner@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    await tester.pumpAndSettle();

    expect(_tabLabels(tester), [
      'My listings',
      'Browse',
      'Viewing requests',
      'Profile and Settings',
    ]);
  });
}

Future<_Harness> _pumpAsRole(
  WidgetTester tester,
  String email, {
  String language = 'en',
}) async {
  final authenticationRepository = InMemoryAuthenticationRepository();
  final user = authenticationRepository.signIn(
    email: email,
    password: InMemoryAuthenticationRepository.demoPassword,
  );
  if (language != user.preferredLanguage) {
    authenticationRepository.updateProfile(
      name: user.name,
      phone: user.phone,
      preferredLanguage: language,
    );
  }

  final container = ProviderContainer(
    overrides: [
      authenticationRepositoryProvider.overrideWithValue(
        authenticationRepository,
      ),
      onboardingRepositoryProvider.overrideWithValue(
        InMemoryOnboardingRepository(hasSeenOnboarding: true),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const KirayBetApp()),
  );
  await tester.pumpAndSettle();

  return _Harness(container);
}

List<String> _tabLabels(WidgetTester tester) => tester
    .widget<NavigationBar>(find.byType(NavigationBar))
    .destinations
    .whereType<NavigationDestination>()
    .map((destination) => destination.label)
    .toList();

Future<void> _disposeHarness(WidgetTester tester, _Harness harness) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
  harness.container.dispose();
}

class _Harness {
  const _Harness(this.container);

  final ProviderContainer container;
}
