import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/domain/listing_filter.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_providers.dart';

void main() {
  test(
    'available results can filter and sort, and reset to no filters',
    () async {
      final container = ProviderContainer(
        overrides: [
          listingRepositoryProvider.overrideWithValue(
            InMemoryListingRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      final initial = await container.read(filteredListingsProvider.future);
      expect(initial, isNotEmpty);
      expect(initial.every((item) => item.status.name == 'available'), isTrue);

      container
          .read(listingFilterProvider.notifier)
          .update(
            const ListingFilter(
              subCity: 'Bole',
              sortOrder: ListingSortOrder.rentLowToHigh,
            ),
          );
      final filtered = await container.read(filteredListingsProvider.future);
      expect(filtered, isNotEmpty);
      expect(filtered.every((item) => item.subCity == 'Bole'), isTrue);
      expect(
        filtered.first.monthlyRentBirr,
        lessThanOrEqualTo(filtered.last.monthlyRentBirr),
      );

      container.read(listingFilterProvider.notifier).reset();
      expect(container.read(listingFilterProvider).activeCount, 0);
    },
  );
}
