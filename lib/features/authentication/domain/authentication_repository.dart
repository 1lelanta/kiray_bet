import 'user_profile.dart';

abstract interface class AuthenticationRepository {
  UserProfile register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    String preferredLanguage = 'en',
  });

  UserProfile signIn({required String email, required String password});

  void signOut();

  UserProfile? getCurrentUser();

  UserProfile updateProfile({
    required String name,
    required String phone,
    String? preferredLanguage,
  });
}

class AuthenticationException implements Exception {
  const AuthenticationException(this.failure);

  final AuthenticationFailure failure;

  @override
  String toString() => failure.name;
}

enum AuthenticationFailure {
  duplicateEmail,
  invalidCredentials,
  signInRequired,
  unsupportedRole,
}
