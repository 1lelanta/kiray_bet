import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing.freezed.dart';
part 'listing.g.dart';

enum ListingStatus { available, rented, hidden }

@freezed
abstract class Listing with _$Listing {
  const factory Listing({
    required String id,
    required String ownerId,
    required String title,
    required String description,
    required int monthlyRentBirr,
    required int depositMonths,
    required int bedrooms,
    required int bathrooms,
    required double areaSqm,
    required String subCity,
    required String neighbourhood,
    required String address,
    required double latitude,
    required double longitude,
    @Default(<String>[]) List<String> amenities,
    @Default(<String>[]) List<String> photoUrls,
    @Default(ListingStatus.available) ListingStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Listing;

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);
}
