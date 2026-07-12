import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';
import 'package:my_fatoorah/src/payments/embedded/models/initiate_session_request.dart';
import 'package:my_fatoorah/src/payments/embedded/models/initiate_session_response.dart';

void main() {
  test('serializes official complete payment session request sample', () {
    const request = InitiateSessionRequest(
      paymentMode: EmbeddedPaymentMode.completePayment,
      order: InitiateSessionOrder(amount: '10'),
    );

    expect(request.toJson(), {
      'PaymentMode': 'COMPLETE_PAYMENT',
      'Order': {'Amount': '10'},
    });
  });

  test('parses official collect details session request sample', () {
    final request = InitiateSessionRequest.fromJson({
      'PaymentMode': 'COLLECT_DETAILS',
      'Order': {'Amount': 10},
    });

    expect(request.paymentMode, EmbeddedPaymentMode.collectDetails);
    expect(request.order.amount, '10');
  });

  test('parses official complete payment session response sample', () {
    final response = MyFatoorahApiResponse<InitiateSessionResponse>.fromJson(
      _completePaymentResponseSample,
      (json) => InitiateSessionResponse.fromJson(json! as Map<String, Object?>),
    );

    final data = response.data!;
    expect(response.isSuccess, isTrue);
    expect(response.message, 'Created Successfully!');
    expect(data.sessionId, 'KWT-68814db6-7510-4005-ada9-408aae9f373c');
    expect(data.encryptionKey, 'm2QTkGqSxy24hpRGmoJ50vk6cfz4VJITNxGe5/uO+Qo=');
    expect(data.operationType, 'PAY');
    expect(num.parse(data.order.amount), 10);
    expect(data.order.currency, 'KWD');
    expect(data.order.externalIdentifier, isNull);
    expect(data.customer.reference, isNull);
    expect(data.customer.cards, isNull);
    expect(data.session.sessionId, data.sessionId);
    expect(num.parse(data.session.amount), 10);
  });

  test('parses official collect details session response sample', () {
    final response = MyFatoorahApiResponse<InitiateSessionResponse>.fromJson(
      _collectDetailsResponseSample,
      (json) => InitiateSessionResponse.fromJson(json! as Map<String, Object?>),
    );

    final data = response.data!;
    expect(data.sessionId, 'KWT-7b540311-6fcd-417d-b3a8-d7166cbbf773');
    expect(data.encryptionKey, 'jWdKKGPFYmVykT6lpUIpKfuqQRKYraienXtLqhwGHRI=');
    expect(num.parse(data.order.amount), 10);
    expect(data.order.currency, 'KWD');
  });
}

const _completePaymentResponseSample = {
  'IsSuccess': true,
  'Message': 'Created Successfully!',
  'ValidationErrors': null,
  'Data': {
    'SessionId': 'KWT-68814db6-7510-4005-ada9-408aae9f373c',
    'SessionExpiry': '2025-10-02T00:52:35.6000597Z',
    'EncryptionKey': 'm2QTkGqSxy24hpRGmoJ50vk6cfz4VJITNxGe5/uO+Qo=',
    'OperationType': 'PAY',
    'Order': {'Amount': 10.0, 'Currency': 'KWD', 'ExternalIdentifier': null},
    'Customer': {'Reference': null, 'Cards': null},
  },
};

const _collectDetailsResponseSample = {
  'IsSuccess': true,
  'Message': 'Created Successfully!',
  'ValidationErrors': null,
  'Data': {
    'SessionId': 'KWT-7b540311-6fcd-417d-b3a8-d7166cbbf773',
    'SessionExpiry': '2025-09-29T00:13:14.4074096Z',
    'EncryptionKey': 'jWdKKGPFYmVykT6lpUIpKfuqQRKYraienXtLqhwGHRI=',
    'OperationType': 'PAY',
    'Order': {'Amount': 10.0, 'Currency': 'KWD', 'ExternalIdentifier': null},
    'Customer': {'Reference': null, 'Cards': null},
  },
};
