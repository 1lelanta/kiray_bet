import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
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
import 'package:kiray_bet/features/profile/presentation/screens/profile_details_screen.dart';

const demoPassword = InMemoryAuthenticationRepository.demoPassword;

/// Pumps the new Profile and Settings screens inside a test-only router.
///
/// The real `app_router.dart` still points `/profile` and `/profile/settings`
/// at the placeholder screens, so this router maps the same paths to the new
/// screens. All other destinations are the app's existing screens, unchanged.
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
