import '../../../core/localization/l10n.dart';

abstract final class ReportStrings {
  static String get title => L10n.text('report.title', "Report listing");
  static String get chooseReason => L10n.text('report.chooseReason', "Why are you reporting this listing?");
  static String get fakeListing => L10n.text('report.fakeListing', "Fake listing");
  static String get alreadyRented => L10n.text('report.alreadyRented', "Already rented");
  static String get duplicate => L10n.text('report.duplicate', "Duplicate");
  static String get wrongInformation => L10n.text('report.wrongInformation', "Wrong information");
  static String get inappropriate => L10n.text('report.inappropriate', "Inappropriate content");
  static String get other => L10n.text('report.other', "Other");
  static String get otherDetails => L10n.text('report.otherDetails', "Explain the issue");
  static String get otherRequired => L10n.text('report.otherRequired', "Please explain the issue when selecting Other.");
  static String get reasonRequired => L10n.text('report.reasonRequired', "Please select a reason.");
  static String get submit => L10n.text('report.submit', "Submit report");
  static String get submitting => L10n.text('report.submitting', "Submitting report...");
  static String get success => L10n.text('report.success', "Your report has been submitted.");
  static String get duplicateReport => L10n.text('report.duplicateReport', "You have already reported this listing.");
  static String get signInRequired => L10n.text('report.signInRequired', "Please sign in to report a listing.");
  static String get error => L10n.text('report.error', "Could not submit your report. Please try again.");
  static String get listingNotFound => L10n.text('report.listingNotFound', "This listing could not be found.");
  static String get listingLabel => L10n.text('report.listingLabel', "Listing");
}
