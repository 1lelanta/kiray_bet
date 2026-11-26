import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_filter.freezed.dart';

enum ListingSortOrder {
  newest,
  rentLowToHigh,
  rentHighToLow,
  bedroomsHighToLow,
}

@freezed
abstract class ListingFilter with _$ListingFilter {
  const ListingFilter._();

  const factory ListingFilter({
    String? subCity,
    String? neighbourhood,
    int? minRent,
    int? maxRent,
    int? bedrooms,
    @Default(<String>[]) List<String> amenities,
    @Default(ListingSortOrder.newest) ListingSortOrder sortOrder,
  }) = _ListingFilter;

  int get activeCount =>
      [
        subCity,
        neighbourhood,
        minRent,
        maxRent,
        bedrooms,
      ].where((value) => value != null).length +
      amenities.length;
}
