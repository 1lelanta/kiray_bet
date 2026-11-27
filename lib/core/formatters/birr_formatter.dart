import '../localization/common_strings.dart';

String formatBirr(num amount, String languageCode) {
  final rounded = amount.round().toString();
  final grouped = rounded.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final label = CommonStrings.birrFor(languageCode);
  return '$grouped $label ${CommonStrings.perMonthFor(languageCode)}';
}
