import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_error.dart';
import 'auth_repository.dart';

/// UI-facing auth state.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.userId, this.email);
  final String userId;
  final String? email;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthFailure extends AuthState {
  const AuthFailure(this.messageKey);
  final String messageKey;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repo) : super(const AuthInitial()) {
    _bootstrap();
  }

  final AuthRepository _repo;

  void _bootstrap() {
    if (_repo.currentUserId != null) {
      state = Authenticated(_repo.currentUserId!, _repo.currentUserEmail);
    } else {
      state = const Unauthenticated();
    }
    _repo.authStateChanges.listen((signedIn) {
      if (signedIn && _repo.currentUserId != null) {
        state = Authenticated(_repo.currentUserId!, _repo.currentUserEmail);
      } else if (state is! AuthLoading) {
        state = const Unauthenticated();
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final res = await _repo.signIn(email: email, password: password);
      state = Authenticated(res.userId, res.email);
    } on AuthError catch (e) {
      state = AuthFailure(e.messageKey);
    } catch (e) {
      state = const AuthFailure('authErrorGeneric');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final res = await _repo.signUp(email: email, password: password);
      state = Authenticated(res.userId, res.email);
    } on AuthError catch (e) {
      state = AuthFailure(e.messageKey);
    } catch (e) {
      state = const AuthFailure('authErrorGeneric');
    }
  }

  Future<void> signOut() async {
    try {
      await _repo.signOut();
    } catch (e) {
      if (kDebugMode) debugPrint('[Auth] signOut error: $e');
    }
    state = const Unauthenticated();
  }

  void clearError() {
    if (state is AuthFailure) state = const Unauthenticated();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return buildAuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);
