import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('makes refund through public refunds facade', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _makeRefundResponse),
    ]);
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://backend.example.test/'),
      ),
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final result = await myFatoorah.refunds.make(
      const MakeRefundRequest.paymentId(
        paymentId: '07073110788180275773',
        amount: '1',
      ),
    );

    expect(result, isA<MyFatoorahSuccess<MakeRefundResponse>>());
    final value = (result as MyFatoorahSuccess<MakeRefundResponse>).value;
    expect(value.refundReference, '2026000012');
    expect(transport.requests.single.path, '/v2/MakeRefund');
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
