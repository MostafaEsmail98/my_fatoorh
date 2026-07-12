import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_headers.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_interceptor.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_retry_policy.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_config.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_logger.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_result.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_auth_exception.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_cancelled_exception.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_exception.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_network_exception.dart';

void main() {
  final config = MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://backend.example.test/'),
  );

  test('executes requests through injectable transport', () async {
    final transport = _FakeHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: {'ok': true}),
    ]);
    final client = MyFatoorahClient(
      config: config,
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final result = await client.request<bool>(
      MyFatoorahRequest<bool>(
        method: MyFatoorahHttpMethod.get,
        path: 'status',
        parser: (response) =>
            (response.data! as Map<String, Object?>)['ok']! as bool,
      ),
    );

    expect(result, isA<MyFatoorahSuccess<bool>>());
    expect((result as MyFatoorahSuccess<bool>).value, isTrue);
    expect(transport.calls.single.baseUrl, Uri.parse('https://example.test/'));
    expect(transport.calls.single.headers, isNot(contains('Authorization')));
    expect(
      transport.calls.single.headers[MyFatoorahHeaders.accept],
      MyFatoorahHeaders.applicationJson,
    );
    expect(
      transport.calls.single.headers[MyFatoorahHeaders.contentType],
      MyFatoorahHeaders.applicationJson,
    );
  });

  test('backendProxy uses backendBaseUrl', () async {
    final transport = _FakeHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: 'ok'),
    ]);
    final client = MyFatoorahClient(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://merchant.example.com/proxy/'),
      ),
      httpClient: transport,
    );

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.post,
        path: '/v3/payments',
        parser: (response) => response.data! as String,
      ),
    );

    expect(result, isA<MyFatoorahSuccess<String>>());
    expect(
      transport.calls.single.baseUrl,
      Uri.parse('https://merchant.example.com/proxy/'),
    );
    expect(transport.calls.single.headers, isNot(contains('Authorization')));
  });

  test('applies request and response interceptors', () async {
    final interceptor = _HeaderAndResponseInterceptor();
    final transport = _FakeHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: 'raw'),
    ]);
    final client = MyFatoorahClient(
      config: config,
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
      interceptors: [interceptor],
    );

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.post,
        path: '/intercepted',
        parser: (response) => response.data! as String,
      ),
    );

    expect(transport.calls.single.headers['X-Test-Interceptor'], 'enabled');
    expect((result as MyFatoorahSuccess<String>).value, 'intercepted');
  });

  test('retries retryable failures', () async {
    final transport = _FakeHttpClient([
      const MyFatoorahResponse(statusCode: 503, data: 'busy'),
      const MyFatoorahResponse(statusCode: 200, data: 'ok'),
    ]);
    final client = MyFatoorahClient(
      config: config,
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
      retryPolicy: const MyFatoorahRetryPolicy(
        maxAttempts: 2,
        baseDelay: Duration.zero,
      ),
    );

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.get,
        path: 'retry',
        parser: (response) => response.data! as String,
      ),
    );

    expect((result as MyFatoorahSuccess<String>).value, 'ok');
    expect(transport.calls, hasLength(2));
  });

  test('maps Dio auth failures to SDK auth exceptions', () async {
    final transport = _ThrowingHttpClient(
      DioException(
        requestOptions: RequestOptions(path: '/auth'),
        response: Response<Object?>(
          requestOptions: RequestOptions(path: '/auth'),
          statusCode: 401,
          data: {'Message': 'Unauthorized'},
        ),
        type: DioExceptionType.badResponse,
      ),
    );
    final client = MyFatoorahClient(config: config, httpClient: transport);

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.get,
        path: 'auth',
        parser: (response) => response.data! as String,
      ),
    );

    expect(result, isA<MyFatoorahFailure<String>>());
    expect(
      (result as MyFatoorahFailure<String>).exception,
      isA<MyFatoorahAuthException>(),
    );
  });

  test('maps Dio network failures to SDK network exceptions', () async {
    final transport = _ThrowingHttpClient(
      DioException(
        requestOptions: RequestOptions(path: '/timeout'),
        type: DioExceptionType.connectionTimeout,
      ),
    );
    final client = MyFatoorahClient(config: config, httpClient: transport);

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.get,
        path: 'timeout',
        parser: (response) => response.data! as String,
      ),
    );

    expect(result, isA<MyFatoorahFailure<String>>());
    expect(
      (result as MyFatoorahFailure<String>).exception,
      isA<MyFatoorahNetworkException>(),
    );
  });

  test('maps Dio cancel failures to SDK cancelled exceptions', () async {
    final transport = _ThrowingHttpClient(
      DioException(
        requestOptions: RequestOptions(path: '/cancelled'),
        type: DioExceptionType.cancel,
      ),
    );
    final client = MyFatoorahClient(config: config, httpClient: transport);

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.get,
        path: 'cancelled',
        parser: (response) => response.data! as String,
      ),
    );

    expect(result, isA<MyFatoorahFailure<String>>());
    expect(
      (result as MyFatoorahFailure<String>).exception,
      isA<MyFatoorahCancelledException>(),
    );
  });

  test('does not log Authorization header or API key', () async {
    final secretConfig = MyFatoorahConfig.backendProxy(
      backendBaseUrl: Uri.parse('https://backend.example.test/'),
    );
    final logger = _CapturingLogger();
    final client = MyFatoorahClient(
      config: secretConfig,
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: _FakeHttpClient([
        const MyFatoorahResponse(statusCode: 200, data: 'ok'),
      ]),
      logger: logger,
    );

    final result = await client.request<String>(
      MyFatoorahRequest<String>(
        method: MyFatoorahHttpMethod.get,
        path: 'safe-log',
        parser: (response) => response.data! as String,
      ),
    );

    expect(result, isA<MyFatoorahSuccess<String>>());
    final renderedLogs = logger.entries
        .map((entry) => entry.toString())
        .join('\n');
    expect(renderedLogs, isNot(contains('Authorization')));
    expect(renderedLogs, isNot(contains('Bearer')));
  });
}

