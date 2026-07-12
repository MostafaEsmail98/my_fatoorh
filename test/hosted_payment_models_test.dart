import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';
import 'package:my_fatoorah/src/payments/hosted/models/create_hosted_payment_request.dart';
import 'package:my_fatoorah/src/payments/hosted/models/create_hosted_payment_response.dart';
import 'package:my_fatoorah/src/payments/hosted/models/hosted_payment_status.dart';

void main() {
  test('serializes official hosted payment create request sample', () {
    const request = CreateHostedPaymentRequest(
      paymentMethod: 'CARD',
      order: HostedPaymentOrder(amount: '23'),
      integrationUrls: HostedPaymentIntegrationUrls(
        redirection: 'https://your-website.com/payment-callback',
      ),
    );

    expect(request.validate(), isEmpty);
    expect(request.toJson(), {
      'PaymentMethod': 'CARD',
      'Order': {'Amount': '23'},
      'IntegrationUrls': {
        'Redirection': 'https://your-website.com/payment-callback',
      },
    });
  });

  test('parses official hosted payment create request sample', () {
    final request = CreateHostedPaymentRequest.fromJson({
      'PaymentMethod': 'CARD',
      'Order': {'Amount': 23},
      'IntegrationUrls': {
        'Redirection': 'https://your-website.com/payment-callback',
      },
    });

    expect(request.paymentMethod, 'CARD');
    expect(request.order.amount, '23');
    expect(
      request.integrationUrls.redirection,
      'https://your-website.com/payment-callback',
    );
  });

  test('validates documented required request fields', () {
    const request = CreateHostedPaymentRequest(
      paymentMethod: '',
      order: HostedPaymentOrder(amount: ''),
      integrationUrls: HostedPaymentIntegrationUrls(redirection: ''),
    );

    expect(request.validate(), [
      'PaymentMethod is required.',
      'Order.Amount is required.',
      'IntegrationUrls.Redirection is required.',
    ]);
  });

  test('parses official hosted payment create response sample', () {
    final response = MyFatoorahApiResponse<CreateHostedPaymentResponse>.fromJson(
      {
        'IsSuccess': true,
        'Message': '',
        'ValidationErrors': null,
        'Data': {
          'InvoiceId': '6148108',
          'PaymentId': null,
          'PaymentURL':
              'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
          'PaymentCompleted': false,
          'TransactionDetails': null,
        },
      },
      (json) =>
          CreateHostedPaymentResponse.fromJson(json! as Map<String, Object?>),
    );

    expect(response.isSuccess, isTrue);
    expect(response.data?.invoiceId, '6148108');
    expect(response.data?.paymentId, isNull);
    expect(
      response.data?.paymentUrl,
      'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
    );
    expect(response.data?.paymentCompleted, isFalse);
    expect(response.data?.transactionDetails, isNull);
    expect(response.data?.hostedPayment.status, HostedPaymentStatus.created);
  });

  test('serializes official hosted payment create response data sample', () {
    const response = CreateHostedPaymentResponse(
      invoiceId: '6148108',
      paymentId: null,
      paymentUrl:
          'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
      paymentCompleted: false,
      transactionDetails: null,
    );

    expect(response.toJson(), {
      'InvoiceId': '6148108',
      'PaymentURL':
          'https://demo.MyFatoorah.com/KWT/ie/050754719614810863-ce9138bf',
      'PaymentCompleted': false,
    });
  });
}
