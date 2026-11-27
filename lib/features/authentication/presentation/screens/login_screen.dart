import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/validation/form_validators.dart';
import '../../domain/authentication_repository.dart';
import '../authentication_destination.dart';
import '../authentication_strings.dart';
import '../providers/authentication_providers.dart';
import '../providers/selected_language_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    try {
      final user = ref
          .read(currentUserProvider.notifier)
          .signIn(email: _email.text, password: _password.text);
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
    appBar: AppBar(title: const Text(AuthenticationStrings.loginTitle)),
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
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      key: const Key('login-error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('login-submit'),
                    onPressed: _signIn,
                    child: const Text(AuthenticationStrings.signIn),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.register),
                    child: const Text(AuthenticationStrings.noAccount),
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
