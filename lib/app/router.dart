import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/assistant/assistant_screen.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/auth_form_screen.dart';
import '../features/auth/reset_password_screen.dart';
import '../features/barcode/barcode_scanner_screen.dart';
import '../features/food_details/food_details_screen.dart';
import '../features/goals/goals_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/profile_controller.dart';
import '../features/recipes/recipe_details_screen.dart';
import '../features/recipes/recipe_editor_screen.dart';
import '../features/recipes/recipes_screen.dart';
import '../features/photo/photo_recognition_screen.dart';
import '../features/tracking/meal_templates_screen.dart';
import '../features/tracking/progress_screen.dart';
import 'main_shell.dart';

/// A [Listenable] that notifies go_router to re-run redirects whenever auth
/// or onboarding state changes.
final goRouterRefreshProvider = ChangeNotifierProvider((ref) {
  final notifier = _RefreshNotifier();
  ref.listen<AuthState>(authControllerProvider, (_, _) => notifier.notify());
  ref.listen<bool>(onboardingCompleteProvider, (_, _) => notifier.notify());
  return notifier;
});

class _RefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Application router.
///
/// Redirect logic:
/// - Unauthenticated users are sent to `/login`.
/// - Authenticated users who haven't completed onboarding go to `/onboarding`.
/// - Authenticated + onboarded users hitting auth routes go to `/home`.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(goRouterRefreshProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final onboardingComplete = ref.read(onboardingCompleteProvider);
      final isAuthenticated = auth is Authenticated;

      final location = state.matchedLocation;
      final goingToAuth =
          location == '/login' || location == '/signup' || location == '/reset-password';

      if (!isAuthenticated && !goingToAuth) {
        return '/login';
      }
      if (isAuthenticated &&
          !onboardingComplete &&
          location != '/onboarding') {
        return '/onboarding';
      }
      if (isAuthenticated && onboardingComplete && goingToAuth) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthFormScreen(isSignUp: false),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const AuthFormScreen(isSignUp: true),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/food/:id',
        builder: (context, state) {
          final extra = state.extra;
          double? initialGrams;
          var fromPhoto = false;
          if (extra is Map) {
            final g = extra['photoEstimatedGrams'];
            if (g is num) initialGrams = g.toDouble();
            fromPhoto = extra['photoEstimatedGrams'] != null;
          }
          return FoodDetailsScreen(
            foodId: Uri.decodeComponent(state.pathParameters['id']!),
            initialGrams: initialGrams,
            fromPhotoEstimate: fromPhoto,
          );
        },
      ),
      GoRoute(
        path: '/barcode',
        builder: (context, state) => const BarcodeScannerScreen(),
      ),
      GoRoute(
        path: '/photo',
        builder: (context, state) => const PhotoRecognitionScreen(),
      ),
      GoRoute(
        path: '/assistant',
        builder: (context, state) => const AssistantScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/templates',
        builder: (context, state) => const MealTemplatesScreen(),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/recipes',
        builder: (context, state) => const RecipesScreen(),
      ),
      GoRoute(
        path: '/recipes/create',
        builder: (context, state) => const RecipeEditorScreen(),
      ),
      GoRoute(
        path: '/recipes/:id/edit',
        builder: (context, state) =>
            RecipeEditorScreen(recipeId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/recipes/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          if (id == 'create') {
            return const RecipeEditorScreen();
          }
          return RecipeDetailsScreen(recipeId: id);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShell(currentIndex: 0),
      ),
      GoRoute(
        path: '/diary',
        builder: (context, state) => const MainShell(currentIndex: 1),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const MainShell(currentIndex: 2),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const MainShell(currentIndex: 3),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.matchedLocation}')),
    ),
  );
});
