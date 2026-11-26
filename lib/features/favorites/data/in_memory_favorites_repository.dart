import '../domain/favorite.dart';
import '../domain/favorites_repository.dart';

class InMemoryFavoritesRepository implements FavoritesRepository {
  InMemoryFavoritesRepository({List<Favorite>? initialFavorites})
      : _favorites = [...?initialFavorites];

  final List<Favorite> _favorites;

  @override
  void add(Favorite favorite) {
    if (isFavorite(
      userId: favorite.userId,
      listingId: favorite.listingId,
    )) {
      return;
    }

    _favorites.add(favorite);
  }

  @override
  void remove({
    required String userId,
    required String listingId,
  }) {
    _favorites.removeWhere(
      (favorite) =>
          favorite.userId == userId &&
          favorite.listingId == listingId,
    );
  }

  @override
  List<Favorite> listByUser(String userId) {
    return List.unmodifiable(
      _favorites.where((favorite) => favorite.userId == userId),
    );
  }

  @override
  bool isFavorite({
    required String userId,
    required String listingId,
  }) {
    return _favorites.any(
      (favorite) =>
          favorite.userId == userId &&
          favorite.listingId == listingId,
    );
  }
}
