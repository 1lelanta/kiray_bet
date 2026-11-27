import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/authentication/presentation/providers/authentication_providers.dart';
import '../../../listings/domain/listing.dart';
import '../../../listings/presentation/providers/listing_data_providers.dart';
import '../../data/in_memory_favorites_repository.dart';
import '../../domain/favorite.dart';
import '../../domain/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => InMemoryFavoritesRepository(),
);

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<Favorite>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends Notifier<List<Favorite>> {
  @override
  List<Favorite> build() {
    final user = ref.watch(currentUserProvider);

    if (user == null) return [];

    return ref
        .read(favoritesRepositoryProvider)
        .listByUser(user.id);
  }

  void toggle(String listingId) {
    final user = ref.read(currentUserProvider);

    if (user == null) return;

    final repository = ref.read(favoritesRepositoryProvider);

    if (repository.isFavorite(
      userId: user.id,
      listingId: listingId,
    )) {
      repository.remove(
        userId: user.id,
        listingId: listingId,
      );
    } else {
      repository.add(
        Favorite(
          userId: user.id,
          listingId: listingId,
          createdAt: DateTime.now(),
        ),
      );
    }

    state = repository.listByUser(user.id);
  }

  bool isFavorite(String listingId) {
    final user = ref.read(currentUserProvider);

    if (user == null) return false;

    return ref.read(favoritesRepositoryProvider).isFavorite(
      userId: user.id,
      listingId: listingId,
    );
  }

  void remove(String listingId) {
    final user = ref.read(currentUserProvider);

    if (user == null) return;

    ref.read(favoritesRepositoryProvider).remove(
      userId: user.id,
      listingId: listingId,
    );

    state = ref
        .read(favoritesRepositoryProvider)
        .listByUser(user.id);
  }
}

final favoriteListingsProvider = FutureProvider<List<Listing>>(
  (ref) async {
    final favorites = ref.watch(favoritesProvider);

    final repository = ref.watch(listingRepositoryProvider);

    final listings = <Listing>[];

    for (final favorite in favorites) {
      final listing = await repository.getListingById(
        favorite.listingId,
      );

      if (listing != null) {
        listings.add(listing);
      }
    }

    return listings;
  },
);
