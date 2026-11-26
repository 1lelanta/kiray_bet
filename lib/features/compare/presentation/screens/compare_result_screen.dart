import 'package:material_ui/material_ui.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for comparison results.
class CompareResultScreen extends StatelessWidget {
  const CompareResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Compare Result',
      body: EmptyState(icon: Icons.analytics_outlined, title: 'Compare Result'),
    );
  }
}
