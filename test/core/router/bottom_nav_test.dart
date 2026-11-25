import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/compare/presentation/screens/compare_selection_screen.dart';
import 'package:kiray_bet/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listings_screen.dart';
import 'package:kiray_bet/features/profile/presentation/screens/profile_screen.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  testWidgets('bottom navigation switches primary branches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(
            InMemoryOnboardingRepository(hasSeenOnboarding: true),
          ),
        ],
        child: const KirayBetApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListingsScreen), findsOneWidget);

    final navigationBar = find.byType(NavigationBar);
    await tester.tap(
      find.descendant(of: navigationBar, matching: find.text('Compare')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CompareSelectionScreen), findsOneWidget);

    await tester.tap(
      find.descendant(of: navigationBar, matching: find.text('Favorites')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FavoritesScreen), findsOneWidget);

    await tester.tap(
      find.descendant(of: navigationBar, matching: find.text('Profile')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);

    await tester.tap(
      find.descendant(of: navigationBar, matching: find.text('Listings')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ListingsScreen), findsOneWidget);
  });
}
