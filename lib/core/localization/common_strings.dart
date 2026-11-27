import 'l10n.dart';

abstract final class CommonStrings {
  static String get tryAgain => L10n.text('common.tryAgain', 'Try again');

  static String get accessDenied =>
      L10n.text('common.accessDenied', "You don't have access to that page.");

  static String pageNotFound(String uri) => L10n.text(
    'common.pageNotFound',
    'Page not found: {uri}',
  ).replaceAll('{uri}', uri);

  static String birrFor(String languageCode) =>
      L10n.textFor('common.birr', 'Birr', languageCode);

  static String perMonthFor(String languageCode) =>
      L10n.textFor('common.perMonth', '/ month', languageCode);
}

abstract final class NavigationStrings {
  static String get browse => L10n.text('navigation.browse', 'Browse');
  static String get favourites =>
      L10n.text('navigation.favourites', 'Favourites');
  static String get profileAndSettings =>
      L10n.text('navigation.profileAndSettings', 'Profile and Settings');
}
