
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/formatters/birr_formatter.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/listing.dart';
import '../listing_strings.dart';
import '../providers/listing_data_providers.dart';
import '../providers/listing_providers.dart';
import 'package:kiray_bet/features/favorites/presentation/widgets/favorite_button.dart';

class ListingDetailScreen extends ConsumerWidget {
  ListingDetailScreen({super.key, required this.listingId});
  final String listingId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(listingByIdProvider(listingId));
    return AppScaffold(
      title: ListingStrings.details,
      body: result.when(
        loading: () => LoadingView(),
        error: (error, stack) => ErrorView(message: ListingStrings.error),
        data: (listing) => listing == null
            ? EmptyState(
                icon: Icons.home_work_outlined,
                title: ListingStrings.notFound,
              )
            : _Details(listing: listing),
      ),
    );
  }
}

class _Details extends ConsumerWidget {
  const _Details({required this.listing});
  final Listing listing;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final userId =
        ref.watch(currentTenantIdProvider) ?? ref.watch(currentOwnerIdProvider);
    final tenantId = ref.watch(currentTenantIdProvider);
    final ownerId = ref.watch(currentOwnerIdProvider);
    final isOwner = ownerId == listing.ownerId;
    final isOwnListing = isOwner || tenantId == listing.ownerId;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        FavoriteButton(listingId: listing.id),
        SizedBox(
          height: 180,
          child: ColoredBox(
            color: Color(0xFFE1E8E5),
            child: Icon(Icons.home_work_outlined, size: 64),
          ),
        ),
        SizedBox(height: 16),
        Text(listing.title, style: Theme.of(context).textTheme.headlineSmall),
        Text(
          formatBirr(listing.monthlyRentBirr, locale),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text('${listing.subCity} · ${listing.neighbourhood}'),
        Text(
          '${listing.bedrooms} ${ListingStrings.bedroomCount} · ${listing.bathrooms} ${ListingStrings.bathroomCount} · ${listing.areaSqm} m²',
        ),
        Text(
          ListingStrings.description,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(listing.description),
        Text(
          ListingStrings.location,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(listing.address),
        Text('${ListingStrings.deposit}: ${listing.depositMonths}'),
        Text(listing.amenities.join(' · ')),
        Text(
          ListingStrings.ownerContact,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(ListingStrings.demoOwnerName),
        Text(ListingStrings.demoOwnerPhone),
        if (listing.status != ListingStatus.available)
          Text(listing.status.name),
        if (tenantId != null &&
            listing.status == ListingStatus.available &&
            !isOwnListing)
          OutlinedButton(
            onPressed: () => context.pushNamed(
              RouteNames.requestViewing,
              pathParameters: {'listingId': listing.id},
            ),
            child: Text(ListingStrings.requestViewing),
          ),
        if (userId != null && !isOwner)
          TextButton(
            onPressed: () => context.pushNamed(
              RouteNames.report,
              pathParameters: {'listingId': listing.id},
            ),
            child: Text(ListingStrings.report),
          ),
        const SizedBox.shrink(),
      ],
    );
  }
}
