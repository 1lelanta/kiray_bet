import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../../authentication/presentation/authentication_strings.dart';
import '../../../authentication/presentation/providers/authentication_providers.dart';
import '../../../authentication/presentation/providers/selected_language_provider.dart';
import '../../../listings/presentation/listing_strings.dart';
import '../../domain/app_settings.dart';
import '../profile_strings.dart';
import '../providers/app_settings_provider.dart';

/// Theme, language, notification and account settings, plus shortcuts to
/// the existing screens that match the signed-in user's role.
class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final language = ref.watch(selectedLanguageProvider);
    final user = ref.watch(currentUserProvider);
    return AppScaffold(
      title: ProfileStrings.settingsTitle,
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const _SectionHeader(ProfileStrings.appearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<AppThemePreference>(
              key: const Key('settings-theme'),
              segments: const [
                ButtonSegment(
                  value: AppThemePreference.system,
                  icon: Icon(Icons.brightness_auto_outlined),
                  label: Text(ProfileStrings.themeSystem),
                ),
                ButtonSegment(
                  value: AppThemePreference.light,
                  icon: Icon(Icons.light_mode_outlined),
                  label: Text(ProfileStrings.themeLight),
                ),
                ButtonSegment(
                  value: AppThemePreference.dark,
                  icon: Icon(Icons.dark_mode_outlined),
                  label: Text(ProfileStrings.themeDark),
                ),
              ],
              selected: {settings.themePreference},
              onSelectionChanged: (selection) => ref
                  .read(appSettingsProvider.notifier)
                  .setThemePreference(selection.first),
            ),
          ),
          const _SectionHeader(AuthenticationStrings.language),
          ListTile(
            key: const Key('settings-current-language'),
            leading: const Icon(Icons.translate),
            title: const Text(ProfileStrings.currentLanguage),
            trailing: Text(_languageName(language)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              key: const Key('settings-language'),
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
          ),
          const _SectionHeader(ProfileStrings.notifications),
          SwitchListTile(
            key: const Key('settings-notifications'),
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text(ProfileStrings.notifications),
            subtitle: const Text(ProfileStrings.notificationsHint),
            value: settings.notificationsEnabled,
            onChanged: (enabled) => ref
                .read(appSettingsProvider.notifier)
                .setNotificationsEnabled(enabled),
          ),
          if (user != null) ...[
            const _SectionHeader(ProfileStrings.shortcuts),
            ..._roleShortcuts(context, user.role),
          ],
          const _SectionHeader(ProfileStrings.account),
          if (user == null)
            ListTile(
              key: const Key('settings-sign-in'),
              leading: const Icon(Icons.login),
              title: const Text(ProfileStrings.signIn),
              onTap: () => context.go(RoutePaths.login),
            )
          else
            ListTile(
              key: const Key('settings-sign-out'),
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                ProfileStrings.signOut,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () => _confirmSignOut(context, ref),
            ),
        ],
      ),
    );
  }
}

/// Links to screens that already exist in the app router, chosen by role.
List<Widget> _roleShortcuts(BuildContext context, UserRole role) =>
    switch (role) {
      UserRole.owner => [
        ListTile(
          key: const Key('settings-my-listings'),
          leading: const Icon(Icons.home_work_outlined),
          title: const Text(ListingStrings.myListings),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go(RoutePaths.myListings),
        ),
      ],
      UserRole.tenant => [
        ListTile(
          key: const Key('settings-favorites'),
          leading: const Icon(Icons.favorite_border),
          title: const Text(ProfileStrings.favorites),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go(RoutePaths.favorites),
        ),
        ListTile(
          key: const Key('settings-viewing-requests'),
          leading: const Icon(Icons.event_note_outlined),
          title: const Text(ListingStrings.viewingRequests),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(RoutePaths.viewingRequests),
        ),
      ],
      UserRole.admin => [
        ListTile(
          key: const Key('settings-moderation'),
          leading: const Icon(Icons.shield_outlined),
          title: const Text(AuthenticationStrings.moderationTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(RoutePaths.moderation),
        ),
      ],
    };

Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(ProfileStrings.signOutConfirmTitle),
      content: const Text(ProfileStrings.signOutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(ProfileStrings.cancel),
        ),
        FilledButton(
          key: const Key('settings-sign-out-confirm'),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(ProfileStrings.signOut),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  ref.read(currentUserProvider.notifier).signOut();
  context.go(RoutePaths.login);
}

String _languageName(String code) => code == 'am'
    ? AuthenticationStrings.amharic
    : AuthenticationStrings.english;

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ),
  );
}
