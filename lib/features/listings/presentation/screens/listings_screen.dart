import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/route_names.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../listing_strings.dart';
import '../providers/listing_providers.dart';
import '../widgets/listing_card.dart';
import 'package:kiray_bet/features/favorites/presentation/widgets/favorite_button.dart';

class ListingsScreen extends ConsumerWidget {
  const ListingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(filteredListingsProvider);
    final count = ref.watch(listingFilterProvider).activeCount;
    return AppScaffold(
      title: ListingStrings.browse,
      actions: [
        IconButton(
          tooltip: ListingStrings.map,
          onPressed: () => context.pushNamed(RouteNames.listingMap),
          icon: Icon(Icons.map_outlined),
        ),
        IconButton(
          tooltip: ListingStrings.myListings,
          onPressed: () => context.pushNamed(RouteNames.myListings),
          icon: Icon(Icons.list_alt_outlined),
        ),
        IconButton(
          tooltip: ListingStrings.viewingRequests,
          onPressed: () => context.pushNamed(RouteNames.viewingRequests),
          icon: Icon(Icons.event_note_outlined),
        ),
        IconButton(
          tooltip: ListingStrings.filter,
          onPressed: () => context.pushNamed(RouteNames.listingFilter),
          icon: Badge(
            label: Text('$count'),
            isLabelVisible: count > 0,
            child: Icon(Icons.tune),
          ),
        ),
      ],
      body: listings.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(ListingStrings.error)),
        data: (items) => items.isEmpty
            ? EmptyState(
                icon: Icons.search_off,
                title: ListingStrings.empty,
              )
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    ListingCard(listing: items[index],
                    trailing: FavoriteButton(
                    listingId: items[index].id,),),
              ),
      ),
    );
  }
}
