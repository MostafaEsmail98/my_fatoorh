import 'my_fatoorah_exception.dart';

/// Exception for API responses that represent a MyFatoorah-side failure.
final class MyFatoorahApiException extends MyFatoorahException {
  /// Creates an API exception.
  const MyFatoorahApiException(
    super.message, {
    super.code,
    super.details,
    super.cause,
    super.stackTrace,
    this.statusCode,
  });

  /// HTTP status code, when an HTTP response was received.
  final int? statusCode;
}
