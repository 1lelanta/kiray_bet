
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiray_bet/core/widgets/app_scaffold.dart';
import 'package:kiray_bet/core/widgets/empty_state.dart';
import 'package:kiray_bet/core/widgets/loading_view.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:kiray_bet/features/favorites/presentation/favorites_strings.dart';
import 'package:kiray_bet/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';
import 'package:kiray_bet/features/listings/presentation/listing_strings.dart';
import 'package:kiray_bet/features/listings/presentation/widgets/listing_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return AppScaffold(
        title: FavoritesStrings.title,
        body: EmptyState(
          icon: Icons.favorite_border,
          title: FavoritesStrings.signInPrompt,
        ),
      );
    }

    final listings = ref.watch(favoriteListingsProvider);

    return AppScaffold(
      title: FavoritesStrings.title,
      body: listings.when(
        loading: () => const LoadingView(),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          title: FavoritesStrings.loadError,
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: FavoritesStrings.emptyTitle,
              message: FavoritesStrings.emptyMessage,
            );
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final listing = items[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListingCard(
                    listing: listing,
                    trailing: FavoriteButton(
                      listingId: listing.id,
                    ),
                  ),
                  if (listing.status != ListingStatus.available)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        top: 4,
                      ),
                      child: Chip(
                        label: Text(
                          ListingStrings.listingStatusLabel(listing.status),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
