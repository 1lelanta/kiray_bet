import '../../../core/localization/l10n.dart';

abstract final class ProfileStrings {
  static String get profileTitle =>
      L10n.text('profile.profileTitle', 'Profile');
  static String get accountDetails =>
      L10n.text('profile.accountDetails', 'Account details');
  static String get editDetails =>
      L10n.text('profile.editDetails', 'Edit details');
  static String get role => L10n.text('profile.role', 'Role');
  static String get roleTenant => L10n.text('profile.roleTenant', 'Tenant');
  static String get roleOwner => L10n.text('profile.roleOwner', 'Owner');
  static String get roleAdmin =>
      L10n.text('profile.roleAdmin', 'Administrator');
  static String get readOnlyHint => L10n.text(
    'profile.readOnlyHint',
    'Managed by your account and cannot be changed.',
  );
  static String get saveChanges =>
      L10n.text('profile.saveChanges', 'Save changes');
  static String get saving => L10n.text('profile.saving', 'Saving…');
  static String get updateSuccess =>
      L10n.text('profile.updateSuccess', 'Profile updated.');
  static String get updateFailed => L10n.text(
    'profile.updateFailed',
    'Your profile could not be saved. Try again.',
  );
  static String get signedOutTitle =>
      L10n.text('profile.signedOutTitle', 'You are not signed in');
  static String get signedOutMessage => L10n.text(
    'profile.signedOutMessage',
    'Sign in to view and edit your profile.',
  );
  static String get signIn => L10n.text('profile.signIn', 'Sign in');
  static String get openSettings =>
      L10n.text('profile.openSettings', 'Settings');
}
