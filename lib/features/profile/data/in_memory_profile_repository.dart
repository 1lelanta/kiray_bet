import '../../authentication/domain/authentication_repository.dart';
import '../../authentication/domain/user_profile.dart';
import '../domain/profile_repository.dart';

/// In-memory [ProfileRepository] that delegates to the shared
/// [AuthenticationRepository], so there is a single source of user data.
class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository(this._authentication);

  final AuthenticationRepository _authentication;

  @override
  UserProfile? getCurrentProfile() => _authentication.getCurrentUser();

  @override
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
  }) async => _authentication.updateProfile(name: name, phone: phone);
}
