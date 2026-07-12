import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('initiates embedded session through public facade', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _sessionResponseSample),
    );
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://backend.example.test/'),
      ),
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final result = await myFatoorah.payments.embedded.initiateSession(
      const InitiateSessionRequest(
        paymentMode: EmbeddedPaymentMode.completePayment,
        order: InitiateSessionOrder(amount: '10'),
      ),
    );

    expect(result, isA<MyFatoorahSuccess<InitiateSessionResponse>>());
    final value = (result as MyFatoorahSuccess<InitiateSessionResponse>).value;
    expect(value.session.sessionId, 'KWT-68814db6-7510-4005-ada9-408aae9f373c');
    expect(transport.request?.path, '/v3/sessions');
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
