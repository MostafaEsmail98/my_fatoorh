import 'dart:async';

import '../exceptions/my_fatoorah_exception.dart';
import 'my_fatoorah_request.dart';
import 'my_fatoorah_response.dart';

/// Intercepts SDK-owned HTTP requests, responses, and mapped errors.
abstract interface class MyFatoorahInterceptor {
  /// Called before a request is sent.
  FutureOr<MyFatoorahRequest<T>> onRequest<T>(MyFatoorahRequest<T> request) {
    return request;
  }

  /// Called after a response is received.
  FutureOr<MyFatoorahResponse> onResponse(MyFatoorahResponse response) {
    return response;
  }

  /// Called after a transport error has been mapped to an SDK exception.
  FutureOr<MyFatoorahException> onError(MyFatoorahException exception) {
    return exception;
  }
}
