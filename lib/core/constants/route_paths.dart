/// Route path templates and helpers used by the application.
abstract final class RoutePaths {
  static const onboarding = '/onboarding';
  static const splash = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const moderation = '/moderation';
  static const listings = '/listings';
  static const listingDetail = '/listings/:id';
  static const listingFilter = '/listings/filter';
  static const listingMap = '/listings/map';
  static const listingEdit = '/listings/:id/edit';
  static const viewingRequests = '/viewing-requests';
  static const requestViewing = '/viewing-requests/:listingId';
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
  static String listingEditPath(String id) =>
      '/listings/${Uri.encodeComponent(id)}/edit';
  static String requestViewingPath(String listingId) =>
      '/viewing-requests/${Uri.encodeComponent(listingId)}';
  static String reportPath(String listingId) =>
      '/report/${Uri.encodeComponent(listingId)}';
}
