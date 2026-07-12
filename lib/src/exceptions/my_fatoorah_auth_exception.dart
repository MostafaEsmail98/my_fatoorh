import 'my_fatoorah_exception.dart';

/// Exception for authentication and authorization failures.
final class MyFatoorahAuthException extends MyFatoorahException {
  /// Creates an auth exception.
  const MyFatoorahAuthException(
    super.message, {
    super.code,
    super.details,
    super.cause,
    super.stackTrace,
  });
}
