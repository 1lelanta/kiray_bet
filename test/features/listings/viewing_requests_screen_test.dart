import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/listings/data/in_memory_viewing_request_repository.dart';
import 'package:kiray_bet/features/listings/domain/viewing_request.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
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
        child: const MaterialApp(home: ViewingRequestsScreen()),
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
        child: const MaterialApp(home: ViewingRequestsScreen()),
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
        child: const MaterialApp(home: ViewingRequestsScreen()),
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
      const ProviderScope(
        child: MaterialApp(home: ViewingRequestsScreen(listingId: 'bole-01')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.requestViewing), findsOneWidget);
  });
}
