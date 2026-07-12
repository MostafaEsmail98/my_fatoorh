import 'my_fatoorah_response.dart';

/// Supported HTTP methods for internal MyFatoorah requests.
enum MyFatoorahHttpMethod {
  /// GET.
  get,

  /// POST.
  post,

  /// PUT.
  put,

  /// PATCH.
  patch,

  /// DELETE.
  delete,
}

/// Converts an HTTP response into a typed SDK value.
typedef MyFatoorahResponseParser<T> = T Function(MyFatoorahResponse response);

/// SDK-owned HTTP request abstraction.
final class MyFatoorahRequest<T> {
  /// Creates an internal SDK HTTP request.
  const MyFatoorahRequest({
    required this.method,
    required this.path,
    required this.parser,
    this.queryParameters = const {},
    this.body,
    this.headers = const {},
  });

  /// HTTP method.
  final MyFatoorahHttpMethod method;

  /// Relative path resolved against the configured base URL.
  final String path;

  /// Query parameters.
  final Map<String, Object?> queryParameters;

  /// Request body. Serialization will be defined by future service layers.
  final Object? body;

  /// Per-request headers.
  final Map<String, String> headers;

  /// Converts a raw SDK response into a typed value.
  final MyFatoorahResponseParser<T> parser;

  /// Returns a copy with selected fields replaced.
  MyFatoorahRequest<T> copyWith({
    MyFatoorahHttpMethod? method,
    String? path,
    Map<String, Object?>? queryParameters,
    Object? body,
    Map<String, String>? headers,
    MyFatoorahResponseParser<T>? parser,
  }) {
    return MyFatoorahRequest<T>(
      method: method ?? this.method,
      path: path ?? this.path,
      queryParameters: queryParameters ?? this.queryParameters,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      parser: parser ?? this.parser,
    );
  }
}
