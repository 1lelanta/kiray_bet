import 'favorite.dart';

abstract interface class FavoritesRepository {
  void add(Favorite favorite);

  void remove({
    required String userId,
    required String listingId,
  });

  List<Favorite> listByUser(String userId);

  bool isFavorite({
    required String userId,
    required String listingId,
  });
}
