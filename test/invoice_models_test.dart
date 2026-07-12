import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';

void main() {
  test('serializes official SendPayment request sample fields', () {
    const request = SendPaymentRequest(
      invoiceValue: '100',
      customer: InvoiceCustomer(
        name: 'name',
        mobileCountryCode: '+965',
        mobile: '12345678',
        email: 'customer@example.com',
      ),
      notificationOption: SendPaymentNotificationOption.all,
      displayCurrencyIso: 'kwd',
      callBackUrl: 'https://yoursite.com/success',
      errorUrl: 'https://yoursite.com/error',
      language: 'en',
      customerReference: 'noshipping-nosupplier',
      customerAddress: MyFatoorahAddress(
        block: 'string',
        street: 'string',
        houseBuildingNo: 'string',
        address: 'address',
        addressInstructions: 'string',
      ),
      invoiceItems: [
        InvoiceItem(itemName: 'string', quantity: 20, unitPrice: '5'),
      ],
    );

    expect(request.toJson(), {
      'InvoiceValue': '100',
      'CustomerName': 'name',
      'MobileCountryCode': '+965',
      'CustomerMobile': '12345678',
      'CustomerEmail': 'customer@example.com',
      'NotificationOption': 'ALL',
      'DisplayCurrencyIso': 'kwd',
      'CallBackUrl': 'https://yoursite.com/success',
      'ErrorUrl': 'https://yoursite.com/error',
      'Language': 'en',
      'CustomerReference': 'noshipping-nosupplier',
      'CustomerAddress': {
        'Block': 'string',
        'Street': 'string',
        'HouseBuildingNo': 'string',
        'Address': 'address',
        'AddressInstructions': 'string',
      },
      'InvoiceItems': [
        {'ItemName': 'string', 'Quantity': 20, 'UnitPrice': '5'},
      ],
    });
  });

  test('parses official SendPayment response sample', () {
    final response = MyFatoorahApiResponse<SendPaymentResponse>.fromJson(
      _officialSendPaymentResponse,
      (json) => SendPaymentResponse.fromJson(json! as Map<String, Object?>),
    );

    expect(response.isSuccess, isTrue);
    expect(response.message, 'Invoice Created Successfully!');
    expect(response.data?.invoiceId, 300034);
    expect(
      response.data?.invoiceUrl,
      'https://demo.myfatoorah.com/ie/0106230003434',
    );
    expect(response.data?.customerReference, 'noshipping-nosupplier');
    expect(response.data?.userDefinedField, isNull);
  });

  test('validates required and conditional SendPayment fields', () {
    const request = SendPaymentRequest(
      invoiceValue: '0',
      customer: InvoiceCustomer(name: ''),
      notificationOption: SendPaymentNotificationOption.email,
    );

    expect(request.validate(), [
      'InvoiceValue must be positive.',
      'CustomerName is required.',
      'CustomerEmail is required when NotificationOption is EML or ALL.',
    ]);
  });
}

const _officialSendPaymentResponse = {
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
