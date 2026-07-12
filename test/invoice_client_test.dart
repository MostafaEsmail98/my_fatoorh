import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_config.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_result.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_validation_exception.dart';
import 'package:my_fatoorah/src/invoices/invoice_client.dart';
import 'package:my_fatoorah/src/invoices/models/invoice_customer.dart';
import 'package:my_fatoorah/src/invoices/models/send_payment_request.dart';
import 'package:my_fatoorah/src/invoices/models/send_payment_response.dart';

void main() {
  final config = MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://backend.example.test/'),
  );

  test('sends invoice through POST /v2/SendPayment', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _sendPaymentResponse),
    );
    final client = InvoiceClient(
      MyFatoorahClient(
        config: config,
        baseUrl: Uri.parse('https://example.test/'),
        httpClient: transport,
      ),
    );

    final result = await client.send(_validRequest);

    expect(result, isA<MyFatoorahSuccess<SendPaymentResponse>>());
    final value = (result as MyFatoorahSuccess<SendPaymentResponse>).value;
    expect(value.invoiceId, 300034);
    expect(transport.request?.method, MyFatoorahHttpMethod.post);
    expect(transport.request?.path, '/v2/SendPayment');
    expect(transport.request?.body, {
      'InvoiceValue': '100',
      'CustomerName': 'name',
      'NotificationOption': 'LNK',
    });
  });

  test('validation failure does not call HTTP client', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _sendPaymentResponse),
    );
    final client = InvoiceClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.send(
      const SendPaymentRequest(
        invoiceValue: '',
        customer: InvoiceCustomer(name: ''),
        notificationOption: SendPaymentNotificationOption.link,
      ),
    );

    expect(result, isA<MyFatoorahFailure<SendPaymentResponse>>());
    final failure = result as MyFatoorahFailure<SendPaymentResponse>;
    expect(failure.exception, isA<MyFatoorahValidationException>());
    expect(transport.request, isNull);
  });

  test('backendProxy mode uses backend base URL', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _sendPaymentResponse),
    );
    final client = InvoiceClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.send(_validRequest);

    expect(result, isA<MyFatoorahSuccess<SendPaymentResponse>>());
    expect(transport.baseUrl, Uri.parse('https://backend.example.test/'));
    expect(transport.request?.path, '/v2/SendPayment');
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

const _validRequest = SendPaymentRequest(
  invoiceValue: '100',
  customer: InvoiceCustomer(name: 'name'),
  notificationOption: SendPaymentNotificationOption.link,
);

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
