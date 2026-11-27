import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/core/localization/common_strings.dart';
import 'package:kiray_bet/core/localization/l10n.dart';
import 'package:kiray_bet/core/router/app_router.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  tearDown(() => L10n.languageCode = 'en');

  test('access-denied message is localized', () {
    L10n.languageCode = 'en';
    expect(CommonStrings.accessDenied, "You don't have access to that page.");

    L10n.languageCode = 'am';
    expect(CommonStrings.accessDenied, 'ወደዚያ ገጽ የመግባት ፈቃድ የለዎትም።');
  });

  testWidgets('signed-out users are redirected from protected routes', (
    tester,
  ) async {
    final harness = await _pumpApp(tester);
    addTearDown(harness.container.dispose);

    harness.router.go(RoutePaths.favorites);
    await tester.pumpAndSettle();

    expect(_currentPath(harness.router), RoutePaths.login);
    expect(find.text(CommonStrings.accessDenied), findsNothing);
  });

  final blockedRoutes = <(String, String, String, List<String>)>[
    (
      'tenant',
      'tenant@kiray.demo',
      RoutePaths.listings,
      [
        RoutePaths.myListings,
        RoutePaths.post,
        RoutePaths.listingEditPath('guard-listing'),
        RoutePaths.moderation,
      ],
    ),
    (
      'owner',
      'owner@kiray.demo',
      RoutePaths.myListings,
      [
        RoutePaths.favorites,
        RoutePaths.reportPath('guard-listing'),
        RoutePaths.moderation,
      ],
    ),
    (
      'admin',
      'admin@kiray.demo',
      RoutePaths.moderation,
      [
        RoutePaths.favorites,
        RoutePaths.reportPath('guard-listing'),
        RoutePaths.post,
        RoutePaths.listingEditPath('guard-listing'),
        RoutePaths.myListings,
      ],
    ),
  ];

  for (final (role, email, home, paths) in blockedRoutes) {
    for (final path in paths) {
      testWidgets('$role is redirected from $path with an access message', (
        tester,
      ) async {
        final harness = await _pumpApp(tester, signedInEmail: email);
        addTearDown(harness.container.dispose);

        harness.router.go(path);
        await tester.pumpAndSettle();

        expect(_currentPath(harness.router), home);
        expect(find.text(CommonStrings.accessDenied), findsOneWidget);
        expect(harness.container.read(guardMessageProvider), isNull);
      });
    }
  }

  testWidgets('roles can open their own restricted routes', (tester) async {
    final cases = [
      (
        'tenant@kiray.demo',
        <String>[RoutePaths.favorites, RoutePaths.reportPath('guard-listing')],
      ),
      (
        'owner@kiray.demo',
        <String>[
          RoutePaths.post,
          RoutePaths.listingEditPath('guard-listing'),
          RoutePaths.myListings,
        ],
      ),
      ('admin@kiray.demo', <String>[RoutePaths.moderation]),
    ];

    for (final (email, paths) in cases) {
      final harness = await _pumpApp(tester, signedInEmail: email);

      for (final path in paths) {
        harness.router.go(path);
        await tester.pumpAndSettle();

        expect(_currentPath(harness.router), path);
        expect(find.text(CommonStrings.accessDenied), findsNothing);
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      harness.container.dispose();
    }
  });

  testWidgets('all roles can open routes available to signed-in users', (
    tester,
  ) async {
    const accounts = [
      'tenant@kiray.demo',
      'owner@kiray.demo',
      'admin@kiray.demo',
    ];
    final routes = [
      RoutePaths.listings,
      RoutePaths.listingFilter,
      RoutePaths.listingMap,
      RoutePaths.listingDetailPath('guard-listing'),
      RoutePaths.viewingRequests,
      RoutePaths.profile,
      RoutePaths.settings,
    ];

    for (final email in accounts) {
      final harness = await _pumpApp(tester, signedInEmail: email);

      for (final path in routes) {
        harness.router.go(path);
        await tester.pumpAndSettle();

        expect(_currentPath(harness.router), path);
        expect(find.text(CommonStrings.accessDenied), findsNothing);
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      harness.container.dispose();
    }
  });

  testWidgets('signed-in users are redirected from public routes', (
    tester,
  ) async {
    const cases = [
      ('tenant@kiray.demo', RoutePaths.listings),
      ('owner@kiray.demo', RoutePaths.myListings),
      ('admin@kiray.demo', RoutePaths.moderation),
    ];
    const publicRoutes = [
      RoutePaths.splash,
      RoutePaths.login,
      RoutePaths.register,
    ];

    for (final (email, home) in cases) {
      final harness = await _pumpApp(tester, signedInEmail: email);

      for (final path in publicRoutes) {
        harness.router.go(path);
        await tester.pumpAndSettle();

        expect(_currentPath(harness.router), home);
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      harness.container.dispose();
    }
  });

  testWidgets('signing out on a protected route redirects to Login', (
    tester,
  ) async {
    final harness = await _pumpApp(tester, signedInEmail: 'tenant@kiray.demo');
    addTearDown(harness.container.dispose);
    harness.router.go(RoutePaths.listingFilter);
    await tester.pumpAndSettle();
    expect(_currentPath(harness.router), RoutePaths.listingFilter);

    harness.container.read(currentUserProvider.notifier).signOut();
    await tester.pumpAndSettle();

    expect(_currentPath(harness.router), RoutePaths.login);
  });

  testWidgets('router refreshes when the signed-in role changes', (
    tester,
  ) async {
    final harness = await _pumpApp(tester, signedInEmail: 'tenant@kiray.demo');
    addTearDown(harness.container.dispose);

    harness.container.read(currentUserProvider.notifier).signOut();
    await tester.pumpAndSettle();
    expect(_currentPath(harness.router), RoutePaths.login);

    harness.container
        .read(currentUserProvider.notifier)
        .signIn(
          email: 'admin@kiray.demo',
          password: InMemoryAuthenticationRepository.demoPassword,
        );
    await tester.pumpAndSettle();

    expect(_currentPath(harness.router), RoutePaths.moderation);
  });
}

Future<_RouterHarness> _pumpApp(
  WidgetTester tester, {
  String? signedInEmail,
}) async {
  final authenticationRepository = InMemoryAuthenticationRepository();
  if (signedInEmail != null) {
    authenticationRepository.signIn(
      email: signedInEmail,
      password: InMemoryAuthenticationRepository.demoPassword,
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

  return _RouterHarness(container, container.read(appRouterProvider));
}

String _currentPath(GoRouter router) =>
    router.routeInformationProvider.value.uri.path;

class _RouterHarness {
  const _RouterHarness(this.container, this.router);

  final ProviderContainer container;
  final GoRouter router;
}
