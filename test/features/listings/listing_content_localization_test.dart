import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/localization/l10n.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listing_filter_screen.dart';
import 'package:kiray_bet/features/listings/presentation/widgets/listing_card.dart';

void main() {
  tearDown(() => L10n.languageCode = 'en');

  testWidgets(
    'Amharic listing cards localize seed content but preserve owner text',
    (tester) async {
      L10n.languageCode = 'am';
      final seed = demoListings.first;
      final ownerCreated = seed.copyWith(
        id: 'owner-created-listing',
        title: 'My custom home',
        description: 'A description entered by the owner.',
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('am'),
          home: ListView(
            children: [
              ListingCard(listing: seed),
              ListingCard(listing: ownerCreated),
            ],
          ),
        ),
      );

      expect(find.text('በቦሌ አትላስ የሚገኝ 2 መኝታ ክፍል ያለው ቤት'), findsOneWidget);
      expect(find.text('ቦሌ · ቦሌ አትላስ'), findsNWidgets(2));
      expect(find.text('My custom home'), findsOneWidget);
      expect(find.text('2 bedroom home in Bole Atlas'), findsNothing);
      expect(
        L10n.localizedListingDescription(seed),
        'በአካባቢው ሱቆች እና የህዝብ መጓጓዣ አቅራቢያ የሚገኝ ብሩህ የኪራይ ቤት።',
      );
      expect(
        L10n.localizedListingDescription(ownerCreated),
        'A description entered by the owner.',
      );
      expect(L10n.localizedSubCity('Unknown sub-city'), 'Unknown sub-city');
    },
  );

  testWidgets('Amharic filter labels preserve English sub-city values', (
    tester,
  ) async {
    L10n.languageCode = 'am';

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('am'),
          home: const ListingFilterScreen(),
        ),
      ),
    );

    final subCityDropdown = tester.widget<DropdownButton<String>>(
      find.byType(DropdownButton<String>).first,
    );
    final boleOption = subCityDropdown.items!.singleWhere(
      (item) => item.value == 'Bole',
    );

    expect(boleOption.value, 'Bole');
    expect((boleOption.child as Text).data, 'ቦሌ');
  });
}
