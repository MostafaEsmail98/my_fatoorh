import '../exceptions/my_fatoorah_exception.dart';

/// Represents either a successful SDK value or a typed MyFatoorah failure.
sealed class MyFatoorahResult<T> {
  const MyFatoorahResult();

  /// Creates a successful result.
  const factory MyFatoorahResult.success(T value) = MyFatoorahSuccess<T>;

  /// Creates a failed result.
  const factory MyFatoorahResult.failure(MyFatoorahException exception) =
      MyFatoorahFailure<T>;

  /// Whether this result contains a value.
  bool get isSuccess => this is MyFatoorahSuccess<T>;

  /// Whether this result contains a failure.
  bool get isFailure => this is MyFatoorahFailure<T>;
}

/// Successful SDK result.
final class MyFatoorahSuccess<T> extends MyFatoorahResult<T> {
  /// Creates a successful SDK result.
  const MyFatoorahSuccess(this.value);

  /// Successful value.
  final T value;
}

/// Failed SDK result.
final class MyFatoorahFailure<T> extends MyFatoorahResult<T> {
  /// Creates a failed SDK result.
  const MyFatoorahFailure(this.exception);

  /// Typed failure.
  final MyFatoorahException exception;
}
