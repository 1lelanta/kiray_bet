import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/core/theme/app_theme.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/auth_feature_placeholder_screen.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:kiray_bet/features/listings/presentation/screens/viewing_requests_screen.dart';
import 'package:kiray_bet/features/profile/presentation/providers/theme_mode_provider.dart';
import 'package:kiray_bet/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:kiray_bet/features/profile/presentation/screens/my_listings_screen.dart';

/// Pumps the Settings screen inside a small test-only router.
///
/// Used for focused screen tests. Every shortcut destination is the app's
/// existing screen, and the theme is applied the same way `app.dart` does.
/// `settings_navigation_test.dart` covers the real app router.
Future<ProviderContainer> pumpSettingsTestApp(
  WidgetTester tester, {
  required String initialLocation,
  String? signedInEmail,
}) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final authentication = InMemoryAuthenticationRepository();
  if (signedInEmail != null) {
    authentication.signIn(
      email: signedInEmail,
      password: InMemoryAuthenticationRepository.demoPassword,
    );
  }
  final container = ProviderContainer(
    overrides: [
      authenticationRepositoryProvider.overrideWithValue(authentication),
    ],
  );
  addTearDown(container.dispose);

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.myListings,
        builder: (context, state) => const MyListingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RoutePaths.viewingRequests,
        builder: (context, state) => const ViewingRequestsScreen(),
      ),
      GoRoute(
        path: RoutePaths.moderation,
        builder: (context, state) => const AuthFeaturePlaceholderScreen(
          title: AuthenticationStrings.moderationTitle,
          message: AuthenticationStrings.moderationUnavailable,
        ),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ref.watch(themeModeProvider),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}
