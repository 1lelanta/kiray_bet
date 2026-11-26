import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/selected_language_provider.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';

void main() {
  late InMemoryAuthenticationRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = InMemoryAuthenticationRepository();
    container = ProviderContainer(
      overrides: [
        authenticationRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test(
    'current-user state changes on sign-in, profile update, and sign-out',
    () {
      expect(container.read(currentUserProvider), isNull);
      final user = container
          .read(currentUserProvider.notifier)
          .signIn(email: 'owner@kiray.demo', password: 'Demo1234');

      expect(user.id, DemoIds.owner);
      expect(container.read(currentUserProvider), user);

      final updated = container
          .read(currentUserProvider.notifier)
          .updateProfile(name: 'Updated Owner', phone: '0912345678');
      expect(container.read(currentUserProvider)?.name, 'Updated Owner');

      container.read(currentUserProvider.notifier).signOut();
      expect(container.read(currentUserProvider), isNull);
      expect(updated.phone, '0912345678');
    },
  );

  test('listing ID adapters follow the active tenant or owner role', () {
    expect(container.read(currentOwnerIdProvider), isNull);
    expect(container.read(currentTenantIdProvider), isNull);

    container
        .read(currentUserProvider.notifier)
        .signIn(email: 'owner@kiray.demo', password: 'Demo1234');
    expect(container.read(currentOwnerIdProvider), DemoIds.owner);
    expect(container.read(currentTenantIdProvider), isNull);

    container
        .read(currentUserProvider.notifier)
        .signIn(email: 'tenant@kiray.demo', password: 'Demo1234');
    expect(container.read(currentOwnerIdProvider), isNull);
    expect(container.read(currentTenantIdProvider), DemoIds.tenant);

    container.read(currentUserProvider.notifier).signOut();
    expect(container.read(currentOwnerIdProvider), isNull);
    expect(container.read(currentTenantIdProvider), isNull);
  });

  test('language selection persists on the signed-in profile', () {
    container
        .read(currentUserProvider.notifier)
        .signIn(email: 'tenant@kiray.demo', password: 'Demo1234');

    container.read(selectedLanguageProvider.notifier).setLanguage('am');
    expect(container.read(selectedLanguageProvider), 'am');
    expect(container.read(currentUserProvider)?.preferredLanguage, 'am');

    container.read(selectedLanguageProvider.notifier).setLanguage('en');
    expect(container.read(selectedLanguageProvider), 'en');
    expect(container.read(currentUserProvider)?.preferredLanguage, 'en');
  });

  test('rejects languages outside English and Amharic', () {
    expect(
      () => container.read(selectedLanguageProvider.notifier).setLanguage('fr'),
      throwsArgumentError,
    );
  });
}
