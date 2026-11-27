import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/profile/presentation/screens/profile_details_screen.dart';
import 'package:kiray_bet/features/profile/presentation/screens/settings_screen.dart';

const demoPassword = InMemoryAuthenticationRepository.demoPassword;

/// Pumps the Profile screen inside a small test-only router.
///
/// Used for focused screen tests. `/profile/settings` points at the app's
/// existing `SettingsScreen` and `/login` at the existing `LoginScreen`.
/// `profile_navigation_test.dart` covers the real app router.
Future<ProviderContainer> pumpProfileTestApp(
  WidgetTester tester, {
  required String initialLocation,
  String? signedInEmail,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final authentication = InMemoryAuthenticationRepository();
  if (signedInEmail != null) {
    authentication.signIn(email: signedInEmail, password: demoPassword);
  }
  final container = ProviderContainer(
    overrides: [
      authenticationRepositoryProvider.overrideWithValue(authentication),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RoutePaths.profile,
        builder: (context, state) => const ProfileDetailsScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}
