import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/formatters/birr_formatter.dart';

void main() {
  test('formats amounts with grouping and locale label', () {
    expect(formatBirr(12000, 'en'), '12,000 Birr / month');
    expect(formatBirr(12000, 'am'), '12,000 ብር / month');
  });
}
