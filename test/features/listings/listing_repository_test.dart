import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';

void main() {
  late InMemoryListingRepository repository;

  setUp(() => repository = InMemoryListingRepository());

  test('seeds at least fifteen listings across eight sub-cities', () async {
    final listings = await repository.getAllListings();
    expect(listings.length, greaterThanOrEqualTo(15));
    expect(
      listings.map((item) => item.subCity).toSet().length,
      greaterThanOrEqualTo(8),
    );
    expect(
      listings.where((item) => item.status == ListingStatus.available),
      isNotEmpty,
    );
    expect(
      listings.where((item) => item.status == ListingStatus.rented).length,
      greaterThanOrEqualTo(2),
    );
    expect(
      listings.where((item) => item.status == ListingStatus.hidden),
      isNotEmpty,
    );
  });

  test('adds and updates a listing', () async {
    final emptyRepository = InMemoryListingRepository(initialListings: []);
    final listing = demoListings.first.copyWith(id: 'test-listing-1');

    await emptyRepository.addListing(listing);
    expect(await emptyRepository.getListingById(listing.id), listing);

    final updated = listing.copyWith(title: 'Updated rental');
    await emptyRepository.updateListing(updated);
    expect(
      (await emptyRepository.getListingById(listing.id))?.title,
      'Updated rental',
    );
    await expectLater(
      emptyRepository.updateListing(updated.copyWith(id: 'unknown')),
      throwsStateError,
    );
  });

  test('looks up, filters by owner, and changes status', () async {
    final listing = await repository.getListingById('bole-01');
    expect(listing, isNotNull);
    expect(await repository.getListingById('unknown'), isNull);
    final ownerListings = await repository.getListingsByOwner('demo-owner-1');
    expect(ownerListings, isNotEmpty);
    expect(
      ownerListings.every((item) => item.ownerId == 'demo-owner-1'),
      isTrue,
    );
    final changed = await repository.updateListingStatus(
      'bole-01',
      ListingStatus.rented,
    );
    expect(changed.status, ListingStatus.rented);
    await expectLater(
      repository.updateListingStatus('unknown', ListingStatus.hidden),
      throwsStateError,
    );
  });
}
