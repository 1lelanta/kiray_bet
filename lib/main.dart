import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_scaffold.dart';
import 'core/widgets/empty_state.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiray Bet',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // TODO: Add the go_router configuration and Lemmi's themeModeProvider
      // in the next PR.
      home: const AppScaffold(
        title: 'Kiray Bet',
        body: EmptyState(
          icon: Icons.home_work_outlined,
          title: 'No listings yet',
          message: 'Rental listings will appear here.',
        ),
      ),
    );
  }
}
