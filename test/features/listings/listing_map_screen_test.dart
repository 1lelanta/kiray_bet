import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listing_map_screen.dart';

void main() {
  testWidgets('map shows available listings for the selected sub-city', (
    tester,
  ) async {
    final repository = InMemoryListingRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listingRepositoryProvider.overrideWith((ref) => repository),
        ],
        child:  MaterialApp(home: ListingMapScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 bedroom home in Bole Atlas'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yeka').last);
    await tester.pumpAndSettle();

    expect(find.text('1 bedroom home in Kotebe'), findsOneWidget);
    expect(find.text('2 bedroom home in Bole Atlas'), findsNothing);
    expect(find.text(ListingStrings.nearMeLater), findsOneWidget);
  });

  testWidgets(
    'map displays an empty state when the repository has no listings',
    (tester) async {
      final repository = InMemoryListingRepository(initialListings: const []);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            listingRepositoryProvider.overrideWith((ref) => repository),
          ],
          child:  MaterialApp(home: ListingMapScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(ListingStrings.empty), findsOneWidget);
    },
  );
}
