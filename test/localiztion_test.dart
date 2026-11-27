import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/formatters/birr_formatter.dart';
import 'package:kiray_bet/core/localization/common_strings.dart';
import 'package:kiray_bet/core/localization/l10n.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';
import 'package:kiray_bet/features/listings/domain/viewing_request.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/profile/presentation/profile_strings.dart';
import 'package:kiray_bet/features/profile/presentation/settings_strings.dart';
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
    expect(formatBirr(12000, 'am'), '12,000 ብር / በወር');
    expect(CommonStrings.pageNotFound('/missing'), 'ገጹ አልተገኘም፦ /missing');
    expect(ListingStrings.listingStatusLabel(ListingStatus.rented), 'ተከራይቷል');
    expect(
      ListingStrings.viewingRequestStatusLabel(ViewingRequestStatus.pending),
      'በመጠባበቅ ላይ',
    );
  });

  test('Profile and Settings use their provided Amharic values', () {
    L10n.languageCode = 'am';
    expect(
      [
        ProfileStrings.profileTitle,
        ProfileStrings.accountDetails,
        ProfileStrings.editDetails,
        ProfileStrings.role,
        ProfileStrings.roleTenant,
        ProfileStrings.roleOwner,
        ProfileStrings.roleAdmin,
        ProfileStrings.readOnlyHint,
        ProfileStrings.saveChanges,
        ProfileStrings.saving,
        ProfileStrings.updateSuccess,
        ProfileStrings.updateFailed,
        ProfileStrings.signedOutTitle,
        ProfileStrings.signedOutMessage,
        ProfileStrings.signIn,
        ProfileStrings.openSettings,
      ],
      [
        'መገለጫ',
        'የመለያ ዝርዝሮች',
        'ዝርዝሮችን አርም',
        'ሚና',
        'ተከራይ',
        'ባለቤት',
        'አስተዳዳሪ',
        'ይህ መረጃ ሊቀየር አይችልም',
        'ለውጦችን አስቀምጥ',
        'በማስቀመጥ ላይ…',
        'መገለጫዎ በተሳካ ሁኔታ ተዘምኗል',
        'ማዘመን አልተሳካም',
        'አልገቡም',
        'መገለጫዎን ለማየት እባክዎ ይግቡ',
        'ግባ',
        'ቅንብሮችን ክፈት',
      ],
    );
    expect(
      [
        SettingsStrings.settingsTitle,
        SettingsStrings.appearance,
        SettingsStrings.themeSystem,
        SettingsStrings.themeLight,
        SettingsStrings.themeDark,
        SettingsStrings.currentLanguage,
        SettingsStrings.notifications,
        SettingsStrings.notificationsHint,
        SettingsStrings.shortcuts,
        SettingsStrings.favorites,
        SettingsStrings.account,
        SettingsStrings.signOut,
        SettingsStrings.signOutConfirmTitle,
        SettingsStrings.signOutConfirmMessage,
        SettingsStrings.cancel,
      ],
      [
        'ቅንብሮች',
        'መልክ',
        'የስርዓት',
        'ብሩህ',
        'ጨለማ',
        'የአሁኑ ቋንቋ',
        'ማሳወቂያዎች',
        'የመተግበሪያ ማሳወቂያዎችን ተቀበል',
        'አቋራጮች',
        'ተወዳጆች',
        'መለያ',
        'ውጣ',
        'መውጣት ይፈልጋሉ?',
        'ከመለያዎ ለመውጣት እርግጠኛ ነዎት?',
        'ይቅር',
      ],
    );
  });

  test('Amharic sub-cities and amenities are translated', () {
    L10n.languageCode = 'am';
    expect(ListingStrings.subCities.first, 'ቦሌ');
    expect(ListingStrings.availableAmenities.first, 'ፓርኪንግ');
  });
}
