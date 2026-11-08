import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';
import 'package:nutrivoya/features/auth/auth_controller.dart';
import 'package:nutrivoya/features/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('continue without account authenticates locally and persists', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = LocalPreferences(await SharedPreferences.getInstance());
    final controller = AuthController(UnconfiguredAuthRepository(), prefs);
    expect(controller.state, isA<Unauthenticated>());

    await controller.continueWithoutAccount();
    expect((controller.state as Authenticated).userId, AuthController.localUserId);

    final restored = AuthController(UnconfiguredAuthRepository(), prefs);
    expect(restored.state, isA<Authenticated>());

    await restored.signOut();
    expect(AuthController(UnconfiguredAuthRepository(), prefs).state,
        isA<Unauthenticated>());
  });
}
