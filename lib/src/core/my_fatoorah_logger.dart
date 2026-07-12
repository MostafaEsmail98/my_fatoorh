import 'dart:developer' as developer;

/// SDK log severity.
enum MyFatoorahLogLevel {
  /// Verbose diagnostic information.
  debug,

  /// General informational message.
  info,

  /// Recoverable warning.
  warning,

  /// Failure or unexpected condition.
  error,
}

/// Logger abstraction used by SDK internals.
abstract interface class MyFatoorahLogger {
  /// Writes an SDK log entry.
  void log(
    MyFatoorahLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Logger that intentionally drops all messages.
final class MyFatoorahNoopLogger implements MyFatoorahLogger {
  /// Creates a no-op logger.
  const MyFatoorahNoopLogger();

  @override
  void log(
    MyFatoorahLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {}
}

/// Simple logger backed by `dart:developer`.
final class MyFatoorahConsoleLogger implements MyFatoorahLogger {
  /// Creates a developer-console logger.
  const MyFatoorahConsoleLogger();

  @override
  void log(
    MyFatoorahLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'my_fatoorah',
      level: _levelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  int _levelValue(MyFatoorahLogLevel level) {
    return switch (level) {
      MyFatoorahLogLevel.debug => 500,
      MyFatoorahLogLevel.info => 800,
      MyFatoorahLogLevel.warning => 900,
      MyFatoorahLogLevel.error => 1000,
    };
  }
}
