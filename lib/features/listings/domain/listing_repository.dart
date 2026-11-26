import 'listing.dart';

abstract interface class ListingRepository {
  Future<List<Listing>> getAllListings();
  Future<Listing?> getListingById(String id);
  Future<List<Listing>> getListingsByOwner(String ownerId);
  Future<void> addListing(Listing listing);
  Future<void> updateListing(Listing listing);
  Future<Listing> updateListingStatus(String listingId, ListingStatus status);
}
