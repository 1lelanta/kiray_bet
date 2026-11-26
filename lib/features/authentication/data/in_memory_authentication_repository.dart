import '../../../core/constants/demo_ids.dart';
import '../domain/authentication_repository.dart';
import '../domain/user_profile.dart';

class InMemoryAuthenticationRepository implements AuthenticationRepository {
  InMemoryAuthenticationRepository({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
    _addDemo(
      id: DemoIds.tenant,
      name: 'Demo Tenant',
      email: 'tenant@kiray.demo',
      phone: '+251900000001',
      role: UserRole.tenant,
    );
    _addDemo(
      id: DemoIds.owner,
      name: 'Demo Owner',
      email: 'owner@kiray.demo',
      phone: '+251900000002',
      role: UserRole.owner,
    );
    _addDemo(
      id: DemoIds.admin,
      name: 'Demo Admin',
      email: 'admin@kiray.demo',
      phone: '+251900000003',
      role: UserRole.admin,
    );
  }

  static const demoPassword = 'Demo1234';

  final DateTime Function() _clock;
  final Map<String, UserProfile> _usersByEmail = {};
  final Map<String, String> _passwordByEmail = {};
  UserProfile? _currentUser;
  int _nextUserId = 1;

  void _addDemo({
    required String id,
    required String name,
    required String email,
    required String phone,
    required UserRole role,
  }) {
    final normalizedEmail = _normalizeEmail(email);
    _usersByEmail[normalizedEmail] = UserProfile(
      id: id,
      name: name,
      email: normalizedEmail,
      phone: phone,
      role: role,
      preferredLanguage: 'en',
      createdAt: _clock(),
    );
    _passwordByEmail[normalizedEmail] = demoPassword;
  }

  @override
  UserProfile register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    String preferredLanguage = 'en',
  }) {
    if (role == UserRole.admin) {
      throw const AuthenticationException(
        AuthenticationFailure.unsupportedRole,
      );
    }
    final normalizedEmail = _normalizeEmail(email);
    if (_usersByEmail.containsKey(normalizedEmail)) {
      throw const AuthenticationException(AuthenticationFailure.duplicateEmail);
    }
    final user = UserProfile(
      id: 'user-${_nextUserId++}',
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      role: role,
      preferredLanguage: _normalizeLanguage(preferredLanguage),
      createdAt: _clock(),
    );
    _usersByEmail[normalizedEmail] = user;
    _passwordByEmail[normalizedEmail] = password;
    _currentUser = user;
    return user;
  }

  @override
  UserProfile signIn({required String email, required String password}) {
    final normalizedEmail = _normalizeEmail(email);
    final user = _usersByEmail[normalizedEmail];
    if (user == null || _passwordByEmail[normalizedEmail] != password) {
      throw const AuthenticationException(
        AuthenticationFailure.invalidCredentials,
      );
    }
    _currentUser = user;
    return user;
  }

  @override
  void signOut() => _currentUser = null;

  @override
  UserProfile? getCurrentUser() => _currentUser;

  @override
  UserProfile updateProfile({
    required String name,
    required String phone,
    String? preferredLanguage,
  }) {
    final current = _currentUser;
    if (current == null) {
      throw const AuthenticationException(AuthenticationFailure.signInRequired);
    }
    final updated = current.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      preferredLanguage: _normalizeLanguage(
        preferredLanguage ?? current.preferredLanguage,
      ),
    );
    _usersByEmail[_normalizeEmail(current.email)] = updated;
    _currentUser = updated;
    return updated;
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  static String _normalizeLanguage(String language) =>
      language == 'am' ? 'am' : 'en';
}
