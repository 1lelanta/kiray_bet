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
  RegistrationScreen({super.key});

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
    appBar: AppBar(title: Text(AuthenticationStrings.registerTitle)),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: Key(AuthenticationStrings.name),
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: AuthenticationStrings.name,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => FormValidators.name(
                      value,
                      requiredMessage: AuthenticationStrings.requiredName,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    key: Key(AuthenticationStrings.email),
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: AuthenticationStrings.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => FormValidators.email(
                      value,
                      requiredMessage: AuthenticationStrings.requiredEmail,
                      invalidMessage: AuthenticationStrings.invalidEmail,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    key: Key(AuthenticationStrings.phone),
                    controller: _phone,
                    decoration: InputDecoration(
                      labelText: AuthenticationStrings.phone,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => FormValidators.phone(
                      value,
                      requiredMessage: AuthenticationStrings.requiredPhone,
                      invalidMessage: AuthenticationStrings.invalidPhone,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    key: Key(AuthenticationStrings.password),
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: AuthenticationStrings.password,
                    ),
                    obscureText: true,
                    validator: (value) => FormValidators.password(
                      value,
                      requiredMessage: AuthenticationStrings.requiredPassword,
                      shortMessage: AuthenticationStrings.shortPassword,
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<UserRole>(
                    key: Key(AuthenticationStrings.role),
                    initialValue: _role,
                    decoration: InputDecoration(
                      labelText: AuthenticationStrings.role,
                    ),
                    items: [
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
                    SizedBox(height: 12),
                    Text(
                      _error!,
                      key: Key('registration-error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  FilledButton(
                    key: Key('registration-submit'),
                    onPressed: _register,
                    child: Text(AuthenticationStrings.createAccount),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.login),
                    child: Text(AuthenticationStrings.haveAccount),
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
