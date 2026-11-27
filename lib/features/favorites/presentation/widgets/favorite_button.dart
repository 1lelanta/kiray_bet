
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';

import '../providers/favorites_providers.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.listingId,
  });

  final String listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isFavorite = ref.watch(favoritesProvider).any(
      (favorite) => favorite.listingId == listingId,
    );

    if (user == null) {
      return const SizedBox.shrink();
    }

    return IconButton(
      tooltip: isFavorite
          ? 'Remove from favorites'
          : 'Add to favorites',
      onPressed: () {
        ref.read(favoritesProvider.notifier).toggle(listingId);
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
    );
  }
}
