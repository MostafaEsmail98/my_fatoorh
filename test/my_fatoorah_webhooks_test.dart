import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

void main() {
  test('parses official payment status webhook sample from map', () {
    final result = MyFatoorahWebhookParser.parseMap(_officialPaymentWebhook);

    expect(result, isA<MyFatoorahSuccess<MyFatoorahWebhookEvent>>());
    final event = (result as MyFatoorahSuccess<MyFatoorahWebhookEvent>).value;
    expect(event.type, MyFatoorahWebhookType.paymentStatusChanged);
    expect(event.code, 1);
    expect(event.name, 'PAYMENT_STATUS_CHANGED');
    expect(event.countryIsoCode, 'KWT');
    expect(event.reference, 'WH-626519');
    expect(event.paymentDetails?.invoice.id, '6409988');
    expect(event.paymentDetails?.transaction.status, 'SUCCESS');
    expect(event.paymentDetails?.isPaid, isTrue);
  });

  test('parses official payment status webhook sample from JSON string', () {
    final result = MyFatoorahWebhookParser.parseJsonString(
      jsonEncode(_officialPaymentWebhook),
    );

    expect(result, isA<MyFatoorahSuccess<MyFatoorahWebhookEvent>>());
    final event = (result as MyFatoorahSuccess<MyFatoorahWebhookEvent>).value;
    expect(event.paymentDetails?.transaction.paymentId, '07076409988323998875');
  });

  test('returns safe failure for invalid webhook payload', () {
    final result = MyFatoorahWebhookParser.parseJsonString('{bad-json');

    expect(result, isA<MyFatoorahFailure<MyFatoorahWebhookEvent>>());
  });

  test('builds official payment status signature payload order', () {
    final event =
        (MyFatoorahWebhookParser.parseMap(_officialPaymentWebhook)
                as MyFatoorahSuccess<MyFatoorahWebhookEvent>)
            .value;

    expect(
      MyFatoorahWebhookVerifier.signaturePayloadFor(event),
      'Invoice.Id=6409988,Invoice.Status=PAID,'
      'Transaction.Status=SUCCESS,'
      'Transaction.PaymentId=07076409988323998875,'
      'Invoice.ExternalIdentifier=asdqwd-f13sdf-fasjkz',
    );
  });

  test('verifies payment status webhook signature with secret key', () {
    final event =
        (MyFatoorahWebhookParser.parseMap(_officialPaymentWebhook)
                as MyFatoorahSuccess<MyFatoorahWebhookEvent>)
            .value;
    final orderedData = MyFatoorahWebhookVerifier.signaturePayloadFor(event)!;
    final signature = MyFatoorahWebhookVerifier.computeSignature(
      orderedData: orderedData,
      secretKey: 'portal-secret-key',
    );

    final result = MyFatoorahWebhookVerifier.verify(
      event: event,
      signature: signature,
      secretKey: 'portal-secret-key',
    );

    expect(result.isSupported, isTrue);
    expect(result.isValid, isTrue);
    expect(result.message, isNull);
  });

  test('returns safe invalid result for signature mismatch', () {
    final event =
        (MyFatoorahWebhookParser.parseMap(_officialPaymentWebhook)
                as MyFatoorahSuccess<MyFatoorahWebhookEvent>)
            .value;

    final result = MyFatoorahWebhookVerifier.verify(
      event: event,
      signature: 'invalid',
      secretKey: 'portal-secret-key',
    );

    expect(result.isSupported, isTrue);
    expect(result.isValid, isFalse);
    expect(result.message, 'Webhook signature mismatch.');
  });
}

const _officialPaymentWebhook = {
  'Event': {
    'Code': 1,
    'Name': 'PAYMENT_STATUS_CHANGED',
    'CountryIsoCode': 'KWT',
    'CreationDate': '2026-01-04T08:15:00.9500000Z',
    'Reference': 'WH-626519',
  },
  'Data': {
    'Invoice': {
      'Id': '6409988',
      'Status': 'PAID',
      'Reference': '2026000073',
      'CreationDate': '2026-01-04T08:14:49.897Z',
      'ExpirationDate': '2026-01-04T10:08:36Z',
      'UserDefinedField': '',
      'ExternalIdentifier': 'asdqwd-f13sdf-fasjkz',
      'MetaData': {
        'UDF1': 'dsa',
        'UDF2': '145',
        'UDF3': '8586',
        'UDF4': '12039',
        'UDF5': '748gsvf',
      },
    },
    'Transaction': {
      'Id': '86781',
      'Status': 'SUCCESS',
      'PaymentMethod': 'VISA/MASTER',
      'PaymentId': '07076409988323998875',
      'ReferenceId': '600408086781',
      'TrackId': '04-01-2026_3239988',
      'AuthorizationId': '086781',
      'TransactionDate': '2026-01-04T08:15:00.8834074Z',
      'ECI': '02',
      'IP': {'Address': '41.40.252.158', 'Country': 'Egypt'},
      'Error': {'Code': '', 'Message': ''},
      'Card': {
        'NameOnCard': '',
        'Number': '512345xxxxxx0008',
        'Token': 'TKN-ecbc9523-8f87-4b72-8009-9859d89d6b45',
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
    'Customer': {'Name': 'Anonymous', 'Mobile': '+965', 'Email': ''},
    'Amount': {
      'BaseCurrency': 'KWD',
      'ValueInBaseCurrency': '1',
      'ServiceCharge': '0.02',
      'ServiceChargeVAT': '0.003',
      'ReceivableAmount': '0.51',
      'DisplayCurrency': 'KWD',
      'ValueInDisplayCurrency': '1',
      'PayCurrency': 'KWD',
      'ValueInPayCurrency': '1',
    },
    'Suppliers': [
      {
        'Code': 212,
        'Name': 'Jed Auer',
        'InvoiceShare': '1',
        'ProposedShare': '',
        'DepositShare': '0.467',
      },
    ],
  },
};
