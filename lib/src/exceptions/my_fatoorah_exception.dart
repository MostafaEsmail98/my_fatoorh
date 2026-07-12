/// Base class for all MyFatoorah SDK exceptions.
base class MyFatoorahException implements Exception {
  /// Creates a MyFatoorah exception.
  const MyFatoorahException(
    this.message, {
    this.code,
    this.details,
    this.cause,
    this.stackTrace,
  });

  /// Human-readable failure message.
  final String message;

  /// Optional machine-readable error code.
  final String? code;

  /// Optional structured error details.
  final Object? details;

  /// Original lower-level error, when available.
  final Object? cause;

  /// Original stack trace, when available.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final codeText = code == null ? '' : ' ($code)';
    return 'MyFatoorahException$codeText: $message';
  }
}
