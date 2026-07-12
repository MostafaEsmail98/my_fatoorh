import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('gets payment status through public payments facade', () async {
    final transport = _FakeHttpClient(
      const MyFatoorahResponse(
        statusCode: 200,
        data: _officialPaymentDetailsSample,
      ),
    );
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://backend.example.test/'),
      ),
      baseUrl: Uri.parse('https://example.test/'),
      httpClient: transport,
    );

    final result = await myFatoorah.payments.status.get('07076389662322472373');

    expect(result, isA<MyFatoorahSuccess<GetPaymentDetailsResponse>>());
    final value =
        (result as MyFatoorahSuccess<GetPaymentDetailsResponse>).value;
    expect(value.isPaid, isTrue);
    expect(value.invoice.status, 'PAID');
    expect(transport.request?.path, '/v3/payments/07076389662322472373');
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

const _officialPaymentDetailsSample = {
  'IsSuccess': true,
  'Message': '',
  'ValidationErrors': null,
  'Data': {
    'Invoice': {
      'Id': '6389662',
      'Status': 'PAID',
      'Reference': '2025060928',
      'CreationDate': '2025-12-24T16:23:49.5900000Z',
      'ExpirationDate': '2026-06-22T16:23:49.5900000Z',
      'ExternalIdentifier': null,
      'UserDefinedField': '',
      'MetaData': null,
    },
    'Transaction': {
      'Id': '104690',
      'Status': 'SUCCESS',
      'PaymentMethod': 'VISA/MASTER',
      'PaymentId': '07076389662322472373',
      'ReferenceId': '535816104690',
      'TrackId': '24-12-2025_3224723',
      'AuthorizationId': '104690',
      'TransactionDate': '2025-12-24T16:23:50.7000000Z',
      'ECI': '',
      'IP': {'Address': '', 'Country': ''},
      'Error': {'Code': '', 'Message': ''},
      'Card': {
        'NameOnCard': 'Muhammad',
        'Number': '512345xxxxxx0008',
        'Token': 'TKN-0fb06aac-634d-418a-bf78-953202b67b53',
        'PanHash':
            'b888aa5f23a817883d4d12c74044bab1ae6ee65dc8d6e11515394aba452b273b',
        'ExpiryMonth': '12',
        'ExpiryYear': '36',
        'Brand': 'Mastercard',
        'Issuer': 'Test Bank',
        'IssuerCountry': 'KWT',
        'FundingMethod': 'credit',
      },
    },
    'Customer': {
      'Reference': '',
      'Name': 'Anonymous',
      'Mobile': '+965',
      'Email': '',
    },
    'Amount': {
      'BaseCurrency': 'KWD',
      'ValueInBaseCurrency': '20',
      'ServiceCharge': '0.4',
      'ServiceChargeVAT': '0.06',
      'ReceivableAmount': '19.54',
      'DisplayCurrency': 'KWD',
      'ValueInDisplayCurrency': '20',
      'PayCurrency': 'KWD',
      'ValueInPayCurrency': '20',
    },
    'Suppliers': [],
  },
};
