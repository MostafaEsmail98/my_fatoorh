import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_config.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_result.dart';
import 'package:my_fatoorah/src/payments/methods/models/initiate_payment_request.dart';
import 'package:my_fatoorah/src/payments/methods/models/initiate_payment_response.dart';
import 'package:my_fatoorah/src/payments/methods/payment_methods_client.dart';

void main() {
  final config = MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://backend.example.test/'),
  );

  test('gets payment methods through POST /v2/InitiatePayment', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _methodsResponseSample),
    );
    final client = PaymentMethodsClient(
      MyFatoorahClient(
        config: config,
        baseUrl: Uri.parse('https://example.test/'),
        httpClient: transport,
      ),
    );

    final result = await client.get(
      const InitiatePaymentRequest(invoiceAmount: '100', currencyIso: 'KWD'),
    );

    expect(result, isA<MyFatoorahSuccess<InitiatePaymentResponse>>());
    final value = (result as MyFatoorahSuccess<InitiatePaymentResponse>).value;
    expect(value.paymentMethods.single.paymentMethodId, 2);
    expect(transport.request?.method, MyFatoorahHttpMethod.post);
    expect(transport.request?.path, '/v2/InitiatePayment');
    expect(transport.request?.body, {
      'InvoiceAmount': '100',
      'CurrencyIso': 'KWD',
    });
    expect(transport.baseUrl, Uri.parse('https://example.test/'));
  });

  test('backendProxy mode uses backend base URL', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _methodsResponseSample),
    );
    final client = PaymentMethodsClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.get(
      const InitiatePaymentRequest(invoiceAmount: '100', currencyIso: 'KWD'),
    );

    expect(result, isA<MyFatoorahSuccess<InitiatePaymentResponse>>());
    expect(transport.baseUrl, Uri.parse('https://backend.example.test/'));
  });
}

final class _FakeHttpClient implements MyFatoorahHttpClient {
  _FakeHttpClient(this.response);

  final MyFatoorahResponse response;
  MyFatoorahRequest<Object?>? request;
  Uri? baseUrl;

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    this.baseUrl = baseUrl;
    this.request = request as MyFatoorahRequest<Object?>;
    return response;
  }
}

const _methodsResponseSample = {
  'IsSuccess': true,
  'Message': 'Initiated Successfully!',
  'ValidationErrors': null,
  'Data': {
    'PaymentMethods': [
      {
        'PaymentMethodId': 2,
        'PaymentMethodAr': 'فيزا / ماستر',
        'PaymentMethodEn': 'VISA/MASTER',
        'PaymentMethodCode': 'vm',
        'IsDirectPayment': false,
        'ServiceCharge': 0.2,
        'TotalAmount': 100,
        'CurrencyIso': 'KWD',
        'ImageUrl': 'https://demo.myfatoorah.com/imgs/payment-methods/vm.png',
        'IsEmbeddedSupported': true,
        'PaymentCurrencyIso': 'KWD',
      },
    ],
  },
};
