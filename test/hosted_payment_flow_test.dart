import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';

void main() {
  test('createPaymentUrl returns URL and identifier data', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(
        statusCode: 200,
        data: {
          'IsSuccess': true,
          'Message': '',
          'ValidationErrors': null,
          'Data': {
            'InvoiceId': '6148108',
            'PaymentId': '07076148071303658773',
            'PaymentURL':
                'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
            'PaymentCompleted': false,
            'TransactionDetails': null,
          },
        },
      ),
    ]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.payments.hosted.createPaymentUrl(
      const CreateHostedPaymentRequest(
        paymentMethod: 'CARD',
        order: HostedPaymentOrder(amount: '23'),
        integrationUrls: HostedPaymentIntegrationUrls(
          redirection: 'https://your-website.com/payment-callback',
        ),
      ),
    );

    expect(result, isA<MyFatoorahSuccess<HostedPaymentFlowResult>>());
    final value = (result as MyFatoorahSuccess<HostedPaymentFlowResult>).value;
    expect(value.invoiceId, '6148108');
    expect(value.paymentId, '07076148071303658773');
    expect(
      value.paymentUrl,
      'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
    );
    expect(transport.requests.single.path, '/v3/payments');
  });

  test('confirmFromCallback calls status using parsed paymentId', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _paymentDetailsSample),
    ]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.payments.hosted.confirmFromCallback(
      'https://your-website.com/payment-callback'
      '?paymentId=07076389662322472373',
    );

    expect(result, isA<MyFatoorahSuccess<GetPaymentDetailsResponse>>());
    final value =
        (result as MyFatoorahSuccess<GetPaymentDetailsResponse>).value;
    expect(value.isPaid, isTrue);
    expect(transport.requests.single.path, '/v3/payments/07076389662322472373');
  });

  test('confirmFromCallback fails safely if paymentId is missing', () async {
    final transport = _QueuedHttpClient([]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.payments.hosted.confirmFromCallback(
      'https://your-website.com/payment-callback?status=failed',
    );

    expect(result, isA<MyFatoorahFailure<GetPaymentDetailsResponse>>());
    expect(transport.requests, isEmpty);
    final exception =
        (result as MyFatoorahFailure<GetPaymentDetailsResponse>).exception;
    expect(exception, isA<MyFatoorahValidationException>());
  });

  test('confirmFromCallback fails safely if paymentId is whitespace', () async {
    final transport = _QueuedHttpClient([]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.payments.hosted.confirmFromCallback(
      'https://your-website.com/payment-callback?paymentId=%20%20%20',
    );

    expect(result, isA<MyFatoorahFailure<GetPaymentDetailsResponse>>());
    expect(transport.requests, isEmpty);
    final exception =
        (result as MyFatoorahFailure<GetPaymentDetailsResponse>).exception;
    expect(exception, isA<MyFatoorahValidationException>());
  });
}

MyFatoorah _sdkWith(_QueuedHttpClient transport) {
  return MyFatoorah.internal(
    config: MyFatoorahConfig.backendProxy(
      backendBaseUrl: Uri.parse('https://backend.example.test/'),
    ),
    baseUrl: Uri.parse('https://example.test/'),
    httpClient: transport,
  );
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

const _paymentDetailsSample = {
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
