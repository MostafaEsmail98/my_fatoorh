import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('creates hosted payment through public payments facade', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(
        statusCode: 200,
        data: {
          'IsSuccess': true,
          'Message': '',
          'ValidationErrors': null,
          'Data': {
            'InvoiceId': '6148108',
            'PaymentId': null,
            'PaymentURL':
                'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
            'PaymentCompleted': false,
            'TransactionDetails': null,
          },
        },
      ),
    );
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://backend.example.test/'),
      ),
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final response = await myFatoorah.payments.hosted.create(
      const CreateHostedPaymentRequest(
        paymentMethod: 'CARD',
        order: HostedPaymentOrder(amount: '23'),
        integrationUrls: HostedPaymentIntegrationUrls(
          redirection: 'https://your-website.com/payment-callback',
        ),
      ),
    );

    expect(response, isA<MyFatoorahSuccess<CreateHostedPaymentResponse>>());
    final value =
        (response as MyFatoorahSuccess<CreateHostedPaymentResponse>).value;
    expect(value.invoiceId, '6148108');
    expect(
      value.paymentUrl,
      'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
    );
    expect(transport.request?.path, '/v3/payments');
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
