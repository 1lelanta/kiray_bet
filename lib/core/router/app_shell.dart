import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiray_bet/features/compare/presentation/compare_strings.dart';
import 'package:kiray_bet/features/favorites/presentation/favorites_strings.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/profile/presentation/profile_strings.dart';

/// A Material 3 bottom navigation shell for the primary app branches.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_work_outlined),
            selectedIcon: const Icon(Icons.home_work),
            label: ListingStrings.navListings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.compare_arrows),
            label: CompareStrings.title,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: FavoritesStrings.title,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: ProfileStrings.profileTitle,
          ),
        ],
      ),
    );
  }
}
