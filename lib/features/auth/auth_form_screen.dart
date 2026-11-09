import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/extensions/app_localizations_x.dart';
import 'auth_controller.dart';

/// Shared form for sign-in and sign-up.
class AuthFormScreen extends ConsumerStatefulWidget {
  const AuthFormScreen({super.key, required this.isSignUp});

  final bool isSignUp;

  @override
  ConsumerState<AuthFormScreen> createState() => _AuthFormScreenState();
}

class _AuthFormScreenState extends ConsumerState<AuthFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = ref.read(authControllerProvider.notifier);
    if (widget.isSignUp) {
      await auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      await auth.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState is AuthLoading;
    final errorKey = authState is AuthFailure ? authState.messageKey : null;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthFailure && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_resolveError(next.messageKey, l10n))),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(widget.isSignUp ? l10n.authSignupTitle : l10n.authLoginTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.isSignUp ? l10n.authSignupTitle : l10n.authLoginTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isSignUp
                        ? l10n.authSignupSubtitle
                        : l10n.authLoginSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.authEmailLabel,
                      hintText: l10n.authEmailHint,
                      prefixIcon: const Icon(Icons.alternate_email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
                        return l10n.authErrorInvalidCredentials;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.authPasswordLabel,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    obscureText: _obscure,
                    validator: (value) {
                      if ((value ?? '').length < 6) {
                        return l10n.authErrorWeakPassword;
                      }
                      return null;
                    },
                  ),
                  if (!widget.isSignUp) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () => context.push('/reset-password'),
                        child: Text(l10n.authForgotPassword),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.isSignUp
                            ? l10n.authSignupButton
                            : l10n.authLoginButton),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.go(widget.isSignUp ? '/login' : '/signup'),
                    child: Text(widget.isSignUp
                        ? l10n.authSwitchToLogin
                        : l10n.authSwitchToSignup),
                  ),
                  if (!ref.watch(authRepositoryProvider).isConfigured) ...[
                    const Divider(height: 32),
                    OutlinedButton.icon(
                      key: const Key('auth-continue-offline'),
                      icon: const Icon(Icons.phone_android),
                      onPressed: () => ref
                          .read(authControllerProvider.notifier)
                          .continueWithoutAccount(),
                      label: Text(l10n.authContinueOffline),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.authOfflineNote,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (errorKey != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _resolveError(errorKey, l10n),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveError(String key, AppLocalizations l10n) {
    // The message keys from the auth layer map to ARB keys.
    switch (key) {
      case 'authErrorInvalidCredentials':
        return l10n.authErrorInvalidCredentials;
      case 'authErrorEmailInUse':
        return l10n.authErrorEmailInUse;
      case 'authErrorWeakPassword':
        return l10n.authErrorWeakPassword;
      default:
        return l10n.authErrorGeneric;
    }
  }
}
