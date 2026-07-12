/// SDK-owned HTTP response abstraction.
final class MyFatoorahResponse {
  /// Creates an SDK HTTP response.
  const MyFatoorahResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });

  /// HTTP status code.
  final int? statusCode;

  /// Response body as returned by the transport.
  final Object? data;

  /// Response headers.
  final Map<String, List<String>> headers;
}
