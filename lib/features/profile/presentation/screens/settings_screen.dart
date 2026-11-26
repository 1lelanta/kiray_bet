import 'package:material_ui/material_ui.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for profile settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Settings',
      body: EmptyState(icon: Icons.settings_outlined, title: 'Settings'),
    );
  }
}
