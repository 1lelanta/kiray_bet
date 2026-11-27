import '../../../core/localization/l10n.dart';

abstract final class CompareStrings {
  static String get title => L10n.text('compare.title', 'Compare');
  static String get resultTitle =>
      L10n.text('compare.resultTitle', 'Compare Result');
}
