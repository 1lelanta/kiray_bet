import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/compare/presentation/screens/compare_result_screen.dart';
import '../../features/compare/presentation/screens/compare_selection_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/listings/presentation/screens/listing_detail_screen.dart';
import '../../features/listings/presentation/screens/listing_filter_screen.dart';
import '../../features/listings/presentation/screens/listing_form_screen.dart';
import '../../features/listings/presentation/screens/listing_map_screen.dart';
import '../../features/listings/presentation/screens/listings_screen.dart';
import '../../features/listings/presentation/screens/viewing_requests_screen.dart';
import '../../features/onboarding/domain/onboarding_state.dart';
import '../../features/onboarding/presentation/providers/onboarding_providers.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/authentication_destination.dart';
import '../../features/authentication/presentation/providers/authentication_providers.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/registration_screen.dart';
import '../../features/authentication/presentation/screens/splash_language_screen.dart';
import '../../features/profile/presentation/screens/my_listings_screen.dart';
import '../../features/profile/presentation/screens/post_listing_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/report/presentation/screens/report_scam_screen.dart';
import '../constants/route_names.dart';
import '../constants/route_paths.dart';
import '../widgets/error_view.dart';
import 'app_shell.dart';
import '../../features/report/presentation/screens/moderation_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.onDispose(refreshNotifier.dispose);
  ref.listen<OnboardingState>(
    onboardingNotifierProvider,
    (_, _) => refreshNotifier.refresh(),
  );
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.onboarding,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final seen = ref.read(onboardingNotifierProvider).hasSeenOnboarding;
      final user = ref.read(currentUserProvider);
      final onboarding = state.uri.path == RoutePaths.onboarding;
      if (!seen && !onboarding) return RoutePaths.onboarding;
      if (seen && onboarding) {
        return user == null
            ? RoutePaths.splash
            : AuthenticationDestination.forRole(user.role);
      }
      if (state.uri.path == RoutePaths.splash && user != null) {
        return AuthenticationDestination.forRole(user.role);
      }
      return null;
    },
    errorBuilder: (context, state) =>
        Scaffold(body: ErrorView(message: 'Page not found: ${state.uri}')),
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashLanguageScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.registration,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
  path: RoutePaths.moderation,
  name: RouteNames.moderation,
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) => const ModerationScreen(),
),
      GoRoute(
        path: RoutePaths.report,
        name: RouteNames.report,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ReportScamScreen(
          listingId: state.pathParameters['listingId'] ?? '',
        ),
      ),
      GoRoute(
        path: RoutePaths.post,
        name: RouteNames.post,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PostListingScreen(),
      ),
      GoRoute(
        path: RoutePaths.viewingRequests,
        name: RouteNames.viewingRequests,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ViewingRequestsScreen(),
      ),
      GoRoute(
        path: RoutePaths.requestViewing,
        name: RouteNames.requestViewing,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ViewingRequestsScreen(
          listingId: state.pathParameters['listingId'] ?? '',
        ),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.listings,
                name: RouteNames.listings,
                builder: (context, state) => const ListingsScreen(),
                routes: [
                  GoRoute(
                    path: 'filter',
                    name: RouteNames.listingFilter,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ListingFilterScreen(),
                  ),
                  GoRoute(
                    path: 'map',
                    name: RouteNames.listingMap,
                    builder: (context, state) => const ListingMapScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: RouteNames.listingDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ListingDetailScreen(
                      listingId: state.pathParameters['id'] ?? '',
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: RouteNames.listingEdit,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => ListingFormScreen(
                          listingId: state.pathParameters['id'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.compare,
                name: RouteNames.compare,
                builder: (context, state) => const CompareSelectionScreen(),
                routes: [
                  GoRoute(
                    path: 'result',
                    name: RouteNames.compareResult,
                    builder: (context, state) => const CompareResultScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.favorites,
                name: RouteNames.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: RouteNames.settings,
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'my-listings',
                    name: RouteNames.myListings,
                    builder: (context, state) => const MyListingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
