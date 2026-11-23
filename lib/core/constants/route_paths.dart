/// Route path templates and helpers used by the application.
abstract final class RoutePaths {
  static const onboarding = '/onboarding';
  static const listings = '/listings';
  static const listingDetail = '/listings/:id';
  static const compare = '/compare';
  static const compareResult = '/compare/result';
  static const favorites = '/favorites';
  static const report = '/report/:listingId';
  static const profile = '/profile';
  static const settings = '/profile/settings';
  static const myListings = '/profile/my-listings';
  static const post = '/post';

  static String listingDetailPath(String id) =>
      '/listings/${Uri.encodeComponent(id)}';

  static String reportPath(String listingId) =>
      '/report/${Uri.encodeComponent(listingId)}';
}
