import '../../../core/localization/l10n.dart';

abstract final class AuthenticationStrings {
  static String get appName => L10n.text('authentication.appName', "Kiray Bet");
  static String get splashTitle => L10n.text('authentication.splashTitle', "Find your next home");
  static String get splashMessage => L10n.text('authentication.splashMessage', "Choose a language to continue.");
  static String get continueLabel => L10n.text('authentication.continueLabel', "Continue");
  static String get language => L10n.text('authentication.language', "Language");
  static String get english => L10n.text('authentication.english', "English");
  static String get amharic => L10n.text('authentication.amharic', "አማርኛ");
  static String get loginTitle => L10n.text('authentication.loginTitle', "Sign in");
  static String get registerTitle => L10n.text('authentication.registerTitle', "Create an account");
  static String get name => L10n.text('authentication.name', "Full name");
  static String get email => L10n.text('authentication.email', "Email");
  static String get phone => L10n.text('authentication.phone', "Phone");
  static String get password => L10n.text('authentication.password', "Password");
  static String get role => L10n.text('authentication.role', "I am looking to");
  static String get tenant => L10n.text('authentication.tenant', "Rent a home");
  static String get owner => L10n.text('authentication.owner', "List a home");
  static String get signIn => L10n.text('authentication.signIn', "Sign in");
  static String get createAccount => L10n.text('authentication.createAccount', "Create account");
  static String get noAccount => L10n.text('authentication.noAccount', "New to Kiray Bet? Create an account");
  static String get haveAccount => L10n.text('authentication.haveAccount', "Already have an account? Sign in");
  static String get requiredName => L10n.text('authentication.requiredName', "Enter your name.");
  static String get requiredEmail => L10n.text('authentication.requiredEmail', "Enter your email address.");
  static String get invalidEmail => L10n.text('authentication.invalidEmail', "Enter a valid email address.");
  static String get requiredPassword => L10n.text('authentication.requiredPassword', "Enter a password.");
  static String get shortPassword => L10n.text('authentication.shortPassword', "Use at least 6 characters.");
  static String get requiredPhone => L10n.text('authentication.requiredPhone', "Enter your phone number.");
  static String get invalidPhone => L10n.text('authentication.invalidPhone', "Use +2519XXXXXXXX or 09XXXXXXXX.");
  static String get duplicateEmail => L10n.text('authentication.duplicateEmail', "An account with this email already exists.");
  static String get invalidCredentials => L10n.text('authentication.invalidCredentials', "Email or password is incorrect.");
  static String get signInRequired => L10n.text('authentication.signInRequired', "Sign in to update your profile.");
  static String get unsupportedRole => L10n.text('authentication.unsupportedRole', "Choose a tenant or owner account.");
  static String get moderationTitle => L10n.text('authentication.moderationTitle', "Moderation");
  static String get moderationUnavailable => L10n.text('authentication.moderationUnavailable', "Moderation tools will be available soon.");
  static String get loginUnavailable => L10n.text('authentication.loginUnavailable', "Sign in will be available soon.");
  static String get registrationUnavailable => L10n.text('authentication.registrationUnavailable', "Registration will be available soon.");
}
