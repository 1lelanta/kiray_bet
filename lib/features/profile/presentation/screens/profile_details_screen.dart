import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../authentication/domain/authentication_repository.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../../authentication/presentation/authentication_strings.dart';
import '../../../authentication/presentation/providers/authentication_providers.dart';
import '../profile_strings.dart';
import '../providers/profile_providers.dart';

/// Shows the signed-in user's details and lets them edit name and phone.
///
/// Email and role are read-only. When nobody is signed in, a prompt to sign
/// in is shown instead.
class ProfileDetailsScreen extends ConsumerWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return AppScaffold(
        title: ProfileStrings.profileTitle,
        body: EmptyState(
          key: const Key('profile-signed-out'),
          icon: Icons.person_off_outlined,
          title: ProfileStrings.signedOutTitle,
          message: ProfileStrings.signedOutMessage,
          actionLabel: ProfileStrings.signIn,
          onAction: () => context.go(RoutePaths.login),
        ),
      );
    }
    return AppScaffold(
      title: ProfileStrings.profileTitle,
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          key: const Key('profile-open-settings'),
          tooltip: ProfileStrings.openSettings,
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.go(RoutePaths.settings),
        ),
      ],
      body: _ProfileForm(key: ValueKey(user.id), user: user),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({super.key, required this.user});

  final UserProfile user;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.user.name);
  late final _phone = TextEditingController(text: widget.user.phone);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final saved = await ref
        .read(profileUpdateProvider.notifier)
        .save(name: _name.text, phone: _phone.text);
    if (!saved || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: Key('profile-saved'),
          content: Text(ProfileStrings.updateSuccess),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final update = ref.watch(profileUpdateProvider);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                user.name.isEmpty ? '?' : user.name.characters.first,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    key: const Key('profile-header-name'),
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(_roleLabel(user.role)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(ProfileStrings.accountDetails, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('profile-email'),
          initialValue: user.email,
          readOnly: true,
          decoration: InputDecoration(
            labelText: AuthenticationStrings.email,
            suffixIcon: const Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('profile-role'),
          initialValue: _roleLabel(user.role),
          readOnly: true,
          decoration: InputDecoration(
            labelText: ProfileStrings.role,
            suffixIcon: const Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 8),
        Text(ProfileStrings.readOnlyHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 24),
        Text(ProfileStrings.editDetails, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('profile-name'),
                controller: _name,
                enabled: !update.isLoading,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: AuthenticationStrings.name,
                ),
                validator: (value) => FormValidators.name(
                  value,
                  requiredMessage: AuthenticationStrings.requiredName,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('profile-phone'),
                controller: _phone,
                enabled: !update.isLoading,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: AuthenticationStrings.phone,
                ),
                validator: (value) => FormValidators.phone(
                  value,
                  requiredMessage: AuthenticationStrings.requiredPhone,
                  invalidMessage: AuthenticationStrings.invalidPhone,
                ),
              ),
            ],
          ),
        ),
        if (update.hasError) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage(update.error!),
            key: const Key('profile-error'),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('profile-save'),
          onPressed: update.isLoading ? null : _save,
          child: update.isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text(ProfileStrings.saving),
                  ],
                )
              : Text(ProfileStrings.saveChanges),
        ),
      ],
    );
  }
}

String _roleLabel(UserRole role) => switch (role) {
  UserRole.tenant => ProfileStrings.roleTenant,
  UserRole.owner => ProfileStrings.roleOwner,
  UserRole.admin => ProfileStrings.roleAdmin,
};

String _errorMessage(Object error) =>
    error is AuthenticationException &&
        error.failure == AuthenticationFailure.signInRequired
    ? AuthenticationStrings.signInRequired
    : ProfileStrings.updateFailed;
