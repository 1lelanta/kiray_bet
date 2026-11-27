import '../../../core/localization/l10n.dart';

abstract final class SettingsStrings {
  static String get settingsTitle =>
      L10n.text('settings.settingsTitle', 'Settings');
  static String get appearance =>
      L10n.text('settings.appearance', 'Appearance');
  static String get themeSystem => L10n.text('settings.themeSystem', 'System');
  static String get themeLight => L10n.text('settings.themeLight', 'Light');
  static String get themeDark => L10n.text('settings.themeDark', 'Dark');
  static String get currentLanguage =>
      L10n.text('settings.currentLanguage', 'Current language');
  static String get notifications =>
      L10n.text('settings.notifications', 'Notifications');
  static String get notificationsHint => L10n.text(
    'settings.notificationsHint',
    'Saved for this session only. No notifications are sent yet.',
  );
  static String get shortcuts => L10n.text('settings.shortcuts', 'Shortcuts');
  static String get favorites => L10n.text('settings.favorites', 'Favorites');
  static String get account => L10n.text('settings.account', 'Account');
  static String get signOut => L10n.text('settings.signOut', 'Sign out');
  static String get signOutConfirmTitle =>
      L10n.text('settings.signOutConfirmTitle', 'Sign out?');
  static String get signOutConfirmMessage => L10n.text(
    'settings.signOutConfirmMessage',
    'You will need to sign in again to manage your account.',
  );
  static String get cancel => L10n.text('settings.cancel', 'Cancel');
}
