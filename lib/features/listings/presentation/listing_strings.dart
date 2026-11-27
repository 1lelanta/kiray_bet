import '../../../core/localization/l10n.dart';
import '../domain/listing.dart';
import '../domain/viewing_request.dart';

abstract final class ListingStrings {
  static String get browse => L10n.text('listing.browse', "Browse rentals");
  static String get filter => L10n.text('listing.filter', "Filter and sort");
  static String get clear => L10n.text('listing.clear', "Reset filters");
  static String get empty => L10n.text('listing.empty', "No listings match these filters.");
  static String get error => L10n.text('listing.error', "Listings could not be loaded.");
  static String get notFound => L10n.text('listing.notFound', "This listing could not be found.");
  static String get bedrooms => L10n.text('listing.bedrooms', "Bedrooms");
  static String get bathrooms => L10n.text('listing.bathrooms', "Bathrooms");
  static String get subCity => L10n.text('listing.subCity', "Sub-city");
  static String get neighbourhood => L10n.text('listing.neighbourhood', "Neighbourhood");
  static String get minRent => L10n.text('listing.minRent', "Minimum rent");
  static String get maxRent => L10n.text('listing.maxRent', "Maximum rent");
  static String get amenities => L10n.text('listing.amenities', "Amenities");
  static String get apply => L10n.text('listing.apply', "Apply");
  static String get rentRangeError => L10n.text('listing.rentRangeError', "Minimum rent must not exceed maximum rent.");
  static String get details => L10n.text('listing.details', "Listing details");
  static String get description => L10n.text('listing.description', "Description");
  static String get location => L10n.text('listing.location', "Location");
  static String get deposit => L10n.text('listing.deposit', "Deposit");
  static String get ownerContact => L10n.text('listing.ownerContact', "Contact the owner");
  static String get contactPlaceholder => L10n.text('listing.contactPlaceholder', "Contact details available after sign in");
  static String get demoOwnerName => L10n.text('listing.demoOwnerName', "Demo property owner");
  static String get demoOwnerPhone => L10n.text('listing.demoOwnerPhone', "Phone: +251 900 000 000 (placeholder)");
  static String get requestViewing => L10n.text('listing.requestViewing', "Request viewing");
  static String get report => L10n.text('listing.report', "Report listing");
  static String get any => L10n.text('listing.any', "Any");
  static String get newest => L10n.text('listing.newest', "Newest");
  static String get rentLowHigh => L10n.text('listing.rentLowHigh', "Rent: low to high");
  static String get rentHighLow => L10n.text('listing.rentHighLow', "Rent: high to low");
  static String get bedroomsHighLow => L10n.text('listing.bedroomsHighLow', "Bedrooms: most first");
  static String get bedroomCount => L10n.text('listing.bedroomCount', "bedrooms");
  static String get bathroomCount => L10n.text('listing.bathroomCount', "bathrooms");
  static String get addListing => L10n.text('listing.addListing', "Add listing");
  static String get editListing => L10n.text('listing.editListing', "Edit listing");
  static String get title => L10n.text('listing.title', "Title");
  static String get monthlyRent => L10n.text('listing.monthlyRent', "Monthly rent (Birr)");
  static String get depositMonths => L10n.text('listing.depositMonths', "Deposit (months)");
  static String get area => L10n.text('listing.area', "Area (m²)");
  static String get address => L10n.text('listing.address', "Address");
  static String get status => L10n.text('listing.status', "Availability");
  static String get photos => L10n.text('listing.photos', "Photos");
  static String get addPhoto => L10n.text('listing.addPhoto', "Add placeholder photo");
  static String get saveListing => L10n.text('listing.saveListing', "Save listing");
  static String get required => L10n.text('listing.required', "This field is required.");
  static String get invalidNumber => L10n.text('listing.invalidNumber', "Enter a valid non-negative number.");
  static String get photoRequired => L10n.text('listing.photoRequired', "Add at least one photo placeholder.");
  static String get signInRequired => L10n.text('listing.signInRequired', "Sign in is required for this action.");
  static List<String> get subCities => L10n.list('listing.subCities', ["Bole", "Yeka", "Kirkos", "Lideta", "Arada", "Nifas Silk-Lafto", "Kolfe Keranio", "Gullele"]);
  static String get myListings => L10n.text('listing.myListings', "My listings");
  static String get noOwnerListings => L10n.text('listing.noOwnerListings', "You have not posted any listings yet.");
  static String get add => L10n.text('listing.add', "Add");
  static String get markAvailable => L10n.text('listing.markAvailable', "Mark available");
  static String get markRented => L10n.text('listing.markRented', "Mark rented");
  static String get statusAvailable => L10n.text('listing.statusAvailable', "Available");
  static String get statusRented => L10n.text('listing.statusRented', "Rented");
  static String get statusHidden => L10n.text('listing.statusHidden', "Hidden");
  static String listingStatusLabel(ListingStatus status) => switch (status) {
    ListingStatus.available => statusAvailable,
    ListingStatus.rented => statusRented,
    ListingStatus.hidden => statusHidden,
  };
  static String get requestPending => L10n.text('listing.requestPending', "Pending");
  static String get requestAccepted => L10n.text('listing.requestAccepted', "Accepted");
  static String get requestDeclined => L10n.text('listing.requestDeclined', "Declined");
  static String get requestCancelled => L10n.text('listing.requestCancelled', "Cancelled");
  static String viewingRequestStatusLabel(ViewingRequestStatus status) =>
      switch (status) {
        ViewingRequestStatus.pending => requestPending,
        ViewingRequestStatus.accepted => requestAccepted,
        ViewingRequestStatus.declined => requestDeclined,
        ViewingRequestStatus.cancelled => requestCancelled,
      };
  static String get latitude => L10n.text('listing.latitude', "Latitude");
  static String get longitude => L10n.text('listing.longitude', "Longitude");
  static String get coordinateError => L10n.text('listing.coordinateError', "Choose coordinates within Addis Ababa.");
  static String get optionalMessage => L10n.text('listing.optionalMessage', "Optional message");
  static String get messageHint => L10n.text('listing.messageHint', "Add a note for the owner");
  static String get skip => L10n.text('listing.skip', "Skip");
  static String get continueLabel => L10n.text('listing.continueLabel', "Continue");
  static String get map => L10n.text('listing.map', "Map");
  static String get selectedArea => L10n.text('listing.selectedArea', "Selected area");
  static String get nearMeLater => L10n.text('listing.nearMeLater', "Near me (coming later)");
  static List<String> get availableAmenities => L10n.list('listing.availableAmenities', ["Parking", "Water", "Electricity", "Security", "Balcony"]);
  static String get viewingRequests => L10n.text('listing.viewingRequests', "Viewing requests");
  static String get myRequests => L10n.text('listing.myRequests', "My requests");
  static String get requestsForMyListings => L10n.text('listing.requestsForMyListings', "Requests for my listings");
  static String get cancel => L10n.text('listing.cancel', "Cancel");
  static String get accept => L10n.text('listing.accept', "Accept");
  static String get decline => L10n.text('listing.decline', "Decline");
  static String get futureDateRequired => L10n.text('listing.futureDateRequired', "Choose a date and time in the future.");
  static String get requestUnavailable => L10n.text('listing.requestUnavailable', "Viewing requests are only available for listings you do not own that are available.");
  static String get navListings => L10n.text('listing.navListings', "Listings");
}
