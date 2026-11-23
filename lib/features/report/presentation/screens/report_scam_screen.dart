import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';

/// Placeholder for reporting a suspicious listing.
class ReportScamScreen extends StatelessWidget {
  const ReportScamScreen({super.key, required this.listingId});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Report Scam',
      body: Center(child: Text('Listing ID: $listingId')),
    );
  }
}
