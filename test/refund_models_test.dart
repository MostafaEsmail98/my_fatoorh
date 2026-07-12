import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';

void main() {
  test('serializes official MakeRefund request sample', () {
    const request = MakeRefundRequest.invoiceId(
      invoiceId: '6424767',
      serviceChargeOnCustomer: false,
      externalIdentifier: 'refund-external-id',
      amount: '1',
      comment: 'partial refund to the customer',
      amountDeductedFromSupplier: '0',
    );

    expect(request.toJson(), {
      'KeyType': 'InvoiceId',
      'Key': '6424767',
      'ServiceChargeOnCustomer': false,
      'Amount': '1',
      'Comment': 'partial refund to the customer',
      'ExternalIdentifier': 'refund-external-id',
      'AmountDeductedFromSupplier': '0',
    });
  });

  test('parses official MakeRefund response sample', () {
    final response = MyFatoorahApiResponse<MakeRefundResponse>.fromJson(
      _officialMakeRefundResponse,
      (json) => MakeRefundResponse.fromJson(json! as Map<String, Object?>),
    );

    expect(response.isSuccess, isTrue);
    expect(response.message, 'Refund Created Successfully!');
    expect(response.data?.key, '6424767');
    expect(response.data?.refundId, 246275);
    expect(response.data?.refundReference, '2026000012');
    expect(response.data?.refundInvoiceId, '6426263');
    expect(response.data?.externalIdentifier, 'refund-external-id');
    expect(num.parse(response.data!.amount), 1);
    expect(response.data?.comment, 'partial refund to the customer');
  });

  test('validates documented required MakeRefund fields', () {
    const request = MakeRefundRequest.invoiceId(invoiceId: '', amount: '0');

    expect(request.validate(), [
      'InvoiceId is required.',
      'Amount must be positive.',
    ]);
  });
}

const _officialMakeRefundResponse = {
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
