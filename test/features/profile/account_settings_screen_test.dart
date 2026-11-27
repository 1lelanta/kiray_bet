import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/selected_language_provider.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:kiray_bet/features/listings/presentation/screens/viewing_requests_screen.dart';
import 'package:kiray_bet/features/profile/domain/app_settings.dart';
import 'package:kiray_bet/features/profile/presentation/settings_strings.dart';
import 'package:kiray_bet/features/profile/presentation/providers/app_settings_provider.dart';
import 'package:kiray_bet/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:kiray_bet/features/profile/presentation/screens/my_listings_screen.dart';

import 'settings_test_app.dart';

const _shortcutKeys = [
  'settings-my-listings',
  'settings-favorites',
  'settings-viewing-requests',
  'settings-moderation',
];

void main() {
  testWidgets('theme choice switches between system, light and dark', (
    tester,
  ) async {
    final container = await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'tenant@kiray.demo',
    );
    Brightness brightness() =>
        Theme.of(tester.element(find.byType(AccountSettingsScreen))).brightness;

    await tester.tap(find.text(SettingsStrings.themeDark));
    await tester.pumpAndSettle();
    expect(
      container.read(appSettingsProvider).themePreference,
      AppThemePreference.dark,
    );
    expect(brightness(), Brightness.dark);

    await tester.tap(find.text(SettingsStrings.themeLight));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);

    await tester.tap(find.text(SettingsStrings.themeSystem));
    await tester.pumpAndSettle();
    expect(
      container.read(appSettingsProvider).themePreference,
      AppThemePreference.system,
    );
  });

  testWidgets('language uses the shared provider and saves to the profile', (
    tester,
  ) async {
    final container = await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'tenant@kiray.demo',
    );
    final current = find.byKey(const Key('settings-current-language'));
    expect(
      find.descendant(
        of: current,
        matching: find.text(AuthenticationStrings.english),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text(AuthenticationStrings.amharic));
    await tester.pumpAndSettle();

    expect(container.read(selectedLanguageProvider), 'am');
    expect(container.read(currentUserProvider)?.preferredLanguage, 'am');
    expect(
      find.descendant(
        of: current,
        matching: find.text(AuthenticationStrings.amharic),
      ),
      findsOneWidget,
    );
  });

  testWidgets('notifications switch is stored in memory', (tester) async {
    final container = await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'tenant@kiray.demo',
    );
    expect(container.read(appSettingsProvider).notificationsEnabled, isTrue);

    await tester.tap(find.byKey(const Key('settings-notifications')));
    await tester.pumpAndSettle();
    expect(container.read(appSettingsProvider).notificationsEnabled, isFalse);

    await tester.tap(find.byKey(const Key('settings-notifications')));
    await tester.pumpAndSettle();
    expect(container.read(appSettingsProvider).notificationsEnabled, isTrue);
  });

  testWidgets('sign out asks for confirmation, signs out and opens Login', (
    tester,
  ) async {
    final container = await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'owner@kiray.demo',
    );

    await tester.tap(find.byKey(const Key('settings-sign-out')));
    await tester.pumpAndSettle();
    expect(find.text(SettingsStrings.signOutConfirmTitle), findsOneWidget);
    await tester.tap(find.text(SettingsStrings.cancel));
    await tester.pumpAndSettle();
    expect(container.read(currentUserProvider), isNotNull);
    expect(find.byType(AccountSettingsScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('settings-sign-out')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-sign-out-confirm')));
    await tester.pumpAndSettle();

    expect(container.read(currentUserProvider), isNull);
    expect(
      container.read(authenticationRepositoryProvider).getCurrentUser(),
      isNull,
    );
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('owners get a My Listings shortcut only', (tester) async {
    await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'owner@kiray.demo',
    );
    _expectOnlyShortcuts(['settings-my-listings']);

    await tester.tap(find.byKey(const Key('settings-my-listings')));
    await tester.pumpAndSettle();
    expect(find.byType(MyListingsScreen), findsOneWidget);
  });

  testWidgets('tenants get Favorites and Viewing Requests shortcuts', (
    tester,
  ) async {
    await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'tenant@kiray.demo',
    );
    _expectOnlyShortcuts(['settings-favorites', 'settings-viewing-requests']);

    await tester.tap(find.byKey(const Key('settings-viewing-requests')));
    await tester.pumpAndSettle();
    expect(find.byType(ViewingRequestsScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-favorites')));
    await tester.pumpAndSettle();
    expect(find.byType(FavoritesScreen), findsOneWidget);
  });

  testWidgets('admins get a Moderation shortcut only', (tester) async {
    await pumpSettingsTestApp(
      tester,
      initialLocation: RoutePaths.settings,
      signedInEmail: 'admin@kiray.demo',
    );
    _expectOnlyShortcuts(['settings-moderation']);

    await tester.tap(find.byKey(const Key('settings-moderation')));
    await tester.pumpAndSettle();
    expect(
      find.text(AuthenticationStrings.moderationUnavailable),
      findsOneWidget,
    );
  });

  testWidgets('signed-out users get no shortcuts and a Sign in entry', (
    tester,
  ) async {
    await pumpSettingsTestApp(tester, initialLocation: RoutePaths.settings);
    _expectOnlyShortcuts([]);
    expect(find.byKey(const Key('settings-sign-out')), findsNothing);

    await tester.tap(find.byKey(const Key('settings-sign-in')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

void _expectOnlyShortcuts(List<String> visible) {
  for (final key in _shortcutKeys) {
    expect(
      find.byKey(Key(key)),
      visible.contains(key) ? findsOneWidget : findsNothing,
      reason: key,
    );
  }
}
