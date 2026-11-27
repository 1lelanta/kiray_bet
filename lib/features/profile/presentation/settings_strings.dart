/// User-facing text for the Settings screen.
///
/// Follows the project's per-feature strings convention (see
/// `AuthenticationStrings` and `ListingStrings`). Shared labels such as
/// "Language", language names, "Sign in" and "Moderation" are reused from
/// `AuthenticationStrings` rather than duplicated here.
abstract final class SettingsStrings {
  static const settingsTitle = 'Settings';
  static const appearance = 'Appearance';
  static const themeSystem = 'System';
  static const themeLight = 'Light';
  static const themeDark = 'Dark';
  static const currentLanguage = 'Current language';
  static const notifications = 'Notifications';
  static const notificationsHint =
      'Saved for this session only. No notifications are sent yet.';
  static const shortcuts = 'Shortcuts';
  static const favorites = 'Favorites';
  static const account = 'Account';
  static const signOut = 'Sign out';
  static const signOutConfirmTitle = 'Sign out?';
  static const signOutConfirmMessage =
      'You will need to sign in again to manage your account.';
  static const cancel = 'Cancel';
}
