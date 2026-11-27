import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../compare_strings.dart';

/// Placeholder for listing comparison selection.
class CompareSelectionScreen extends StatelessWidget {
  const CompareSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: CompareStrings.title,
      body: EmptyState(icon: Icons.compare_arrows, title: CompareStrings.title),
    );
  }
}
