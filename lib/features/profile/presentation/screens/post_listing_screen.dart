import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for posting a new rental listing.
class PostListingScreen extends StatelessWidget {
  const PostListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Post Listing',
      body: EmptyState(icon: Icons.add_home_outlined, title: 'Post Listing'),
    );
  }
}
