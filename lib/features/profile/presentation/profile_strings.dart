/// User-facing text for the Profile screen.
///
/// Follows the project's per-feature strings convention (see
/// `AuthenticationStrings` and `ListingStrings`). Shared labels such as
/// field names and validation messages are reused from
/// `AuthenticationStrings` rather than duplicated here.
abstract final class ProfileStrings {
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
  static const signIn = 'Sign in';
  static const openSettings = 'Settings';
}
