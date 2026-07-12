import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/checkout/my_fatoorah_checkout.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_http_client.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_request.dart';
import 'package:my_fatoorah/src/client/my_fatoorah_response.dart';
import 'package:my_fatoorah/src/payments/hosted/hosted_payment_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  test('create checkout calls payment methods optionally', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _methodsResponseSample),
      const MyFatoorahResponse(statusCode: 200, data: _hostedResponseSample),
    ]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.checkout.createHostedCheckout(
      const HostedCheckoutRequest(
        amount: '10.000',
        currencyIso: 'KWD',
        redirectUrl: 'https://merchant.example.com/callback',
        loadPaymentMethods: true,
      ),
    );

    expect(result, isA<MyFatoorahSuccess<HostedCheckoutResult>>());
    final checkout = (result as MyFatoorahSuccess<HostedCheckoutResult>).value;
    expect(checkout.paymentMethods.single.paymentMethodCode, 'ap');
    expect(checkout.invoiceId, '6148108');
    expect(transport.requests.map((request) => request.path), [
      '/v2/InitiatePayment',
      '/v3/payments',
    ]);
  });

  test(
    'create checkout creates hosted payment without methods by default',
    () async {
      final transport = _QueuedHttpClient([
        const MyFatoorahResponse(statusCode: 200, data: _hostedResponseSample),
      ]);
      final myFatoorah = _sdkWith(transport);

      final result = await myFatoorah.checkout.createHostedCheckout(
        const HostedCheckoutRequest(
          amount: '10.000',
          currencyIso: 'KWD',
          redirectUrl: 'https://merchant.example.com/callback',
        ),
      );

      expect(result, isA<MyFatoorahSuccess<HostedCheckoutResult>>());
      final checkout =
          (result as MyFatoorahSuccess<HostedCheckoutResult>).value;
      expect(checkout.paymentMethods, isEmpty);
      expect(checkout.paymentUrl, contains('https://demo.MyFatoorah.com'));
      expect(transport.requests.single.path, '/v3/payments');
      expect(transport.requests.single.body, {
        'PaymentMethod': 'CARD',
        'Order': {'Amount': '10.000'},
        'IntegrationUrls': {
          'Redirection': 'https://merchant.example.com/callback',
        },
      });
    },
  );

  test('invalid checkout request fails before HTTP', () async {
    final transport = _QueuedHttpClient([]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.checkout.createHostedCheckout(
      const HostedCheckoutRequest(
        amount: '0',
        currencyIso: '',
        redirectUrl: 'not absolute',
        customer: CheckoutCustomer(email: 'invalid-email'),
      ),
    );

    expect(result, isA<MyFatoorahFailure<HostedCheckoutResult>>());
    final exception =
        (result as MyFatoorahFailure<HostedCheckoutResult>).exception;
    expect(exception, isA<MyFatoorahValidationException>());
    expect(transport.requests, isEmpty);
  });

  test('open checkout delegates to hosted launcher', () async {
    final openedUrls = <Uri>[];
    final checkout = _checkoutWithLauncher(
      HostedPaymentLauncher(
        launch: (url, {required mode}) async {
          openedUrls.add(url);
          return true;
        },
        supportsLaunchModeFn: (mode) async =>
            mode == LaunchMode.inAppBrowserView,
      ),
    );

    final result = await checkout.openHostedCheckout(
      const HostedCheckoutResult(
        invoiceId: '6148108',
        paymentUrl: 'https://demo.myfatoorah.com/pay',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(openedUrls.single, Uri.parse('https://demo.myfatoorah.com/pay'));
  });

  test('confirm callback delegates to hosted confirmation', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _paymentDetailsSample),
    ]);
    final myFatoorah = _sdkWith(transport);

    final result = await myFatoorah.checkout.confirmHostedCallback(
      'https://merchant.example.com/callback?paymentId=07076389662322472373',
    );

    expect(result, isA<MyFatoorahSuccess<GetPaymentDetailsResponse>>());
    expect(transport.requests.single.path, '/v3/payments/07076389662322472373');
  });

  test('backendProxy mode uses backend base URL', () async {
    final transport = _QueuedHttpClient([
      const MyFatoorahResponse(statusCode: 200, data: _hostedResponseSample),
    ]);
    final myFatoorah = MyFatoorah.internal(
      config: MyFatoorahConfig.backendProxy(
        backendBaseUrl: Uri.parse('https://merchant.example.com/myfatoorah/'),
      ),
      httpClient: transport,
    );

    final result = await myFatoorah.checkout.createHostedCheckout(
      const HostedCheckoutRequest(
        amount: '10',
        currencyIso: 'KWD',
        redirectUrl: 'https://merchant.example.com/callback',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(
      transport.calls.single.baseUrl,
      Uri.parse('https://merchant.example.com/myfatoorah/'),
    );
    expect(transport.requests.single.path, '/v3/payments');
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

MyFatoorahCheckout _checkoutWithLauncher(HostedPaymentLauncher launcher) {
  final client = MyFatoorahClient(
    config: MyFatoorahConfig.backendProxy(
      backendBaseUrl: Uri.parse('https://backend.example.test/'),
    ),
    httpClient: _QueuedHttpClient([]),
  );
  return createMyFatoorahCheckout(client, launcher: launcher);
}

final class _QueuedHttpClient implements MyFatoorahHttpClient {
  _QueuedHttpClient(this._responses);

  final List<MyFatoorahResponse> _responses;
  final List<MyFatoorahRequest<Object?>> requests = [];
  final List<_HttpCall> calls = [];

  @override
  Future<MyFatoorahResponse> send<T>(
    Uri baseUrl,
    MyFatoorahRequest<T> request, {
    required MyFatoorahConfig config,
    required Map<String, String> headers,
  }) async {
    requests.add(request as MyFatoorahRequest<Object?>);
    calls.add(_HttpCall(baseUrl));
    return _responses[requests.length - 1];
  }
}

final class _HttpCall {
  const _HttpCall(this.baseUrl);

  final Uri baseUrl;
}

const _hostedResponseSample = {
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
};

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
