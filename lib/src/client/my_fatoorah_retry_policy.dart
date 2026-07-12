import '../exceptions/my_fatoorah_api_exception.dart';
import '../exceptions/my_fatoorah_exception.dart';
import '../exceptions/my_fatoorah_network_exception.dart';

/// Decides whether failed HTTP requests should be retried.
final class MyFatoorahRetryPolicy {
  /// Creates a retry policy.
  const MyFatoorahRetryPolicy({
    this.maxAttempts = 1,
    this.baseDelay = const Duration(milliseconds: 250),
    this.retryStatusCodes = const {408, 429, 500, 502, 503, 504},
  }) : assert(maxAttempts > 0, 'maxAttempts must be greater than zero');

  /// No retries.
  static const none = MyFatoorahRetryPolicy();

  /// Total attempts, including the first attempt.
  final int maxAttempts;

  /// Base delay used for linear backoff.
  final Duration baseDelay;

  /// HTTP status codes considered retryable.
  final Set<int> retryStatusCodes;

  /// Whether [exception] should be retried for [attempt].
  bool shouldRetry({
    required int attempt,
    required MyFatoorahException exception,
  }) {
    if (attempt >= maxAttempts) {
      return false;
    }

    if (exception is MyFatoorahNetworkException) {
      return true;
    }

    if (exception is MyFatoorahApiException) {
      final statusCode = exception.statusCode;
      return statusCode != null && retryStatusCodes.contains(statusCode);
    }

    return false;
  }

  /// Delay before the next retry attempt.
  Duration delayForAttempt(int attempt) {
    return baseDelay * attempt;
  }
}
