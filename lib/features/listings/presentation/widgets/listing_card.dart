import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/route_paths.dart';
import '../../../../../core/formatters/birr_formatter.dart';
import '../../domain/listing.dart';
import '../listing_strings.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing, this.trailing});

  final Listing listing;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(RoutePaths.listingDetailPath(listing.id)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 88,
                height: 88,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFE1E8E5)),
                  child: Icon(Icons.home_work_outlined, size: 34),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatBirr(listing.monthlyRentBirr, languageCode),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text('${listing.subCity} · ${listing.neighbourhood}'),
                    Text(
                      '${listing.bedrooms} ${ListingStrings.bedroomCount} · ${listing.bathrooms} ${ListingStrings.bathroomCount}',
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

