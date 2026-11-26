import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/in_memory_authentication_repository.dart';
import '../../domain/authentication_repository.dart';
import '../../domain/user_profile.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => InMemoryAuthenticationRepository(),
);

final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserProfile?>(
  CurrentUserNotifier.new,
);

class CurrentUserNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() =>
      ref.read(authenticationRepositoryProvider).getCurrentUser();

  UserProfile signIn({required String email, required String password}) {
    final user = ref
        .read(authenticationRepositoryProvider)
        .signIn(email: email, password: password);
    state = user;
    return user;
  }

  UserProfile register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    String preferredLanguage = 'en',
  }) {
    final user = ref
        .read(authenticationRepositoryProvider)
        .register(
          name: name,
          email: email,
          phone: phone,
          password: password,
          role: role,
          preferredLanguage: preferredLanguage,
        );
    state = user;
    return user;
  }

  void signOut() {
    ref.read(authenticationRepositoryProvider).signOut();
    state = null;
  }

  UserProfile updateProfile({
    required String name,
    required String phone,
    String? preferredLanguage,
  }) {
    final user = ref
        .read(authenticationRepositoryProvider)
        .updateProfile(
          name: name,
          phone: phone,
          preferredLanguage: preferredLanguage,
        );
    state = user;
    return user;
  }
}
