import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';
import 'package:my_fatoorah/src/payments/status/models/get_payment_details_response.dart';

void main() {
  test('parses official Get Payment Details sample', () {
    final response = MyFatoorahApiResponse<GetPaymentDetailsResponse>.fromJson(
      _officialPaymentDetailsSample,
      (json) =>
          GetPaymentDetailsResponse.fromJson(json! as Map<String, Object?>),
    );

    final details = response.data!;
    expect(response.isSuccess, isTrue);
    expect(details.invoice.id, '6389662');
    expect(details.invoice.status, 'PAID');
    expect(details.invoice.isPaid, isTrue);
    expect(details.transaction.id, '104690');
    expect(details.transaction.status, 'SUCCESS');
    expect(details.transaction.isSuccess, isTrue);
    expect(details.transaction.ip?.address, '');
    expect(details.transaction.error?.code, '');
    expect(details.transaction.card?.brand, 'Mastercard');
    expect(details.customer.name, 'Anonymous');
    expect(details.amount.baseCurrency, 'KWD');
    expect(details.amount.valueInBaseCurrency, '20');
    expect(details.suppliers, isEmpty);
    expect(details.isPaid, isTrue);
    expect(details.isPending, isFalse);
    expect(details.isFailed, isFalse);
  });

  test('serializes official Get Payment Details sample data', () {
    final response = GetPaymentDetailsResponse.fromJson(
      _officialPaymentDetailsSample['Data']! as Map<String, Object?>,
    );

    expect(response.toJson(), {
      'Invoice': {
        'Id': '6389662',
        'Status': 'PAID',
        'Reference': '2025060928',
        'CreationDate': '2025-12-24T16:23:49.590Z',
        'ExpirationDate': '2026-06-22T16:23:49.590Z',
        'UserDefinedField': '',
      },
      'Transaction': {
        'Id': '104690',
        'Status': 'SUCCESS',
        'PaymentMethod': 'VISA/MASTER',
        'PaymentId': '07076389662322472373',
        'ReferenceId': '535816104690',
        'TrackId': '24-12-2025_3224723',
        'AuthorizationId': '104690',
        'TransactionDate': '2025-12-24T16:23:50.700Z',
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
    });
  });
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
