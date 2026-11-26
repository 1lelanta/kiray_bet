String formatBirr(num amount, String languageCode) {
  final rounded = amount.round().toString();
  final grouped = rounded.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final label = languageCode.toLowerCase().startsWith('am') ? 'ብር' : 'Birr';
  return '$grouped $label / month';
}
