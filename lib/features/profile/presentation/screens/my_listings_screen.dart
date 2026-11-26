import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/formatters/birr_formatter.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../listings/domain/listing.dart';
import '../../../listings/presentation/listing_strings.dart';
import '../../../listings/presentation/providers/listing_data_providers.dart';
import '../../../listings/presentation/providers/listing_providers.dart';

class MyListingsScreen extends ConsumerWidget {
  MyListingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(currentOwnerListingsProvider);
    return AppScaffold(
      title: ListingStrings.myListings,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RoutePaths.post),
        icon: Icon(Icons.add),
        label: Text(ListingStrings.add),
      ),
      body: listings.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(ListingStrings.error)),
        data: (items) => items.isEmpty
            ? EmptyState(
                icon: Icons.list_alt_outlined,
                title: ListingStrings.noOwnerListings,
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    _OwnerListingTile(listing: items[index]),
              ),
      ),
    );
  }
}

class _OwnerListingTile extends ConsumerWidget {
  const _OwnerListingTile({required this.listing});
  final Listing listing;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    child: ListTile(
      title: Text(listing.title),
      subtitle: Text(
        '${listing.status.name} · ${formatBirr(listing.monthlyRentBirr, Localizations.localeOf(context).languageCode)}',
      ),
      onTap: () => context.push(RoutePaths.listingEditPath(listing.id)),
      trailing: PopupMenuButton<ListingStatus>(
        onSelected: (status) async {
          await ref
              .read(listingRepositoryProvider)
              .updateListingStatus(listing.id, status);
          ref.invalidate(currentOwnerListingsProvider);
          ref.invalidate(allListingsProvider);
          ref.invalidate(listingByIdProvider(listing.id));
        },
        itemBuilder: (context) =>  [
          PopupMenuItem(
            value: ListingStatus.available,
            child: Text(ListingStrings.markAvailable),
          ),
          PopupMenuItem(
            value: ListingStatus.rented,
            child: Text(ListingStrings.markRented),
          ),
        ],
      ),
    ),
  );
}
