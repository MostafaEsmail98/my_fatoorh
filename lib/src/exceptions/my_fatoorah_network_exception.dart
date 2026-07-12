import 'my_fatoorah_exception.dart';

/// Exception for network, transport, and timeout failures.
final class MyFatoorahNetworkException extends MyFatoorahException {
  /// Creates a network exception.
  const MyFatoorahNetworkException(
    super.message, {
    super.code,
    super.details,
    super.cause,
    super.stackTrace,
  });
}
