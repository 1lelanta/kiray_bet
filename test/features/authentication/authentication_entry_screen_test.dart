import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/authentication/data/in_memory_authentication_repository.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/selected_language_provider.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/registration_screen.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/splash_language_screen.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listings_screen.dart';
import 'package:kiray_bet/features/onboarding/data/in_memory_onboarding_repository.dart';
import 'package:kiray_bet/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kiray_bet/features/profile/presentation/screens/my_listings_screen.dart';
import 'package:kiray_bet/features/report/presentation/screens/moderation_screen.dart';
void main() {
  testWidgets('language selection updates shared language state before login', (
    tester,
  ) async {
    await _openApp(tester);

    expect(find.byType(SplashLanguageScreen), findsOneWidget);
    await tester.tap(find.text(AuthenticationStrings.amharic));
    await tester.pumpAndSettle();
    expect(
      ProviderScope.containerOf(
        tester.element(find.byType(SplashLanguageScreen)),
      ).read(selectedLanguageProvider),
      'am',
    );

    await tester.tap(find.byKey(const Key('entry-continue')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('login validates required fields and rejects wrong credentials', (
    tester,
  ) async {
    await _openLogin(tester);

    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text(AuthenticationStrings.requiredEmail), findsOneWidget);
    expect(find.text(AuthenticationStrings.requiredPassword), findsOneWidget);

    await _enter(tester, AuthenticationStrings.email, 'tenant@kiray.demo');
    await _enter(tester, AuthenticationStrings.password, 'incorrect');
    await tester.ensureVisible(find.byKey(const Key('login-submit')));
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text(AuthenticationStrings.invalidCredentials), findsOneWidget);
  });

  testWidgets('tenant, owner, and admin sign in to their role destinations', (
    tester,
  ) async {
    await _openLogin(tester);
    await _enter(tester, AuthenticationStrings.email, 'tenant@kiray.demo');
    await _enter(tester, AuthenticationStrings.password, 'Demo1234');
    await _submitLogin(tester);
    expect(find.byType(ListingsScreen), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await _openLogin(tester);
    await _enter(tester, AuthenticationStrings.email, 'owner@kiray.demo');
    await _enter(tester, AuthenticationStrings.password, 'Demo1234');
    await _submitLogin(tester);
    expect(find.byType(MyListingsScreen), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await _openLogin(tester);
    await _enter(tester, AuthenticationStrings.email, 'admin@kiray.demo');
    await _enter(tester, AuthenticationStrings.password, 'Demo1234');
    await _submitLogin(tester);
    expect(find.byType(ModerationScreen), findsOneWidget);
  });

  testWidgets('registration validates inputs and prevents duplicate emails', (
    tester,
  ) async {
    await _openRegistration(tester);
    await tester.ensureVisible(find.byKey(const Key('registration-submit')));
    await tester.tap(find.byKey(const Key('registration-submit')));
    await tester.pumpAndSettle();
    expect(find.text(AuthenticationStrings.requiredName), findsOneWidget);
    expect(find.text(AuthenticationStrings.requiredEmail), findsOneWidget);
    expect(find.text(AuthenticationStrings.requiredPhone), findsOneWidget);
    expect(find.text(AuthenticationStrings.requiredPassword), findsOneWidget);

    await _enter(tester, AuthenticationStrings.name, 'Existing Tenant');
    await _enter(tester, AuthenticationStrings.email, 'tenant@kiray.demo');
    await _enter(tester, AuthenticationStrings.phone, '0912345678');
    await _enter(tester, AuthenticationStrings.password, 'secret1');
    await tester.ensureVisible(find.byKey(const Key('registration-submit')));
    await tester.tap(find.byKey(const Key('registration-submit')));
    await tester.pumpAndSettle();
    expect(find.text(AuthenticationStrings.duplicateEmail), findsOneWidget);
  });

  testWidgets('new owner registration opens My Listings', (tester) async {
    await _openRegistration(tester);
    await _enter(tester, AuthenticationStrings.name, 'New Owner');
    await _enter(tester, AuthenticationStrings.email, 'new-owner@example.com');
    await _enter(tester, AuthenticationStrings.phone, '+251912345678');
    await _enter(tester, AuthenticationStrings.password, 'secret1');
    await tester.ensureVisible(
      find.byKey( Key(AuthenticationStrings.role)),
    );
    await tester.tap(find.byKey( Key(AuthenticationStrings.role)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AuthenticationStrings.owner).last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('registration-submit')));
    await tester.tap(find.byKey(const Key('registration-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(MyListingsScreen), findsOneWidget);
  });
}

Future<void> _openApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(
          InMemoryOnboardingRepository(hasSeenOnboarding: true),
        ),
        authenticationRepositoryProvider.overrideWithValue(
          InMemoryAuthenticationRepository(),
        ),
      ],
      child: const KirayBetApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openLogin(WidgetTester tester) async {
  await _openApp(tester);
  await tester.tap(find.byKey(const Key('entry-continue')));
  await tester.pumpAndSettle();
  expect(find.byType(LoginScreen), findsOneWidget);
}

Future<void> _openRegistration(WidgetTester tester) async {
  await _openLogin(tester);
  await tester.tap(find.text(AuthenticationStrings.noAccount));
  await tester.pumpAndSettle();
  expect(find.byType(RegistrationScreen), findsOneWidget);
}

Future<void> _enter(WidgetTester tester, String label, String value) async {
  final field = find.byKey(Key(label));
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
}

Future<void> _submitLogin(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('login-submit')));
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}
