import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/domain/authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/selected_language_provider.dart';
import 'package:kiray_bet/features/profile/presentation/providers/profile_providers.dart';

void main() {
  late InMemoryAuthenticationRepository authentication;
  late ProviderContainer container;

  setUp(() {
    authentication = InMemoryAuthenticationRepository();
    container = ProviderContainer(
      overrides: [
        authenticationRepositoryProvider.overrideWithValue(authentication),
      ],
    );
    // profileUpdateProvider is auto-disposed; keep it alive for each test.
    container.listen(profileUpdateProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('profile repository reads the shared authentication repository', () {
    container
        .read(currentUserProvider.notifier)
        .signIn(
          email: 'owner@kiray.demo',
          password: InMemoryAuthenticationRepository.demoPassword,
        );

    expect(
      container.read(profileRepositoryProvider).getCurrentProfile(),
      container.read(currentUserProvider),
    );
  });

  test(
    'saving moves through loading to success and updates shared user state',
    () async {
      container
          .read(currentUserProvider.notifier)
          .signIn(
            email: 'tenant@kiray.demo',
            password: InMemoryAuthenticationRepository.demoPassword,
          );
      container.read(selectedLanguageProvider.notifier).setLanguage('am');
      expect(container.read(profileUpdateProvider).value, isNull);

      final saving = container
          .read(profileUpdateProvider.notifier)
          .save(name: 'Updated Tenant', phone: '+251911223344');
      expect(container.read(profileUpdateProvider).isLoading, isTrue);

      expect(await saving, isTrue);
      final state = container.read(profileUpdateProvider);
      expect(state.hasError, isFalse);
      expect(state.value?.name, 'Updated Tenant');

      final user = container.read(currentUserProvider);
      expect(user?.name, 'Updated Tenant');
      expect(user?.phone, '+251911223344');
      expect(user?.email, 'tenant@kiray.demo');
      expect(container.read(selectedLanguageProvider), 'am');
    },
  );

  test('saving while signed out reports an error state', () async {
    final saved = await container
        .read(profileUpdateProvider.notifier)
        .save(name: 'Nobody', phone: '0912345678');

    expect(saved, isFalse);
    final state = container.read(profileUpdateProvider);
    expect(state.hasError, isTrue);
    expect(
      (state.error! as AuthenticationException).failure,
      AuthenticationFailure.signInRequired,
    );
    expect(container.read(currentUserProvider), isNull);
  });
}
