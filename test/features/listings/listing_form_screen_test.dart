import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listing_detail_screen.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listing_form_screen.dart';

void main() {
  testWidgets('add form shows required-field validation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
        ],
        child: const MaterialApp(home: ListingFormScreen()),
      ),
    );

    await _scrollTo(tester, find.byKey(const Key(ListingStrings.saveListing)));
    await tester.tap(find.byKey(const Key(ListingStrings.saveListing)));
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.required), findsWidgets);
  });

  testWidgets('add form validates Addis coordinates and requires a photo', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
        ],
        child: const MaterialApp(home: ListingFormScreen()),
      ),
    );
    await _fillRequiredFields(tester);

    await _enterField(tester, ListingStrings.latitude, '10');
    await _scrollTo(tester, find.byKey(const Key(ListingStrings.saveListing)));
    await tester.tap(find.byKey(const Key(ListingStrings.saveListing)));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byKey(const Key(ListingStrings.latitude)));
    await tester.pumpAndSettle();
    expect(find.text(ListingStrings.coordinateError), findsOneWidget);

    await _enterField(tester, ListingStrings.latitude, '8.995');
    await _scrollTo(tester, find.byKey(const Key(ListingStrings.saveListing)));
    await tester.tap(find.byKey(const Key(ListingStrings.saveListing)));
    await tester.pumpAndSettle();
    expect(find.text(ListingStrings.photoRequired), findsOneWidget);
  });

  testWidgets('add form creates a placeholder photo reference', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
        ],
        child: const MaterialApp(home: ListingFormScreen()),
      ),
    );
    await _fillRequiredFields(tester);
    final addPhotoButton = find.byKey(const Key(ListingStrings.addPhoto));
    await _scrollTo(tester, addPhotoButton);
    await tester.tap(addPhotoButton);
    await tester.pumpAndSettle();

    expect(find.text('${ListingStrings.photos}: 1'), findsOneWidget);
  });

  testWidgets('edit form shows not-found for an unknown listing ID', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
        ],
        child: const MaterialApp(
          home: ListingFormScreen(listingId: 'unknown-listing'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.notFound), findsOneWidget);
  });

  testWidgets('owner edit form loads an existing listing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
        ],
        child: const MaterialApp(home: ListingFormScreen(listingId: 'bole-02')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.editListing), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key(ListingStrings.title)));
    final titleField = tester.widget<TextFormField>(
      find.byKey(const Key(ListingStrings.title)),
    );
    expect(titleField.controller?.text, '3 bedroom home in Old Airport');
    await _scrollTo(tester, find.byKey(const Key(ListingStrings.status)));
    expect(find.text(ListingStrings.status), findsOneWidget);
  });

  testWidgets('saving an edit refreshes the listing detail data', (
    tester,
  ) async {
    final repository = InMemoryListingRepository();
    final router = GoRouter(
      initialLocation: '/listings/bole-02/edit',
      routes: [
        GoRoute(
          path: '/listings/:id',
          builder: (context, state) =>
              ListingDetailScreen(listingId: state.pathParameters['id']!),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  ListingFormScreen(listingId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => DemoIds.owner),
          listingRepositoryProvider.overrideWith((ref) => repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.byKey(const Key(ListingStrings.title)));
    await tester.enterText(
      find.byKey(const Key(ListingStrings.title)),
      'Updated listing title',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byKey(const Key(ListingStrings.saveListing)));
    await tester.tap(find.byKey(const Key(ListingStrings.saveListing)));
    await tester.pumpAndSettle();

    expect(find.text('Updated listing title'), findsOneWidget);
    expect(
      (await repository.getListingById('bole-02'))?.title,
      'Updated listing title',
    );
  });

  testWidgets('owner cannot edit another owner listing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOwnerIdProvider.overrideWith((ref) => 'different-owner'),
          listingRepositoryProvider.overrideWith(
            (ref) => InMemoryListingRepository(),
          ),
        ],
        child: const MaterialApp(home: ListingFormScreen(listingId: 'bole-02')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ListingStrings.signInRequired), findsOneWidget);
    expect(find.text(ListingStrings.saveListing), findsNothing);
  });
}

Future<void> _fillRequiredFields(WidgetTester tester) async {
  const values = <String, String>{
    ListingStrings.title: 'Sunny apartment',
    ListingStrings.monthlyRent: '24000',
    ListingStrings.depositMonths: '2',
    ListingStrings.bedrooms: '2',
    ListingStrings.bathrooms: '1',
    ListingStrings.area: '72',
    ListingStrings.neighbourhood: 'Bole Atlas',
    ListingStrings.address: 'Bole Atlas, Addis Ababa',
  };
  for (final entry in values.entries) {
    await _enterField(tester, entry.key, entry.value);
  }
}

Future<void> _enterField(
  WidgetTester tester,
  String label,
  String value,
) async {
  final field = find.byKey(Key(label));
  await tester.scrollUntilVisible(
    field,
    250,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.enterText(field, value);
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}
