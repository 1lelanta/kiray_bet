import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../authentication_destination.dart';
import '../authentication_strings.dart';
import '../providers/authentication_providers.dart';
import '../providers/selected_language_provider.dart';

class SplashLanguageScreen extends ConsumerWidget {
  const SplashLanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(selectedLanguageProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.home_work_outlined, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    AuthenticationStrings.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AuthenticationStrings.splashTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AuthenticationStrings.splashMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AuthenticationStrings.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'en',
                        label: Text(AuthenticationStrings.english),
                      ),
                      ButtonSegment(
                        value: 'am',
                        label: Text(AuthenticationStrings.amharic),
                      ),
                    ],
                    selected: {language},
                    onSelectionChanged: (selection) => ref
                        .read(selectedLanguageProvider.notifier)
                        .setLanguage(selection.first),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('entry-continue'),
                    onPressed: () {
                      final user = ref.read(currentUserProvider);
                      context.go(
                        user == null
                            ? RoutePaths.login
                            : AuthenticationDestination.forRole(user.role),
                      );
                    },
                    child: const Text(AuthenticationStrings.continueLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
