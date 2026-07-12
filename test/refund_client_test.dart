import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_config.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_result.dart';
import 'package:my_fatoorah/src/exceptions/my_fatoorah_validation_exception.dart';
import 'package:my_fatoorah/src/refunds/models/make_refund_request.dart';
import 'package:my_fatoorah/src/refunds/models/make_refund_response.dart';
import 'package:my_fatoorah/src/refunds/refund_client.dart';

void main() {
  final config = MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://backend.example.test/'),
  );

  test('makes refund through POST /v2/MakeRefund', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _makeRefundResponse),
    );
    final client = RefundClient(
      MyFatoorahClient(
        config: config,
        baseUrl: Uri.parse('https://example.test/'),
        httpClient: transport,
      ),
    );

    final result = await client.make(_validRequest);

    expect(result, isA<MyFatoorahSuccess<MakeRefundResponse>>());
    final value = (result as MyFatoorahSuccess<MakeRefundResponse>).value;
    expect(value.refundId, 246275);
    expect(transport.request?.method, MyFatoorahHttpMethod.post);
    expect(transport.request?.path, '/v2/MakeRefund');
    expect(transport.request?.body, {
      'KeyType': 'InvoiceId',
      'Key': '6424767',
      'Amount': '1',
    });
  });

  test('validation failure does not call HTTP client', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _makeRefundResponse),
    );
    final client = RefundClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.make(
      const MakeRefundRequest.paymentId(paymentId: '   ', amount: ''),
    );

    expect(result, isA<MyFatoorahFailure<MakeRefundResponse>>());
    final failure = result as MyFatoorahFailure<MakeRefundResponse>;
    expect(failure.exception, isA<MyFatoorahValidationException>());
    expect(transport.request, isNull);
  });

  test('backendProxy mode uses backend base URL', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(statusCode: 200, data: _makeRefundResponse),
    );
    final client = RefundClient(
      MyFatoorahClient(config: config, httpClient: transport),
    );

    final result = await client.make(_validRequest);

    expect(result, isA<MyFatoorahSuccess<MakeRefundResponse>>());
    expect(transport.baseUrl, Uri.parse('https://backend.example.test/'));
    expect(transport.request?.path, '/v2/MakeRefund');
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

const _validRequest = MakeRefundRequest.invoiceId(
  invoiceId: '6424767',
  amount: '1',
);

const _makeRefundResponse = {
  'IsSuccess': true,
  'Message': 'Refund Created Successfully!',
  'ValidationErrors': null,
  'Data': {
    'Key': '6424767',
    'RefundId': 246275,
    'RefundReference': '2026000012',
    'RefundInvoiceId': 6426263,
    'ExternalIdentifier': 'refund-external-id',
    'Amount': 1.0,
    'Comment': 'partial refund to the customer',
  },
};
