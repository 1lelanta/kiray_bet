import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/compare/presentation/screens/compare_result_screen.dart';
import '../../features/compare/presentation/screens/compare_selection_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/listings/presentation/screens/listing_detail_screen.dart';
import '../../features/listings/presentation/screens/listings_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/my_listings_screen.dart';
import '../../features/profile/presentation/screens/post_listing_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/report/presentation/screens/report_scam_screen.dart';
import '../constants/route_names.dart';
import '../constants/route_paths.dart';
import '../widgets/error_view.dart';
import 'app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.listings,
    // TODO: Onboarding redirect comes in the next PR.
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
        path: RoutePaths.report,
        name: RouteNames.report,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            ReportScamScreen(listingId: state.pathParameters['listingId']!),
      ),
      GoRoute(
        path: RoutePaths.post,
        name: RouteNames.post,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PostListingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
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
                    path: ':id',
                    name: RouteNames.listingDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ListingDetailScreen(
                      listingId: state.pathParameters['id']!,
                    ),
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
