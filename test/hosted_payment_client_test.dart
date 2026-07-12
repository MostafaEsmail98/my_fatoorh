import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_config.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_result.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_api_exception.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_validation_exception.dart';
import 'package:my_fatoorah/src/payments/hosted/hosted_payment_client.dart';
import 'package:my_fatoorah/src/payments/hosted/models/create_hosted_payment_request.dart';
import 'package:my_fatoorah/src/payments/hosted/models/create_hosted_payment_response.dart';

void main() {
  final config = MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://backend.example.test/'),
  );

  test('creates hosted payment through POST /v3/payments', () async {
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
    final client = HostedPaymentClient(
      MyFatoorahClient(
        config: config,
        baseUrl: Uri.parse('https://example.test/'),
        httpClient: transport,
      ),
    );

    final result = await client.create(
      const CreateHostedPaymentRequest(
        paymentMethod: 'CARD',
        order: HostedPaymentOrder(amount: '23'),
        integrationUrls: HostedPaymentIntegrationUrls(
          redirection: 'https://your-website.com/payment-callback',
        ),
      ),
    );

    expect(result, isA<MyFatoorahSuccess<CreateHostedPaymentResponse>>());
    final value =
        (result as MyFatoorahSuccess<CreateHostedPaymentResponse>).value;
    expect(value.invoiceId, '6148108');
    expect(value.paymentId, isNull);
    expect(
      value.paymentUrl,
      'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
    );
    expect(value.paymentCompleted, isFalse);

    expect(transport.request?.method, MyFatoorahHttpMethod.post);
    expect(transport.request?.path, '/v3/payments');
    expect(transport.request?.body, {
      'PaymentMethod': 'CARD',
      'Order': {'Amount': '23'},
      'IntegrationUrls': {
        'Redirection': 'https://your-website.com/payment-callback',
      },
    });
  });

  test(
    'returns API failure when MyFatoorah response is unsuccessful',
    () async {
      final transport = _FakeHttpClient(
        const MyFatoorahResponse(
          statusCode: 200,
          data: {
            'IsSuccess': false,
            'Message': 'Validation failed',
            'ValidationErrors': [
              {'Name': 'PaymentMethod', 'Error': 'Required'},
            ],
            'Data': null,
          },
        ),
      );
      final client = HostedPaymentClient(
        MyFatoorahClient(config: config, httpClient: transport),
      );

      final result = await client.create(
        const CreateHostedPaymentRequest(
          paymentMethod: 'CARD',
          order: HostedPaymentOrder(amount: '23'),
          integrationUrls: HostedPaymentIntegrationUrls(
            redirection: 'https://your-website.com/payment-callback',
          ),
        ),
      );

      expect(result, isA<MyFatoorahFailure<CreateHostedPaymentResponse>>());
      final exception =
          (result as MyFatoorahFailure<CreateHostedPaymentResponse>).exception;
      expect(exception, isA<MyFatoorahApiException>());
      expect(exception.message, 'Validation failed');
    },
  );

  test('invalid hosted request does not call HTTP client', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: {}),
    );
    final client = HostedPaymentClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.create(
      const CreateHostedPaymentRequest(
        paymentMethod: ' ',
        order: HostedPaymentOrder(amount: ''),
        integrationUrls: HostedPaymentIntegrationUrls(redirection: ''),
      ),
    );

    expect(result, isA<MyFatoorahFailure<CreateHostedPaymentResponse>>());
    final exception =
        (result as MyFatoorahFailure<CreateHostedPaymentResponse>).exception;
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
