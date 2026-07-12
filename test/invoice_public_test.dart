import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('sends invoice through public invoices facade', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _sendPaymentResponse),
    ]);
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://backend.example.test/'),
      ),
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final result = await myFatoorah.invoices.send(
      const SendPaymentRequest(
        invoiceValue: '100',
        customer: InvoiceCustomer(name: 'name'),
        notificationOption: SendPaymentNotificationOption.link,
      ),
    );

    expect(result, isA<MyFatoorahSuccess<SendPaymentResponse>>());
    final value = (result as MyFatoorahSuccess<SendPaymentResponse>).value;
    expect(value.invoiceUrl, 'https://demo.myfatoorah.com/ie/0106230003434');
    expect(transport.requests.single.path, '/v2/SendPayment');
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

const _sendPaymentResponse = {
  'IsSuccess': true,
  'Message': 'Invoice Created Successfully!',
  'ValidationErrors': null,
  'Data': {
    'InvoiceId': 300034,
    'InvoiceURL': 'https://demo.myfatoorah.com/ie/0106230003434',
    'CustomerReference': 'noshipping-nosupplier',
    'UserDefinedField': null,
  },
};
