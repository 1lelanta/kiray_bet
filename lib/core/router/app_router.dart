import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/common_strings.dart';
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
import '../../features/authentication/domain/user_profile.dart';
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

enum GuardMessage { accessDenied }

final guardMessageProvider =
    NotifierProvider<GuardMessageNotifier, GuardMessage?>(
      GuardMessageNotifier.new,
    );

class GuardMessageNotifier extends Notifier<GuardMessage?> {
  @override
  GuardMessage? build() => null;

  void showAccessDenied() => state = GuardMessage.accessDenied;

  void clear() => state = null;
}

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
  ref.listen(currentUserProvider, (_, _) => refreshNotifier.refresh());
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.onboarding,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final seen = ref.read(onboardingNotifierProvider).hasSeenOnboarding;
      final user = ref.read(currentUserProvider);
      final matchedPath = state.fullPath ?? state.matchedLocation;
      final onboarding = matchedPath == RoutePaths.onboarding;

      if (!seen && !onboarding) {
        return RoutePaths.onboarding;
      }

      if (onboarding) {
        if (!seen) return null;
        return user == null
            ? RoutePaths.splash
            : AuthenticationDestination.forRole(user.role);
      }

      final isPublicRoute =
          matchedPath == RoutePaths.splash ||
          matchedPath == RoutePaths.login ||
          matchedPath == RoutePaths.register;
      if (user == null) {
        return isPublicRoute ? null : RoutePaths.login;
      }

      if (isPublicRoute) {
        return AuthenticationDestination.forRole(user.role);
      }

      final requiredRole = _requiredRoleForPath(matchedPath);
      if (requiredRole != null && user.role != requiredRole) {
        ref.read(guardMessageProvider.notifier).showAccessDenied();
        return AuthenticationDestination.forRole(user.role);
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: ErrorView(
        message: CommonStrings.pageNotFound(state.uri.toString()),
      ),
    ),
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
        builder: (context, state) => SplashLanguageScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.registration,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => RegistrationScreen(),
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
                builder: (context, state) => ListingsScreen(),
                routes: [
                  GoRoute(
                    path: _relativeRoutePath(
                      RoutePaths.listings,
                      RoutePaths.listingFilter,
                    ),
                    name: RouteNames.listingFilter,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ListingFilterScreen(),
                  ),
                  GoRoute(
                    path: _relativeRoutePath(
                      RoutePaths.listings,
                      RoutePaths.listingDetail,
                    ),
                    name: RouteNames.listingDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ListingDetailScreen(
                      listingId: state.pathParameters['id'] ?? '',
                    ),
                    routes: [
                      GoRoute(
                        path: _relativeRoutePath(
                          RoutePaths.listingDetail,
                          RoutePaths.listingEdit,
                        ),
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
                path: RoutePaths.listingMap,
                name: RouteNames.listingMap,
                builder: (context, state) => ListingMapScreen(),
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
                path: RoutePaths.viewingRequests,
                name: RouteNames.viewingRequests,
                builder: (context, state) => ViewingRequestsScreen(),
                routes: [
                  GoRoute(
                    path: _relativeRoutePath(
                      RoutePaths.viewingRequests,
                      RoutePaths.requestViewing,
                    ),
                    name: RouteNames.requestViewing,
                    builder: (context, state) => ViewingRequestsScreen(
                      listingId: state.pathParameters['listingId'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.myListings,
                name: RouteNames.myListings,
                builder: (context, state) => MyListingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.moderation,
                name: RouteNames.moderation,
                builder: (context, state) => ModerationScreen(),
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
                    path: _relativeRoutePath(
                      RoutePaths.profile,
                      RoutePaths.settings,
                    ),
                    name: RouteNames.settings,
                    builder: (context, state) => const SettingsScreen(),
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

UserRole? _requiredRoleForPath(String matchedPath) {
  if (_matchesRoute(matchedPath, RoutePaths.favorites) ||
      _matchesRoute(matchedPath, RoutePaths.report)) {
    return UserRole.tenant;
  }
  if (_matchesRoute(matchedPath, RoutePaths.post) ||
      _matchesRoute(matchedPath, RoutePaths.listingEdit) ||
      _matchesRoute(matchedPath, RoutePaths.myListings)) {
    return UserRole.owner;
  }
  if (_matchesRoute(matchedPath, RoutePaths.moderation)) {
    return UserRole.admin;
  }
  return null;
}

bool _matchesRoute(String matchedPath, String routePath) {
  final matchedSegments = Uri.parse(matchedPath).pathSegments;
  final routeSegments = Uri.parse(routePath).pathSegments;
  if (matchedSegments.length < routeSegments.length) return false;

  for (var index = 0; index < routeSegments.length; index++) {
    final routeSegment = routeSegments[index];
    if (routeSegment.startsWith(':')) continue;
    if (matchedSegments[index] != routeSegment) return false;
  }

  return true;
}

String _relativeRoutePath(String parentPath, String fullPath) =>
    fullPath.substring(parentPath.length + 1);
