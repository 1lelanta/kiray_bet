import '../domain/listing.dart';
import '../domain/listing_repository.dart';

import 'package:kiray_bet/core/constants/demo_ids.dart';

class InMemoryListingRepository implements ListingRepository {
  InMemoryListingRepository({List<Listing>? initialListings})
    : _listings = [...(initialListings ?? demoListings)];

  final List<Listing> _listings;

  @override
  Future<List<Listing>> getAllListings() async => List.unmodifiable(_listings);

  @override
  Future<Listing?> getListingById(String id) async {
    for (final listing in _listings) {
      if (listing.id == id) return listing;
    }
    return null;
  }

  @override
  Future<List<Listing>> getListingsByOwner(String ownerId) async =>
      List.unmodifiable(_listings.where((item) => item.ownerId == ownerId));

  @override
  Future<void> addListing(Listing listing) async {
    if (_listings.any((item) => item.id == listing.id)) {
      throw StateError('A listing with ID ${listing.id} already exists.');
    }
    _listings.add(listing);
  }

  @override
  Future<void> updateListing(Listing listing) async {
    final index = _listings.indexWhere((item) => item.id == listing.id);
    if (index < 0) throw StateError('Listing ${listing.id} was not found.');
    _listings[index] = listing;
  }

  @override
  Future<Listing> updateListingStatus(
    String listingId,
    ListingStatus status,
  ) async {
    final index = _listings.indexWhere((item) => item.id == listingId);
    if (index < 0) throw StateError('Listing $listingId was not found.');
    final updated = _listings[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    _listings[index] = updated;
    return updated;
  }
}

final _seedDate = DateTime.utc(2025, 1, 1);

final demoListings = <Listing>[
  _listing(
    'bole-01',
    'Bole',
    'Bole Atlas',
    32000,
    2,
    2,
    88,
    8.995,
    38.789,
    true,
  ),
  _listing(
    'bole-02',
    'Bole',
    'Old Airport',
    48000,
    3,
    2,
    120,
    8.989,
    38.781,
    true,
  ),
  _listing(
    'yeka-01',
    'Yeka',
    'Megenagna',
    26000,
    2,
    1,
    74,
    9.024,
    38.805,
    true,
  ),
  _listing('yeka-02', 'Yeka', 'Kotebe', 18000, 1, 1, 52, 9.036, 38.851, true),
  _listing(
    'kirkos-01',
    'Kirkos',
    'Kazanchis',
    42000,
    3,
    2,
    110,
    9.012,
    38.766,
    true,
  ),
  _listing(
    'kirkos-02',
    'Kirkos',
    'Mexico',
    15000,
    1,
    1,
    48,
    8.999,
    38.745,
    false,
  ),
  _listing(
    'lideta-01',
    'Lideta',
    'Lideta',
    12000,
    1,
    1,
    45,
    9.010,
    38.731,
    true,
  ),
  _listing('arada-01', 'Arada', 'Piassa', 22000, 2, 1, 70, 9.035, 38.752, true),
  _listing(
    'arada-02',
    'Arada',
    'Arat Kilo',
    36000,
    3,
    2,
    102,
    9.033,
    38.761,
    true,
  ),
  _listing(
    'nifas-01',
    'Nifas Silk-Lafto',
    'Lafto',
    14000,
    2,
    1,
    64,
    8.965,
    38.708,
    true,
  ),
  _listing(
    'nifas-02',
    'Nifas Silk-Lafto',
    'Jemo',
    24000,
    2,
    2,
    80,
    8.944,
    38.699,
    false,
    status: ListingStatus.hidden,
  ),
  _listing(
    'lideta-02',
    'Lideta',
    'Tegbare-id',
    16000,
    2,
    1,
    58,
    9.005,
    38.724,
    false,
  ),
  _listing(
    'kolfe-01',
    'Kolfe Keranio',
    'Kolfe',
    9000,
    1,
    1,
    38,
    9.018,
    38.690,
    true,
  ),
  _listing(
    'kolfe-02',
    'Kolfe Keranio',
    'Alem Bank',
    17000,
    2,
    1,
    65,
    9.030,
    38.679,
    true,
  ),
  _listing(
    'gullele-01',
    'Gullele',
    'Entoto',
    11000,
    1,
    1,
    42,
    9.071,
    38.758,
    true,
  ),
  _listing('bole-03', 'Bole', 'Gerji', 58000, 4, 3, 165, 8.990, 38.830, true),
  _listing('yeka-03', 'Yeka', 'Shola', 29000, 2, 2, 82, 9.030, 38.795, true),
];

Listing _listing(
  String id,
  String subCity,
  String neighbourhood,
  int rent,
  int bedrooms,
  int bathrooms,
  double area,
  double lat,
  double lng,
  bool available, {
  ListingStatus? status,
}) {
  final ownerId = int.parse(id.replaceAll(RegExp(r'\D'), '')).isEven
      ? DemoIds.owner
      : 'demo-owner-${int.parse(id.replaceAll(RegExp(r'\D'), '')) % 5 + 2}';
  return Listing(
    id: id,
    ownerId: ownerId,
    title: '$bedrooms bedroom home in $neighbourhood',
    description: 'Bright rental home near local shops and public transport.',
    monthlyRentBirr: rent,
    depositMonths: 2,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    areaSqm: area,
    subCity: subCity,
    neighbourhood: neighbourhood,
    address: '$neighbourhood, Addis Ababa',
    latitude: lat,
    longitude: lng,
    amenities: const ['Water', 'Electricity'],
    photoUrls: const ['placeholder://listing'],
    status:
        status ?? (available ? ListingStatus.available : ListingStatus.rented),
    createdAt: _seedDate,
    updatedAt: _seedDate,
  );
}
