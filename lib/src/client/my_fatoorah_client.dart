import 'package:dio/dio.dart';

import '../core/my_fatoorah_config.dart';
import '../core/my_fatoorah_logger.dart';
import '../core/my_fatoorah_result.dart';
import '../exceptions/my_fatoorah_api_exception.dart';
import '../exceptions/my_fatoorah_auth_exception.dart';
import '../exceptions/my_fatoorah_cancelled_exception.dart';
import '../exceptions/my_fatoorah_exception.dart';
import '../exceptions/my_fatoorah_network_exception.dart';
import 'my_fatoorah_headers.dart';
import 'my_fatoorah_http_client.dart';
import 'my_fatoorah_interceptor.dart';
import 'my_fatoorah_request.dart';
import 'my_fatoorah_response.dart';
import 'my_fatoorah_retry_policy.dart';

/// Internal reusable MyFatoorah API client.
final class MyFatoorahClient {
  /// Creates an internal API client.
  MyFatoorahClient({
    required this.config,
    Uri? baseUrl,
    MyFatoorahHttpClient? httpClient,
    MyFatoorahRetryPolicy retryPolicy = MyFatoorahRetryPolicy.none,
    MyFatoorahLogger logger = const MyFatoorahNoopLogger(),
    List<MyFatoorahInterceptor> interceptors = const [],
  }) : baseUrl = baseUrl ?? config.backendBaseUrl,
       _httpClient = httpClient ?? DioMyFatoorahHttpClient(),
       _retryPolicy = retryPolicy,
       _logger = logger,
       _interceptors = List.unmodifiable(interceptors);

  /// SDK configuration.
  final MyFatoorahConfig config;

  /// Resolved API base URL.
  final Uri baseUrl;

  final MyFatoorahHttpClient _httpClient;
  final MyFatoorahRetryPolicy _retryPolicy;
  final MyFatoorahLogger _logger;
  final List<MyFatoorahInterceptor> _interceptors;

  /// Executes an SDK request and returns either a typed value or SDK exception.
  Future<MyFatoorahResult<T>> request<T>(MyFatoorahRequest<T> request) async {
    var attempt = 1;

    while (true) {
      try {
        final preparedRequest = await _applyRequestInterceptors(request);
        final headers = {
          ...MyFatoorahHeaders.defaults(config),
          ...preparedRequest.headers,
        };

        _logger.log(
          MyFatoorahLogLevel.debug,
          'Sending ${preparedRequest.method.name.toUpperCase()} '
          '${baseUrl.resolve(preparedRequest.path)}',
        );

        final rawResponse = await _httpClient.send<T>(
          baseUrl,
          preparedRequest,
          config: config,
          headers: headers,
        );
        final response = await _applyResponseInterceptors(rawResponse);

        final statusCode = response.statusCode;
        if (statusCode != null && (statusCode < 200 || statusCode >= 300)) {
          throw MyFatoorahApiException(
            'MyFatoorah API returned HTTP $statusCode.',
            statusCode: statusCode,
            details: response.data,
          );
        }

        return MyFatoorahResult.success(preparedRequest.parser(response));
      } catch (error, stackTrace) {
        var exception = _mapException(error, stackTrace);
        exception = await _applyErrorInterceptors(exception);

        _logger.log(
          MyFatoorahLogLevel.warning,
          'MyFatoorah request attempt $attempt failed.',
          error: exception,
          stackTrace: exception.stackTrace ?? stackTrace,
        );

        if (!_retryPolicy.shouldRetry(attempt: attempt, exception: exception)) {
          return MyFatoorahResult.failure(exception);
        }

        await Future<void>.delayed(_retryPolicy.delayForAttempt(attempt));
        attempt += 1;
      }
    }
  }

  Future<MyFatoorahRequest<T>> _applyRequestInterceptors<T>(
    MyFatoorahRequest<T> request,
  ) async {
    var next = request;
    for (final interceptor in _interceptors) {
      next = await interceptor.onRequest(next);
    }
    return next;
  }

  Future<MyFatoorahResponse> _applyResponseInterceptors(
    MyFatoorahResponse response,
  ) async {
    var next = response;
    for (final interceptor in _interceptors) {
      next = await interceptor.onResponse(next);
    }
    return next;
  }

  Future<MyFatoorahException> _applyErrorInterceptors(
    MyFatoorahException exception,
  ) async {
    var next = exception;
    for (final interceptor in _interceptors) {
      next = await interceptor.onError(next);
    }
    return next;
  }

  MyFatoorahException _mapException(Object error, StackTrace stackTrace) {
    if (error is MyFatoorahException) {
      return error;
    }

    if (error is DioException) {
      return _mapDioException(error, stackTrace);
    }

    return MyFatoorahException(
      'Unexpected MyFatoorah SDK error.',
      cause: error,
      stackTrace: stackTrace,
    );
  }

  MyFatoorahException _mapDioException(
    DioException error,
    StackTrace stackTrace,
  ) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    if (statusCode == 401 || statusCode == 403) {
      return MyFatoorahAuthException(
        'MyFatoorah authentication failed.',
        details: responseData,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (statusCode != null) {
      return MyFatoorahApiException(
        'MyFatoorah API returned HTTP $statusCode.',
        statusCode: statusCode,
        details: responseData,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError => MyFatoorahNetworkException(
        'Unable to reach MyFatoorah.',
        cause: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.badCertificate => MyFatoorahNetworkException(
        'MyFatoorah TLS certificate validation failed.',
        cause: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.cancel => MyFatoorahCancelledException(
        'MyFatoorah request was cancelled by the transport.',
        cause: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.badResponse => MyFatoorahApiException(
        'MyFatoorah API returned an invalid response.',
        statusCode: statusCode,
        details: responseData,
        cause: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.unknown => MyFatoorahNetworkException(
        'Unexpected MyFatoorah network error.',
        cause: error,
        stackTrace: stackTrace,
      ),
    };
  }
}
