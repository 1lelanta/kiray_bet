
import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/favorites/data/in_memory_favorites_repository.dart';
import 'package:kiray_bet/features/favorites/domain/favorite.dart';

void main() {
  late InMemoryFavoritesRepository repository;

  setUp(() {
    repository = InMemoryFavoritesRepository();
  });

  test('adds and retrieves a favorite', () {
    final favorite = Favorite(
      userId: 'tenant-1',
      listingId: 'listing-1',
      createdAt: DateTime(2026, 11, 26),
    );

    repository.add(favorite);

    final result = repository.listByUser('tenant-1');

    expect(result, hasLength(1));
    expect(result.first.listingId, 'listing-1');
  });

  test('does not add duplicate favorites', () {
    final favorite = Favorite(
      userId: 'tenant-1',
      listingId: 'listing-1',
      createdAt: DateTime(2026, 11, 26),
    );

    repository.add(favorite);
    repository.add(favorite);

    final result = repository.listByUser('tenant-1');

    expect(result, hasLength(1));
  });

  test('removes a favorite', () {
    final favorite = Favorite(
      userId: 'tenant-1',
      listingId: 'listing-1',
      createdAt: DateTime(2026, 11, 26),
    );

    repository.add(favorite);
    repository.remove(
      userId: 'tenant-1',
      listingId: 'listing-1',
    );

    expect(
      repository.isFavorite(
        userId: 'tenant-1',
        listingId: 'listing-1',
      ),
      false,
    );
  });

  test('keeps favorites separate between users', () {
    repository.add(
      Favorite(
        userId: 'tenant-1',
        listingId: 'listing-1',
        createdAt: DateTime(2026, 11, 26),
      ),
    );

    expect(repository.listByUser('tenant-2'), isEmpty);
  });

  test('checks whether a listing is a favorite', () {
    repository.add(
      Favorite(
        userId: 'tenant-1',
        listingId: 'listing-1',
        createdAt: DateTime(2026, 11, 26),
      ),
    );

    expect(
      repository.isFavorite(
        userId: 'tenant-1',
        listingId: 'listing-1',
      ),
      true,
    );

    expect(
      repository.isFavorite(
        userId: 'tenant-1',
        listingId: 'listing-2',
      ),
      false,
    );
  });
}
