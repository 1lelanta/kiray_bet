import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for the user profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Profile',
      body: EmptyState(
        icon: Icons.person_outline,
        title: 'Profile',
      ),
    );
  }
}
