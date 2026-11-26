/// User-facing text for the Profile and Settings screens.
///
/// Follows the project's per-feature strings convention (see
/// `AuthenticationStrings` and `ListingStrings`). Shared labels such as
/// field names, validation messages and language names are reused from
/// `AuthenticationStrings` rather than duplicated here.
abstract final class ProfileStrings {
  // Profile
  static const profileTitle = 'Profile';
  static const accountDetails = 'Account details';
  static const editDetails = 'Edit details';
  static const role = 'Role';
  static const roleTenant = 'Tenant';
  static const roleOwner = 'Owner';
  static const roleAdmin = 'Administrator';
  static const readOnlyHint = 'Managed by your account and cannot be changed.';
  static const saveChanges = 'Save changes';
  static const saving = 'Saving…';
  static const updateSuccess = 'Profile updated.';
  static const updateFailed = 'Your profile could not be saved. Try again.';
  static const signedOutTitle = 'You are not signed in';
  static const signedOutMessage = 'Sign in to view and edit your profile.';
  static const openSettings = 'Settings';

  // Settings
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
  static const signIn = 'Sign in';
  static const signOut = 'Sign out';
  static const signOutConfirmTitle = 'Sign out?';
  static const signOutConfirmMessage =
      'You will need to sign in again to manage your account.';
  static const cancel = 'Cancel';
}
