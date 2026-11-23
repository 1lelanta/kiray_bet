import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for listings posted by the user.
class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'My Listings',
      body: EmptyState(icon: Icons.list_alt_outlined, title: 'My Listings'),
    );
  }
}
