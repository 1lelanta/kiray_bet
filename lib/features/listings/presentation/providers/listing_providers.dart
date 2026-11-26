import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/listing.dart';
import '../../domain/listing_filter.dart';
import 'listing_data_providers.dart';

final allListingsProvider = FutureProvider<List<Listing>>(
  (ref) => ref.watch(listingRepositoryProvider).getAllListings(),
);

final listingByIdProvider = FutureProvider.family<Listing?, String>(
  (ref, id) => ref.watch(listingRepositoryProvider).getListingById(id),
);

class ListingFilterController extends Notifier<ListingFilter> {
  @override
  ListingFilter build() => const ListingFilter();

  void update(ListingFilter filter) => state = filter;
  void reset() => state = const ListingFilter();
}

final listingFilterProvider =
    NotifierProvider<ListingFilterController, ListingFilter>(
      ListingFilterController.new,
    );

final filteredListingsProvider = FutureProvider<List<Listing>>((ref) async {
  final listings = await ref.watch(allListingsProvider.future);
  final filter = ref.watch(listingFilterProvider);
  final result = listings.where((listing) {
    if (listing.status != ListingStatus.available) {
      return false;
    }
    if (filter.subCity != null && listing.subCity != filter.subCity) {
      return false;
    }
    if (filter.neighbourhood != null &&
        !listing.neighbourhood.toLowerCase().contains(
          filter.neighbourhood!.toLowerCase(),
        )) {
      return false;
    }
    if (filter.minRent != null && listing.monthlyRentBirr < filter.minRent!) {
      return false;
    }
    if (filter.maxRent != null && listing.monthlyRentBirr > filter.maxRent!) {
      return false;
    }
    if (filter.bedrooms != null && listing.bedrooms < filter.bedrooms!) {
      return false;
    }
    if (!listing.amenities.toSet().containsAll(filter.amenities)) {
      return false;
    }
    return true;
  }).toList();
  switch (filter.sortOrder) {
    case ListingSortOrder.newest:
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case ListingSortOrder.rentLowToHigh:
      result.sort((a, b) => a.monthlyRentBirr.compareTo(b.monthlyRentBirr));
    case ListingSortOrder.rentHighToLow:
      result.sort((a, b) => b.monthlyRentBirr.compareTo(a.monthlyRentBirr));
    case ListingSortOrder.bedroomsHighToLow:
      result.sort((a, b) => b.bedrooms.compareTo(a.bedrooms));
  }
  return result;
});

final currentOwnerListingsProvider = FutureProvider<List<Listing>>((ref) {
  final ownerId = ref.watch(currentOwnerIdProvider);
  if (ownerId == null) return Future.value(const <Listing>[]);
  return ref.watch(listingRepositoryProvider).getListingsByOwner(ownerId);
});
