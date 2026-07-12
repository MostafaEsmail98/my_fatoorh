import 'my_fatoorah_exception.dart';

/// Exception for user- or merchant-cancelled SDK flows.
final class MyFatoorahCancelledException extends MyFatoorahException {
  /// Creates a cancelled-flow exception.
  const MyFatoorahCancelledException(
    super.message, {
    super.code,
    super.details,
    super.cause,
    super.stackTrace,
  });
}
