import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/formatters/birr_formatter.dart';
import 'package:kiray_bet/core/localization/l10n.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/report/presentation/report_strings.dart';

void main() {
  tearDown(() => L10n.languageCode = 'en');

  test('English translations are selected', () {
    L10n.languageCode = 'en';
    expect(AuthenticationStrings.loginTitle, 'Sign in');
    expect(ListingStrings.browse, 'Browse rentals');
    expect(ReportStrings.submit, 'Submit report');
    expect(formatBirr(12000, 'en'), '12,000 Birr / month');
  });

  test('Amharic translations are selected', () {
    L10n.languageCode = 'am';
    expect(AuthenticationStrings.loginTitle, 'ይግቡ');
    expect(ListingStrings.browse, 'የቤት ኪራይ ይፈልጉ');
    expect(ReportStrings.submit, 'ሪፖርት አስገባ');
    expect(formatBirr(12000, 'am'), '12,000 ብር / month');
  });

  test('Amharic sub-cities and amenities are translated', () {
    L10n.languageCode = 'am';
    expect(ListingStrings.subCities.first, 'ቦሌ');
    expect(ListingStrings.availableAmenities.first, 'ፓርኪንግ');
  });
}
