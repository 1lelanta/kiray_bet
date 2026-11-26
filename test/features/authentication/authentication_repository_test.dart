import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/domain/authentication_repository.dart';
import 'package:kiray_bet/features/authentication/domain/user_profile.dart';

void main() {
  late InMemoryAuthenticationRepository repository;

  setUp(() {
    repository = InMemoryAuthenticationRepository(
      clock: () => DateTime.utc(2026, 1, 1),
    );
  });

  test('seeds tenant, owner, and admin demo accounts with shared IDs', () {
    final tenant = repository.signIn(
      email: 'tenant@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    expect(tenant.id, DemoIds.tenant);
    expect(tenant.role, UserRole.tenant);

    final owner = repository.signIn(
      email: 'owner@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    expect(owner.id, DemoIds.owner);
    expect(owner.role, UserRole.owner);

    final admin = repository.signIn(
      email: 'admin@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    expect(admin.id, DemoIds.admin);
    expect(admin.role, UserRole.admin);
  });

  test('registers a tenant and signs them in', () {
    final user = repository.register(
      name: '  Hana Tesfaye ',
      email: 'HANA@example.com',
      phone: '0912345678',
      password: 'secret1',
      role: UserRole.tenant,
    );

    expect(user.name, 'Hana Tesfaye');
    expect(user.email, 'hana@example.com');
    expect(user.phone, '0912345678');
    expect(repository.getCurrentUser(), user);
  });

  test('rejects duplicate emails and public admin registration', () {
    expect(
      () => repository.register(
        name: 'Duplicate',
        email: ' TENANT@kiray.demo ',
        phone: '0912345678',
        password: 'secret1',
        role: UserRole.tenant,
      ),
      throwsA(
        isA<AuthenticationException>().having(
          (error) => error.failure,
          'failure',
          AuthenticationFailure.duplicateEmail,
        ),
      ),
    );
    expect(
      () => repository.register(
        name: 'Admin',
        email: 'new-admin@example.com',
        phone: '0912345678',
        password: 'secret1',
        role: UserRole.admin,
      ),
      throwsA(isA<AuthenticationException>()),
    );
  });

  test('rejects wrong credentials and signs out', () {
    expect(
      () =>
          repository.signIn(email: 'tenant@kiray.demo', password: 'incorrect'),
      throwsA(isA<AuthenticationException>()),
    );
    repository.signIn(
      email: 'tenant@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    repository.signOut();
    expect(repository.getCurrentUser(), isNull);
  });

  test('updates shared profile fields and preferred language', () {
    repository.signIn(
      email: 'owner@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    final updated = repository.updateProfile(
      name: 'Owner Updated',
      phone: '+251911111111',
      preferredLanguage: 'am',
    );

    expect(updated.name, 'Owner Updated');
    expect(updated.phone, '+251911111111');
    expect(updated.preferredLanguage, 'am');
    expect(repository.getCurrentUser(), updated);
  });
}
