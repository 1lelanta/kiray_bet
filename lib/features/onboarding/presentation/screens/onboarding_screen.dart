import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for the onboarding flow.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Onboarding',
      body: EmptyState(icon: Icons.waving_hand_outlined, title: 'Onboarding'),
    );
  }
}
