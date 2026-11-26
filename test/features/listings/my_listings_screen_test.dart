import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/profile/presentation/screens/my_listings_screen.dart';

void main() {
  testWidgets('owner can change one of their listings to rented', (
    tester,
  ) async {
    final repository = InMemoryListingRepository();
    final listing = (await repository.getListingsByOwner(DemoIds.owner)).first;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          listingRepositoryProvider.overrideWith((ref) => repository),
        ],
        child: const MaterialApp(home: MyListingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(listing.title), findsOneWidget);
    await tester.tap(find.byType(PopupMenuButton<ListingStatus>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(ListingStrings.markRented));
    await tester.pumpAndSettle();

    expect(
      (await repository.getListingById(listing.id))?.status,
      ListingStatus.rented,
    );
    await tester.tap(find.byType(PopupMenuButton<ListingStatus>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(ListingStrings.markAvailable));
    await tester.pumpAndSettle();
    expect(
      (await repository.getListingById(listing.id))?.status,
      ListingStatus.available,
    );
  });

  testWidgets('owner sees an empty state when they have no listings', (
    tester,
  ) async {
    final repository = InMemoryListingRepository(initialListings: const []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          listingRepositoryProvider.overrideWith((ref) => repository),
        ],
        child: const MaterialApp(home: MyListingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.noOwnerListings), findsOneWidget);
  });
}
