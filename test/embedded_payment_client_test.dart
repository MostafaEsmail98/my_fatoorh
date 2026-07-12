import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_config.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_result.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_api_exception.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_validation_exception.dart';
import 'package:my_fatoorah/src/payments/embedded/embedded_payment_client.dart';
import 'package:my_fatoorah/src/payments/embedded/models/initiate_session_request.dart';
import 'package:my_fatoorah/src/payments/embedded/models/initiate_session_response.dart';

void main() {
  final config = MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://backend.example.test/'),
  );

  test('initiates embedded session through POST /v3/sessions', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _sessionResponseSample),
    );
    final client = EmbeddedPaymentClient(
      MyFatoorahClient(
        config: config,
        baseUrl: Uri.parse('https://example.test/'),
        httpClient: transport,
      ),
    );

    final result = await client.initiateSession(
      const InitiateSessionRequest(
        paymentMode: EmbeddedPaymentMode.completePayment,
        order: InitiateSessionOrder(amount: '10'),
      ),
    );

    expect(result, isA<MyFatoorahSuccess<InitiateSessionResponse>>());
    final value = (result as MyFatoorahSuccess<InitiateSessionResponse>).value;
    expect(value.sessionId, 'KWT-68814db6-7510-4005-ada9-408aae9f373c');
    expect(value.operationType, 'PAY');
    expect(value.order.currency, 'KWD');
    expect(transport.request?.method, MyFatoorahHttpMethod.post);
    expect(transport.request?.path, '/v3/sessions');
    expect(transport.request?.body, {
      'PaymentMode': 'COMPLETE_PAYMENT',
      'Order': {'Amount': '10'},
    });
  });

  test('returns API failure when session response is unsuccessful', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(
        statusCode: 200,
        data: {
          'IsSuccess': false,
          'Message': 'Validation failed',
          'ValidationErrors': [
            {'Name': 'PaymentMode', 'Error': 'Required'},
          ],
          'Data': null,
        },
      ),
    );
    final client = EmbeddedPaymentClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.initiateSession(
      const InitiateSessionRequest(
        paymentMode: EmbeddedPaymentMode.completePayment,
        order: InitiateSessionOrder(amount: '10'),
      ),
    );

    expect(result, isA<MyFatoorahFailure<InitiateSessionResponse>>());
    final exception =
        (result as MyFatoorahFailure<InitiateSessionResponse>).exception;
    expect(exception, isA<MyFatoorahApiException>());
    expect(exception.message, 'Validation failed');
  });

  test('invalid embedded session amount does not call HTTP client', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: {}),
    );
    final client = EmbeddedPaymentClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.initiateSession(
      const InitiateSessionRequest(
        paymentMode: EmbeddedPaymentMode.completePayment,
        order: InitiateSessionOrder(amount: '0'),
      ),
    );

    expect(result, isA<MyFatoorahFailure<InitiateSessionResponse>>());
    final exception =
        (result as MyFatoorahFailure<InitiateSessionResponse>).exception;
    expect(exception, isA<MyFatoorahValidationException>());
    expect(transport.request, isNull);
  });
}

final class _FakeHttpClient implements MyFatoorahHttpClient {
  _FakeHttpClient(this.response);

  final MyFatoorahResponse response;
  MyFatoorahRequest<Object?>? request;

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    this.request = request as MyFatoorahRequest<Object?>;
    return response;
  }
}

const _sessionResponseSample = {
  'IsSuccess': true,
  'Message': 'Created Successfully!',
  'ValidationErrors': null,
  'Data': {
    'SessionId': 'KWT-68814db6-7510-4005-ada9-408aae9f373c',
    'SessionExpiry': '2025-10-02T00:52:35.6000597Z',
    'EncryptionKey': 'm2QTkGqSxy24hpRGmoJ50vk6cfz4VJITNxGe5/uO+Qo=',
    'OperationType': 'PAY',
    'Order': {'Amount': 10.0, 'Currency': 'KWD', 'ExternalIdentifier': null},
    'Customer': {'Reference': null, 'Cards': null},
  },
};
