import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/validation/form_validators.dart';
import '../../domain/authentication_repository.dart';
import '../../domain/user_profile.dart';
import '../authentication_destination.dart';
import '../authentication_strings.dart';
import '../providers/authentication_providers.dart';
import '../providers/selected_language_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.tenant;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _register() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    try {
      final user = ref
          .read(currentUserProvider.notifier)
          .register(
            name: _name.text,
            email: _email.text,
            phone: _phone.text,
            password: _password.text,
            role: _role,
            preferredLanguage: ref.read(selectedLanguageProvider),
          );
      ref
          .read(selectedLanguageProvider.notifier)
          .setLanguage(user.preferredLanguage);
      context.go(AuthenticationDestination.forRole(user.role));
    } on AuthenticationException catch (exception) {
      setState(() => _error = _messageFor(exception.failure));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AuthenticationStrings.registerTitle)),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const Key(AuthenticationStrings.name),
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: AuthenticationStrings.name,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => FormValidators.name(
                      value,
                      requiredMessage: AuthenticationStrings.requiredName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key(AuthenticationStrings.email),
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: AuthenticationStrings.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => FormValidators.email(
                      value,
                      requiredMessage: AuthenticationStrings.requiredEmail,
                      invalidMessage: AuthenticationStrings.invalidEmail,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key(AuthenticationStrings.phone),
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: AuthenticationStrings.phone,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => FormValidators.phone(
                      value,
                      requiredMessage: AuthenticationStrings.requiredPhone,
                      invalidMessage: AuthenticationStrings.invalidPhone,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key(AuthenticationStrings.password),
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: AuthenticationStrings.password,
                    ),
                    obscureText: true,
                    validator: (value) => FormValidators.password(
                      value,
                      requiredMessage: AuthenticationStrings.requiredPassword,
                      shortMessage: AuthenticationStrings.shortPassword,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<UserRole>(
                    key: const Key(AuthenticationStrings.role),
                    initialValue: _role,
                    decoration: const InputDecoration(
                      labelText: AuthenticationStrings.role,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: UserRole.tenant,
                        child: Text(AuthenticationStrings.tenant),
                      ),
                      DropdownMenuItem(
                        value: UserRole.owner,
                        child: Text(AuthenticationStrings.owner),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _role = value ?? UserRole.tenant;
                    }),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      key: const Key('registration-error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('registration-submit'),
                    onPressed: _register,
                    child: const Text(AuthenticationStrings.createAccount),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.login),
                    child: const Text(AuthenticationStrings.haveAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

String _messageFor(AuthenticationFailure failure) => switch (failure) {
  AuthenticationFailure.duplicateEmail => AuthenticationStrings.duplicateEmail,
  AuthenticationFailure.invalidCredentials =>
    AuthenticationStrings.invalidCredentials,
  AuthenticationFailure.signInRequired => AuthenticationStrings.signInRequired,
  AuthenticationFailure.unsupportedRole =>
    AuthenticationStrings.unsupportedRole,
};
