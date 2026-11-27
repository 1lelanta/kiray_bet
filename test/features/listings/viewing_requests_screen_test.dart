import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/data/in_memory_viewing_request_repository.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';
import 'package:kiray_bet/features/listings/domain/viewing_request.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listing_detail_screen.dart';
import 'package:kiray_bet/features/listings/presentation/screens/viewing_requests_screen.dart';

void main() {
  testWidgets('tenant can cancel a pending viewing request', (tester) async {
    final repository = InMemoryViewingRequestRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => null),
          viewingRequestRepositoryProvider.overrideWith((ref) => repository),
        ],
        child:  MaterialApp(home: ViewingRequestsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.myRequests), findsOneWidget);
    await tester.tap(find.text(ListingStrings.cancel).first);
    await tester.pumpAndSettle();

    expect(
      (await repository.listByTenant(DemoIds.tenant)).first.status,
      ViewingRequestStatus.cancelled,
    );
  });

  testWidgets('owner can accept and decline pending requests', (tester) async {
    final repository = InMemoryViewingRequestRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => null),
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          viewingRequestRepositoryProvider.overrideWith((ref) => repository),
        ],
        child:  MaterialApp(home: ViewingRequestsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestsForMyListings), findsOneWidget);
    await tester.tap(find.text(ListingStrings.accept).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(ListingStrings.decline).first);
    await tester.pumpAndSettle();

    final requests = await repository.listByOwner(DemoIds.owner);
    expect(requests[0].status, ViewingRequestStatus.accepted);
    expect(requests[1].status, ViewingRequestStatus.declined);
  });

  testWidgets('hides both sections when the account has no requests', (
    tester,
  ) async {
    final repository = InMemoryViewingRequestRepository(requests: const []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          viewingRequestRepositoryProvider.overrideWith((ref) => repository),
        ],
        child:  MaterialApp(home: ViewingRequestsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.myRequests), findsNothing);
    expect(find.text(ListingStrings.requestsForMyListings), findsNothing);
  });

  testWidgets('shows create action only for a listing-specific request', (
    tester,
  ) async {
    await tester.pumpWidget(
       ProviderScope(
        child: MaterialApp(home: ViewingRequestsScreen(listingId: 'bole-01')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestViewing), findsOneWidget);
  });

  testWidgets('dismissing the optional message dialog cancels the request', (
    tester,
  ) async {
    final requests = InMemoryViewingRequestRepository(requests: []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => null),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(),
          ),
          viewingRequestRepositoryProvider.overrideWith((ref) => requests),
        ],
        child:  MaterialApp(
          home: ViewingRequestsScreen(listingId: 'bole-01'),
        ),
      ),
    );
    await _openMessageDialog(tester);

    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();

    expect(await requests.listByTenant(DemoIds.tenant), isEmpty);
  });

  testWidgets('skipping the optional message still creates the request', (
    tester,
  ) async {
    final requests = InMemoryViewingRequestRepository(requests: []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => null),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(),
          ),
          viewingRequestRepositoryProvider.overrideWith((ref) => requests),
        ],
        child:  MaterialApp(
          home: ViewingRequestsScreen(listingId: 'bole-01'),
        ),
      ),
    );
    await _openMessageDialog(tester);

    await tester.tap(find.text(ListingStrings.skip));
    await tester.pumpAndSettle();

    final created = await requests.listByTenant(DemoIds.tenant);
    expect(created, hasLength(1));
    expect(created.single.message, isNull);
  });

  testWidgets("rejects viewing requests for an owner's own listing", (
    tester,
  ) async {
    final requests = InMemoryViewingRequestRepository(requests: []);
    final listing = demoListings.first.copyWith(
      id: 'my-listing',
      ownerId: DemoIds.owner,
      status: ListingStatus.available,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(initialListings: [listing]),
          ),
          viewingRequestRepositoryProvider.overrideWith((ref) => requests),
        ],
        child:  MaterialApp(
          home: ViewingRequestsScreen(listingId: 'my-listing'),
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestUnavailable), findsOneWidget);
    expect(await requests.listByTenant(DemoIds.tenant), isEmpty);
  });

  testWidgets('rejects viewing requests for rented listings', (tester) async {
    final requests = InMemoryViewingRequestRepository(requests: []);
    final listing = demoListings.first.copyWith(
      id: 'rented-listing',
      ownerId: 'other-owner',
      status: ListingStatus.rented,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => null),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(initialListings: [listing]),
          ),
          viewingRequestRepositoryProvider.overrideWith((ref) => requests),
        ],
        child:  MaterialApp(
          home: ViewingRequestsScreen(listingId: 'rented-listing'),
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestUnavailable), findsOneWidget);
    expect(await requests.listByTenant(DemoIds.tenant), isEmpty);
  });

  testWidgets('detail screen hides request action for own listings', (
    tester,
  ) async {
    final listing = demoListings.first.copyWith(
      id: 'my-listing',
      ownerId: DemoIds.owner,
      status: ListingStatus.available,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(initialListings: [listing]),
          ),
        ],
        child:  MaterialApp(
          home: ListingDetailScreen(listingId: 'my-listing'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestViewing), findsNothing);
  });

  testWidgets('detail screen hides request action for rented listings', (
    tester,
  ) async {
    final listing = demoListings.first.copyWith(
      id: 'rented-listing',
      ownerId: 'other-owner',
      status: ListingStatus.rented,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTenantIdProvider.overrideWith((ref) => DemoIds.tenant),
          currentOwnerIdProvider.overrideWith((ref) => null),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(initialListings: [listing]),
          ),
        ],
        child:  MaterialApp(
          home: ListingDetailScreen(listingId: 'rented-listing'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestViewing), findsNothing);
  });
}

Future<void> _openMessageDialog(WidgetTester tester) async {
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK').last);
  await tester.pumpAndSettle();
  expect(find.byType(AlertDialog), findsOneWidget);
}
