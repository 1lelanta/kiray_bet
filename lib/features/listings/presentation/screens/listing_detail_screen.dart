import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';

/// Placeholder for a single rental listing.
class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Listing Detail',
      body: Center(child: Text('Listing ID: $listingId')),
    );
  }
}
