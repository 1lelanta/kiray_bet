import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/domain/user_profile.dart';
import '../../features/authentication/presentation/providers/authentication_providers.dart';
import '../../features/listings/presentation/listing_strings.dart';
import '../../features/report/presentation/moderation_strings.dart';
import '../localization/common_strings.dart';

abstract final class _BranchIndexes {
  static const listings = 0;
  static const map = 1;
  static const favorites = 2;
  static const viewingRequests = 3;
  static const myListings = 4;
  static const moderation = 5;
  static const profile = 6;
}

class _AppDestination {
  const _AppDestination({
    required this.branchIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final int branchIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// A Material 3 bottom navigation shell for the primary app branches.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentUserProvider)?.role;
    final destinations = _destinationsFor(role);
    final selectedIndex = destinations.indexWhere(
      (destination) => destination.branchIndex == navigationShell.currentIndex,
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (index) {
          final branchIndex = destinations[index].branchIndex;
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }

  List<_AppDestination> _destinationsFor(UserRole? role) => switch (role) {
    UserRole.tenant => [
      _AppDestination(
        branchIndex: _BranchIndexes.listings,
        icon: Icons.home_work_outlined,
        selectedIcon: Icons.home_work,
        label: NavigationStrings.browse,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.map,
        icon: Icons.map_outlined,
        selectedIcon: Icons.map,
        label: ListingStrings.map,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.favorites,
        icon: Icons.favorite_border,
        selectedIcon: Icons.favorite,
        label: NavigationStrings.favourites,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.viewingRequests,
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: ListingStrings.viewingRequests,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.profile,
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: NavigationStrings.profileAndSettings,
      ),
    ],
    UserRole.owner => [
      _AppDestination(
        branchIndex: _BranchIndexes.myListings,
        icon: Icons.list_alt_outlined,
        selectedIcon: Icons.list_alt,
        label: ListingStrings.myListings,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.listings,
        icon: Icons.home_work_outlined,
        selectedIcon: Icons.home_work,
        label: NavigationStrings.browse,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.viewingRequests,
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: ListingStrings.viewingRequests,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.profile,
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: NavigationStrings.profileAndSettings,
      ),
    ],
    UserRole.admin => [
      _AppDestination(
        branchIndex: _BranchIndexes.moderation,
        icon: Icons.admin_panel_settings_outlined,
        selectedIcon: Icons.admin_panel_settings,
        label: ModerationStrings.title,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.listings,
        icon: Icons.home_work_outlined,
        selectedIcon: Icons.home_work,
        label: NavigationStrings.browse,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.profile,
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: NavigationStrings.profileAndSettings,
      ),
    ],
    null => [
      _AppDestination(
        branchIndex: _BranchIndexes.listings,
        icon: Icons.home_work_outlined,
        selectedIcon: Icons.home_work,
        label: NavigationStrings.browse,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.map,
        icon: Icons.map_outlined,
        selectedIcon: Icons.map,
        label: ListingStrings.map,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.favorites,
        icon: Icons.favorite_border,
        selectedIcon: Icons.favorite,
        label: NavigationStrings.favourites,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.viewingRequests,
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: ListingStrings.viewingRequests,
      ),
      _AppDestination(
        branchIndex: _BranchIndexes.profile,
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: NavigationStrings.profileAndSettings,
      ),
    ],
  };
}