final class _FakeHttpClient implements MyFatoorahHttpClient {
  _FakeHttpClient(this._responses);

  final List<MyFatoorahResponse> _responses;
  final List<_CapturedRequest> calls = [];

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    calls.add(_CapturedRequest(baseUrl: baseUrl, headers: headers));
    return _responses[calls.length - 1];
  }
}

final class _ThrowingHttpClient implements MyFatoorahHttpClient {
  _ThrowingHttpClient(this.error);

  final Object error;

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    throw error;
  }
}

final class _HeaderAndResponseInterceptor implements MyFatoorahInterceptor {
  @override
  MyFatoorahRequest<T> onRequest<T>(MyFatoorahRequest<T> request) {
    return request.copyWith(
      headers: {...request.headers, 'X-Test-Interceptor': 'enabled'},
    );
  }

  @override
  MyFatoorahResponse onResponse(MyFatoorahResponse response) {
    return const MyFatoorahResponse(statusCode: 200, data: 'intercepted');
  }

  @override
  MyFatoorahException onError(MyFatoorahException exception) {
    return exception;
  }
}

final class _CapturedRequest {
  const _CapturedRequest({required this.baseUrl, required this.headers});

  final Uri baseUrl;
  final Map<String, String> headers;
}

final class _CapturingLogger implements MyFatoorahLogger {
  final List<_CapturedLogEntry> entries = [];

  @override
  void log(
    MyFatoorahLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    entries.add(
      _CapturedLogEntry(level: level, message: message, error: error),
    );
  }
}

final class _CapturedLogEntry {
  const _CapturedLogEntry({
    required this.level,
    required this.message,
    this.error,
  });

  final MyFatoorahLogLevel level;
  final String message;
  final Object? error;

  @override
  String toString() => '$level $message $error';
}
