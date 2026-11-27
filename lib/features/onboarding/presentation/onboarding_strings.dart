import '../../../core/localization/l10n.dart';

abstract final class OnboardingStrings {
  static String get title => L10n.text('onboarding.title', 'Onboarding');
  static String get findHomeTitle =>
      L10n.text('onboarding.findHomeTitle', 'Find a home in Addis');
  static String get findHomeText =>
      L10n.text('onboarding.findHomeText', 'Browse rental listings near you.');
  static String get compareTitle =>
      L10n.text('onboarding.compareTitle', 'Compare side by side');
  static String get compareText => L10n.text(
    'onboarding.compareText',
    'Spot the overpriced options before you decide.',
  );
  static String get reportTitle =>
      L10n.text('onboarding.reportTitle', 'Report scams and save favorites');
  static String get reportText => L10n.text(
    'onboarding.reportText',
    'Keep useful listings close and help others stay safe.',
  );
  static String get skip => L10n.text('onboarding.skip', 'Skip');
  static String get next => L10n.text('onboarding.next', 'Next');
  static String get getStarted =>
      L10n.text('onboarding.getStarted', 'Get started');
}
