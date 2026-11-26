import 'package:material_ui/material_ui.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/empty_state.dart';

/// Placeholder for saved rental listings.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Favorites',
      body: EmptyState(icon: Icons.favorite_border, title: 'Favorites'),
    );
  }
}
