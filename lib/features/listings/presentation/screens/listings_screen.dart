import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for the rental listings screen.
class ListingsScreen extends StatelessWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Listings',
      body: EmptyState(icon: Icons.home_work_outlined, title: 'Listings'),
    );
  }
}
