import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('gets payment methods through public payments facade', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _methodsResponseSample),
    ]);
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://backend.example.test/'),
      ),
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final result = await myFatoorah.payments.methods.get(
      const InitiatePaymentRequest(invoiceAmount: '100', currencyIso: 'KWD'),
    );

    expect(result, isA<MyFatoorahSuccess<InitiatePaymentResponse>>());
    final value = (result as MyFatoorahSuccess<InitiatePaymentResponse>).value;
    expect(value.paymentMethods.single.isApplePay, isTrue);
    expect(transport.requests.single.path, '/v2/InitiatePayment');
  });
}

final class _QueuedHttpClient implements MyFatoorahHttpClient {
  _QueuedHttpClient(this._responses);

  final List<MyFatoorahResponse> _responses;
  final List<MyFatoorahRequest<Object?>> requests = [];

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    requests.add(request as MyFatoorahRequest<Object?>);
    return _responses[requests.length - 1];
  }
}

const _methodsResponseSample = {
  'IsSuccess': true,
  'Message': 'Initiated Successfully!',
  'ValidationErrors': null,
  'Data': {
    'PaymentMethods': [
      {
        'PaymentMethodId': 11,
        'PaymentMethodAr': 'أبل الدفع',
        'PaymentMethodEn': 'Apple Pay',
        'PaymentMethodCode': 'ap',
        'IsDirectPayment': false,
        'ServiceCharge': 2,
        'TotalAmount': 100,
        'CurrencyIso': 'KWD',
        'ImageUrl': 'https://demo.myfatoorah.com/imgs/payment-methods/ap.png',
        'IsEmbeddedSupported': true,
        'PaymentCurrencyIso': 'QAR',
      },
    ],
  },
};
