import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';
import 'package:my_fatoorah/src/payments/methods/models/initiate_payment_request.dart';
import 'package:my_fatoorah/src/payments/methods/models/initiate_payment_response.dart';

void main() {
  test('serializes official initiate payment request sample', () {
    const request = InitiatePaymentRequest(
      invoiceAmount: '100',
      currencyIso: 'KWD',
    );

    expect(request.toJson(), {'InvoiceAmount': '100', 'CurrencyIso': 'KWD'});
  });

  test('parses official initiate payment response sample', () {
    final response = MyFatoorahApiResponse<InitiatePaymentResponse>.fromJson(
      _officialInitiatePaymentSample,
      (json) => InitiatePaymentResponse.fromJson(json! as Map<String, Object?>),
    );

    final methods = response.data!.paymentMethods;
    expect(response.isSuccess, isTrue);
    expect(response.message, 'Initiated Successfully!');
    expect(methods, hasLength(3));

    final qpay = methods[0];
    expect(qpay.paymentMethodId, 7);
    expect(qpay.paymentMethodAr, 'البطاقات المدينة  قطر');
    expect(qpay.paymentMethodEn, 'QPay');
    expect(qpay.paymentMethodCode, 'np');
    expect(qpay.isDirectPayment, isFalse);
    expect(qpay.serviceCharge, '2.6');
    expect(qpay.totalAmount, '102.6');
    expect(qpay.currencyIso, 'KWD');
    expect(qpay.imageUrl, contains('/np.png'));
    expect(qpay.isEmbeddedSupported, isFalse);
    expect(qpay.paymentCurrencyIso, 'QAR');

    final card = methods[1];
    expect(card.isCard, isTrue);
    expect(card.isApplePay, isFalse);
    expect(card.isGooglePay, isFalse);

    final googlePay = methods[2];
    expect(googlePay.isGooglePay, isTrue);
  });
}

const _officialInitiatePaymentSample = {
  'IsSuccess': true,
  'Message': 'Initiated Successfully!',
  'ValidationErrors': null,
  'Data': {
    'PaymentMethods': [
      {
        'PaymentMethodId': 7,
        'PaymentMethodAr': 'البطاقات المدينة  قطر',
        'PaymentMethodEn': 'QPay',
        'PaymentMethodCode': 'np',
        'IsDirectPayment': false,
        'ServiceCharge': 2.6,
        'TotalAmount': 102.6,
        'CurrencyIso': 'KWD',
        'ImageUrl': 'https://demo.myfatoorah.com/imgs/payment-methods/np.png',
        'IsEmbeddedSupported': false,
        'PaymentCurrencyIso': 'QAR',
      },
      {
        'PaymentMethodId': 2,
        'PaymentMethodAr': 'فيزا / ماستر',
        'PaymentMethodEn': 'VISA/MASTER',
        'PaymentMethodCode': 'vm',
        'IsDirectPayment': false,
        'ServiceCharge': 0.2,
        'TotalAmount': 100,
        'CurrencyIso': 'KWD',
        'ImageUrl': 'https://demo.myfatoorah.com/imgs/payment-methods/vm.png',
        'IsEmbeddedSupported': true,
        'PaymentCurrencyIso': 'KWD',
      },
      {
        'PaymentMethodId': 32,
        'PaymentMethodAr': 'جوجل للدفع',
        'PaymentMethodEn': 'GooglePay',
        'PaymentMethodCode': 'gp',
        'IsDirectPayment': false,
        'ServiceCharge': 2,
        'TotalAmount': 100,
        'CurrencyIso': 'KWD',
        'ImageUrl': 'https://demo.myfatoorah.com/imgs/payment-methods/gp.png',
        'IsEmbeddedSupported': true,
        'PaymentCurrencyIso': 'KWD',
      },
    ],
  },
};
