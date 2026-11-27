import 'l10n.dart';

abstract final class CommonStrings {
  static String get tryAgain => L10n.text('common.tryAgain', 'Try again');

  static String pageNotFound(String uri) => L10n.text(
    'common.pageNotFound',
    'Page not found: {uri}',
  ).replaceAll('{uri}', uri);

  static String birrFor(String languageCode) =>
      L10n.textFor('common.birr', 'Birr', languageCode);

  static String perMonthFor(String languageCode) =>
      L10n.textFor('common.perMonth', '/ month', languageCode);
}
