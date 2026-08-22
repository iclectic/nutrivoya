import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/api/supabase_bootstrap.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/app_error.dart';

/// Authentication result.
class AuthResult {
  const AuthResult({required this.userId, this.email});
  final String userId;
  final String? email;
}

/// Abstraction over Supabase auth.
///
/// When Supabase is not configured, methods throw [AuthError] so the UI can
/// surface a clear message. This keeps auth logic out of widgets and lets us
/// swap the backend later without touching the UI.
abstract class AuthRepository {
  Future<AuthResult> signIn({required String email, required String password});
  Future<AuthResult> signUp({required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Stream<bool> get authStateChanges;
  String? get currentUserId;
  String? get currentUserEmail;
  bool get isConfigured;
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get isConfigured => AppConfig.supabaseConfigured;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  String? get currentUserEmail => _client.auth.currentUser?.email;

  @override
  Stream<bool> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session != null);

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = res.user;
      if (user == null) {
        throw const AuthError('authErrorInvalidCredentials');
      }
      return AuthResult(userId: user.id, email: user.email);
    } on AuthApiException catch (e) {
      throw AuthError(_mapAuthException(e), detail: e.message);
    } catch (e) {
      throw AuthError('authErrorGeneric', detail: e.toString());
    }
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      final user = res.user;
      if (user == null) {
        // Email confirmation may be required; treat as pending success.
        return AuthResult(userId: '', email: email.trim());
      }
      return AuthResult(userId: user.id, email: user.email);
    } on AuthApiException catch (e) {
      throw AuthError(_mapAuthException(e), detail: e.message);
    } catch (e) {
      throw AuthError('authErrorGeneric', detail: e.toString());
    }
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> resetPassword({required String email}) =>
      _client.auth.resetPasswordForEmail(email.trim());

  String _mapAuthException(AuthApiException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid credentials') ||
        message.contains('invalid login')) {
      return 'authErrorInvalidCredentials';
    }
    if (message.contains('already registered') ||
        message.contains('already been registered') ||
        message.contains('user already registered')) {
      return 'authErrorEmailInUse';
    }
    if (message.contains('password') &&
        (message.contains('weak') || message.contains('strength'))) {
      return 'authErrorWeakPassword';
    }
    return 'authErrorGeneric';
  }
}

/// A no-op repository used when Supabase is not configured. All operations
/// throw a clear [AuthError] so the UI can guide the user.
class UnconfiguredAuthRepository implements AuthRepository {
  @override
  bool get isConfigured => false;

  @override
  String? get currentUserId => null;

  @override
  String? get currentUserEmail => null;

  @override
  Stream<bool> get authStateChanges => const Stream.empty();

  @override
  Future<AuthResult> signIn({required String email, required String password}) {
    throw const AuthError('authErrorGeneric',
        detail: 'Supabase not configured');
  }

  @override
  Future<AuthResult> signUp({required String email, required String password}) {
    throw const AuthError('authErrorGeneric',
        detail: 'Supabase not configured');
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword({required String email}) {
    throw const AuthError('authErrorGeneric',
        detail: 'Supabase not configured');
  }
}

/// Chooses the right repository based on configuration.
AuthRepository buildAuthRepository() {
  final client = SupabaseBootstrap.client;
  if (client != null) {
    return SupabaseAuthRepository(client);
  }
  if (kDebugMode) {
    debugPrint('[Nutrivoya] Using UnconfiguredAuthRepository.');
  }
  return UnconfiguredAuthRepository();
}
