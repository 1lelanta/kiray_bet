import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/domain/user_profile.dart';
import '../../../authentication/presentation/providers/authentication_providers.dart';
import '../../data/in_memory_profile_repository.dart';
import '../../domain/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) =>
      InMemoryProfileRepository(ref.watch(authenticationRepositoryProvider)),
);

/// Status of the most recent profile save.
///
/// `AsyncData(null)` means nothing has been saved yet, `AsyncLoading` means a
/// save is in progress, `AsyncData(user)` means the last save succeeded and
/// `AsyncError` means it failed.
final profileUpdateProvider =
    NotifierProvider.autoDispose<
      ProfileUpdateNotifier,
      AsyncValue<UserProfile?>
    >(ProfileUpdateNotifier.new);

class ProfileUpdateNotifier extends Notifier<AsyncValue<UserProfile?>> {
  @override
  AsyncValue<UserProfile?> build() => const AsyncData(null);

  /// Saves the new name and phone number. Returns `true` on success.
  ///
  /// On success the shared [currentUserProvider] is refreshed from the
  /// authentication repository so every screen sees the new details.
  Future<bool> save({required String name, required String phone}) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    try {
      final user = await ref
          .read(profileRepositoryProvider)
          .updateProfile(name: name, phone: phone);
      ref.invalidate(currentUserProvider);
      if (ref.mounted) state = AsyncData(user);
      return true;
    } catch (error, stackTrace) {
      if (ref.mounted) state = AsyncError(error, stackTrace);
      return false;
    }
  }
}
