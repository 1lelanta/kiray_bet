import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../compare_strings.dart';

/// Placeholder for comparison results.
class CompareResultScreen extends StatelessWidget {
  const CompareResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: CompareStrings.resultTitle,
      body: EmptyState(
        icon: Icons.analytics_outlined,
        title: CompareStrings.resultTitle,
      ),
    );
  }
}
