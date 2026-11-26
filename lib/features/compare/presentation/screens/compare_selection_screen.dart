import 'package:material_ui/material_ui.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for listing comparison selection.
class CompareSelectionScreen extends StatelessWidget {
  const CompareSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Compare',
      body: EmptyState(icon: Icons.compare_arrows, title: 'Compare'),
    );
  }
}
