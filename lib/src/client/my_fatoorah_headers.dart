import '../core/my_fatoorah_config.dart';

/// HTTP header names and values used by MyFatoorah requests.
final class MyFatoorahHeaders {
  const MyFatoorahHeaders._();

  /// Accept header name.
  static const accept = 'Accept';

  /// Content-Type header name.
  static const contentType = 'Content-Type';

  /// JSON media type.
  static const applicationJson = 'application/json';

  /// Builds default SDK headers from configuration.
  static Map<String, String> defaults(MyFatoorahConfig config) {
    return {accept: applicationJson, contentType: applicationJson};
  }
}
