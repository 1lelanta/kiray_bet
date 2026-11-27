import '../../../core/localization/l10n.dart';

abstract final class ModerationStrings {
  static String get title => L10n.text('moderation.title', "Moderation");
  static String get accessDenied => L10n.text('moderation.accessDenied', "Admin access is required.");
  static String get open => L10n.text('moderation.open', "Open");
  static String get resolved => L10n.text('moderation.resolved', "Resolved");
  static String get noOpenReports => L10n.text('moderation.noOpenReports', "There are no open reports.");
  static String get noResolvedReports => L10n.text('moderation.noResolvedReports', "There are no resolved reports.");
  static String get listingNotFound => L10n.text('moderation.listingNotFound', "The reported listing could not be found.");
  static String get hideListing => L10n.text('moderation.hideListing', "Hide listing");
  static String get resolve => L10n.text('moderation.resolve', "Resolve");
  static String get resolveWithoutHiding => L10n.text('moderation.resolveWithoutHiding', "Resolve without hiding");
  static String get hideSuccess => L10n.text('moderation.hideSuccess', "Listing hidden and report resolved.");
  static String get resolveSuccess => L10n.text('moderation.resolveSuccess', "Report resolved.");
  static String get actionError => L10n.text('moderation.actionError', "Could not complete this action.");
  static String get listingIdLabel => L10n.text('moderation.listingIdLabel', "Listing ID");
  static String get reporterIdLabel => L10n.text('moderation.reporterIdLabel', "Reporter ID");
  static String get reasonLabel => L10n.text('moderation.reasonLabel', "Reason");
  static String get submittedLabel => L10n.text('moderation.submittedLabel', "Submitted");
}
