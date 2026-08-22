import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/errors/app_error.dart';
import 'package:nutrivoya/features/auth/auth_repository.dart';

void main() {
  group('UnconfiguredAuthRepository', () {
    final repo = UnconfiguredAuthRepository();

    test('reports not configured', () {
      expect(repo.isConfigured, isFalse);
    });

    test('has no current user', () {
      expect(repo.currentUserId, isNull);
      expect(repo.currentUserEmail, isNull);
    });

    test('signIn throws AuthError', () async {
      expect(
        () => repo.signIn(email: 'a@b.com', password: 'password'),
        throwsA(isA<AuthError>()),
      );
    });

    test('signUp throws AuthError', () async {
      expect(
        () => repo.signUp(email: 'a@b.com', password: 'password'),
        throwsA(isA<AuthError>()),
      );
    });

    test('resetPassword throws AuthError', () async {
      expect(
        () => repo.resetPassword(email: 'a@b.com'),
        throwsA(isA<AuthError>()),
      );
    });

    test('signOut completes without error', () async {
      await repo.signOut(); // should not throw
    });

    test('authStateChanges is empty stream', () async {
      final events = await repo.authStateChanges.toList();
      expect(events, isEmpty);
    });
  });

  group('AppError', () {
    test('toString includes runtime type and message key', () {
      const err = AuthError('authErrorGeneric', detail: 'x');
      expect(err.toString(), contains('AuthError'));
      expect(err.toString(), contains('authErrorGeneric'));
    });

    test('subtypes are sealed and distinct', () {
      expect(const AuthError('a'), isA<AppError>());
      expect(const NetworkError('a'), isA<AppError>());
      expect(const ValidationError('a'), isA<AppError>());
      expect(const UnknownError('a'), isA<AppError>());
    });
  });
}
