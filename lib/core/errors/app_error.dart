/// Centralized error type for Nutrivoya domain failures.
///
/// Keeps user-facing messages translatable and avoids leaking raw exception
/// text into the UI.
sealed class AppError {
  const AppError(this.messageKey, {this.detail});

  /// Localization key (or literal fallback) used to render a user message.
  final String messageKey;

  /// Optional developer-facing detail for logging only.
  final String? detail;

  @override
  String toString() => '$runtimeType: $messageKey${detail != null ? ' ($detail)' : ''}';
}

class AuthError extends AppError {
  const AuthError(super.messageKey, {super.detail});
}

class NetworkError extends AppError {
  const NetworkError(super.messageKey, {super.detail});
}

class ValidationError extends AppError {
  const ValidationError(super.messageKey, {super.detail});
}

class UnknownError extends AppError {
  const UnknownError(super.messageKey, {super.detail});
}
