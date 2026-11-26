import '../domain/user_profile.dart';
import '../../../core/constants/route_paths.dart';

abstract final class AuthenticationDestination {
  static String forRole(UserRole role) => switch (role) {
    UserRole.tenant => RoutePaths.listings,
    UserRole.owner => RoutePaths.myListings,
    UserRole.admin => RoutePaths.moderation,
  };
}
