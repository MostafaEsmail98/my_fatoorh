import 'package:dio/dio.dart';

import '../core/my_fatoorah_config.dart';
import 'my_fatoorah_headers.dart';
import 'my_fatoorah_request.dart';
import 'my_fatoorah_response.dart';

/// Transport abstraction for SDK HTTP calls.
abstract interface class MyFatoorahHttpClient {
  /// Sends an SDK-owned HTTP request.
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  });
}

/// Dio-backed HTTP transport.
///
/// Dio remains internal to the SDK and is never exposed through public APIs.
final class DioMyFatoorahHttpClient implements MyFatoorahHttpClient {
  /// Creates a Dio transport.
  DioMyFatoorahHttpClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    final response = await _dio.request<Object?>(
      _resolve(baseUrl, request.path).toString(),
      data: request.body,
      queryParameters: request.queryParameters,
      options: Options(
        method: _methodName(request.method),
        headers: headers,
        connectTimeout: config.timeout,
        sendTimeout: config.timeout,
        receiveTimeout: config.timeout,
        contentType: headers[MyFatoorahHeaders.contentType],
        responseType: ResponseType.json,
      ),
    );

    return MyFatoorahResponse(
      statusCode: response.statusCode,
      data: response.data,
      headers: response.headers.map,
    );
  }

  Uri _resolve(Uri baseUrl, String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return baseUrl.resolve(normalizedPath);
  }

  String _methodName(MyFatoorahHttpMethod method) {
    return switch (method) {
      MyFatoorahHttpMethod.get => 'GET',
      MyFatoorahHttpMethod.post => 'POST',
      MyFatoorahHttpMethod.put => 'PUT',
      MyFatoorahHttpMethod.patch => 'PATCH',
      MyFatoorahHttpMethod.delete => 'DELETE',
    };
  }
}
