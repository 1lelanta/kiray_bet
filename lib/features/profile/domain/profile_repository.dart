import '../../authentication/domain/user_profile.dart';

/// Reads and edits the signed-in user's profile.
///
/// Implementations reuse the shared [UserProfile] model. Only the name and
/// phone number are editable; email and role are owned by authentication.
abstract interface class ProfileRepository {
  /// The signed-in user's profile, or `null` when nobody is signed in.
  UserProfile? getCurrentProfile();

  /// Saves a new name and phone number for the signed-in user.
  ///
  /// Throws an `AuthenticationException` with
  /// `AuthenticationFailure.signInRequired` when nobody is signed in.
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
  });
}
