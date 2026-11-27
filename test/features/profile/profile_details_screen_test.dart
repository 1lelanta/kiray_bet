import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/features/authentication/domain/user_profile.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/profile/domain/profile_repository.dart';
import 'package:kiray_bet/features/profile/presentation/profile_strings.dart';
import 'package:kiray_bet/features/profile/presentation/providers/profile_providers.dart';
import 'package:kiray_bet/features/profile/presentation/screens/settings_screen.dart';

import 'profile_test_app.dart';

void main() {
  testWidgets('signed-out users see a sign-in prompt that opens Login', (
    tester,
  ) async {
    await pumpProfileTestApp(tester, initialLocation: RoutePaths.profile);

    expect(find.byKey(const Key('profile-signed-out')), findsOneWidget);
    expect(find.text(ProfileStrings.signedOutTitle), findsOneWidget);
    expect(find.byKey(const Key('profile-save')), findsNothing);

    await tester.tap(find.text(ProfileStrings.signIn));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('shows name, email, phone and role with email and role locked', (
    tester,
  ) async {
    await pumpProfileTestApp(
      tester,
      initialLocation: RoutePaths.profile,
      signedInEmail: 'owner@kiray.demo',
    );

    expect(find.text('Demo Owner'), findsWidgets);
    expect(find.text('owner@kiray.demo'), findsOneWidget);
    expect(find.text('+251900000002'), findsOneWidget);
    expect(find.text(ProfileStrings.roleOwner), findsWidgets);

    TextField field(String key) => tester.widget<TextField>(
      find.descendant(
        of: find.byKey(Key(key)),
        matching: find.byType(TextField),
      ),
    );
    expect(field('profile-email').readOnly, isTrue);
    expect(field('profile-role').readOnly, isTrue);
    expect(field('profile-name').readOnly, isFalse);
    expect(field('profile-phone').readOnly, isFalse);
  });

  testWidgets('invalid name and phone are rejected and nothing is saved', (
    tester,
  ) async {
    final container = await pumpProfileTestApp(
      tester,
      initialLocation: RoutePaths.profile,
      signedInEmail: 'tenant@kiray.demo',
    );

    await tester.enterText(find.byKey(const Key('profile-name')), '   ');
    await tester.enterText(find.byKey(const Key('profile-phone')), '12345');
    await tester.tap(find.byKey(const Key('profile-save')));
    await tester.pumpAndSettle();

    expect(find.text(AuthenticationStrings.requiredName), findsOneWidget);
    expect(find.text(AuthenticationStrings.invalidPhone), findsOneWidget);
    expect(container.read(currentUserProvider)?.name, 'Demo Tenant');
    expect(container.read(currentUserProvider)?.phone, '+251900000001');

    await tester.enterText(find.byKey(const Key('profile-phone')), '');
    await tester.tap(find.byKey(const Key('profile-save')));
    await tester.pumpAndSettle();
    expect(find.text(AuthenticationStrings.requiredPhone), findsOneWidget);
  });

  testWidgets('a valid edit updates shared user state and confirms success', (
    tester,
  ) async {
    final container = await pumpProfileTestApp(
      tester,
      initialLocation: RoutePaths.profile,
      signedInEmail: 'tenant@kiray.demo',
    );

    await tester.enterText(
      find.byKey(const Key('profile-name')),
      'Hana Tesfaye',
    );
    await tester.enterText(
      find.byKey(const Key('profile-phone')),
      '0911223344',
    );
    await tester.tap(find.byKey(const Key('profile-save')));
    await tester.pumpAndSettle();

    expect(find.text(ProfileStrings.updateSuccess), findsOneWidget);
    expect(find.byKey(const Key('profile-error')), findsNothing);
    final user = container.read(currentUserProvider)!;
    expect(user.name, 'Hana Tesfaye');
    expect(user.phone, '0911223344');
    expect(user.email, 'tenant@kiray.demo');
    expect(user.role, UserRole.tenant);
    expect(
      tester.widget<Text>(find.byKey(const Key('profile-header-name'))).data,
      'Hana Tesfaye',
    );
  });

  testWidgets('shows a loading state while saving, then an error on failure', (
    tester,
  ) async {
    final repository = _ControlledProfileRepository();
    await pumpProfileTestApp(
      tester,
      initialLocation: RoutePaths.profile,
      signedInEmail: 'tenant@kiray.demo',
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.tap(find.byKey(const Key('profile-save')));
    await tester.pump();

    expect(find.text(ProfileStrings.saving), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('profile-save')))
          .onPressed,
      isNull,
    );

    repository.pending!.completeError(StateError('network down'));
    await tester.pumpAndSettle();

    expect(find.text(ProfileStrings.saving), findsNothing);
    expect(find.byKey(const Key('profile-error')), findsOneWidget);
    expect(find.text(ProfileStrings.updateFailed), findsOneWidget);
    expect(find.text(ProfileStrings.updateSuccess), findsNothing);
  });

  testWidgets('the settings button opens the Settings screen', (tester) async {
    await pumpProfileTestApp(
      tester,
      initialLocation: RoutePaths.profile,
      signedInEmail: 'tenant@kiray.demo',
    );

    await tester.tap(find.byKey(const Key('profile-open-settings')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });
}

/// A repository whose save only finishes when the test completes it.
class _ControlledProfileRepository implements ProfileRepository {
  Completer<UserProfile>? pending;

  @override
  UserProfile? getCurrentProfile() => null;

  @override
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
  }) => (pending = Completer<UserProfile>()).future;
}
