import 'my_fatoorah_exception.dart';

/// Exception for invalid SDK input or MyFatoorah validation errors.
final class MyFatoorahValidationException extends MyFatoorahException {
  /// Creates a validation exception.
  const MyFatoorahValidationException(
    super.message, {
    super.code,
    super.details,
    super.cause,
    super.stackTrace,
  });
}
