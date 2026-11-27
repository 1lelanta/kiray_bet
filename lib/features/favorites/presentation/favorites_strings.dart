import '../../../core/localization/l10n.dart';

abstract final class FavoritesStrings {
  static String get title => L10n.text('favorites.title', 'Favorites');
  static String get signInPrompt =>
      L10n.text('favorites.signInPrompt', 'Sign in to view favorites');
  static String get loadError =>
      L10n.text('favorites.loadError', 'Could not load favorites');
  static String get emptyTitle =>
      L10n.text('favorites.emptyTitle', 'No favorites yet');
  static String get emptyMessage => L10n.text(
    'favorites.emptyMessage',
    'Save listings you like to find them here.',
  );
  static String get addTooltip =>
      L10n.text('favorites.addTooltip', 'Add to favorites');
  static String get removeTooltip =>
      L10n.text('favorites.removeTooltip', 'Remove from favorites');
}
