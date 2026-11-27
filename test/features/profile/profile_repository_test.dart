import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/demo_ids.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/domain/authentication_repository.dart';
import 'package:kiray_bet/features/authentication/domain/user_profile.dart';
import 'package:kiray_bet/features/profile/data/in_memory_profile_repository.dart';

void main() {
  late InMemoryAuthenticationRepository authentication;
  late InMemoryProfileRepository repository;

  setUp(() {
    authentication = InMemoryAuthenticationRepository();
    repository = InMemoryProfileRepository(authentication);
  });

  test('current profile is null until a user signs in', () {
    expect(repository.getCurrentProfile(), isNull);

    authentication.signIn(
      email: 'owner@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );

    expect(repository.getCurrentProfile()?.id, DemoIds.owner);
  });

  test('update delegates to authentication and keeps email and role', () async {
    final before = authentication.signIn(
      email: 'tenant@kiray.demo',
      password: InMemoryAuthenticationRepository.demoPassword,
    );
    authentication.updateProfile(
      name: before.name,
      phone: before.phone,
      preferredLanguage: 'am',
    );

    final updated = await repository.updateProfile(
      name: '  Abebe Kebede ',
      phone: ' 0912345678 ',
    );

    expect(updated.name, 'Abebe Kebede');
    expect(updated.phone, '0912345678');
    expect(updated.id, before.id);
    expect(updated.email, before.email);
    expect(updated.role, UserRole.tenant);
    expect(updated.preferredLanguage, 'am');
    expect(authentication.getCurrentUser(), updated);
    expect(repository.getCurrentProfile(), updated);
  });

  test('update without a signed-in user fails with signInRequired', () {
    expect(
      repository.updateProfile(name: 'Nobody', phone: '0912345678'),
      throwsA(
        isA<AuthenticationException>().having(
          (exception) => exception.failure,
          'failure',
          AuthenticationFailure.signInRequired,
        ),
      ),
    );
  });
}
