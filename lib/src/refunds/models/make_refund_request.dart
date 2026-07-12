import 'package:json_annotation/json_annotation.dart';

import '../../serialization/my_fatoorah_decimal_converter.dart';
import '../../serialization/my_fatoorah_json.dart';

part 'make_refund_request.g.dart';

/// Request body for `POST /v2/MakeRefund`.
@JsonSerializable()
final class MakeRefundRequest {
  /// Creates a refund request.
  const MakeRefundRequest({
    required this.keyType,
    required this.key,
    required this.amount,
    this.serviceChargeOnCustomer,
    this.comment,
    this.externalIdentifier,
    this.amountDeductedFromSupplier,
  });

  /// Creates a refund request using an invoice ID.
  const MakeRefundRequest.invoiceId({
    required String invoiceId,
    required this.amount,
    this.serviceChargeOnCustomer,
    this.comment,
    this.externalIdentifier,
    this.amountDeductedFromSupplier,
  }) : keyType = RefundKeyType.invoiceId,
       key = invoiceId;

  /// Creates a refund request using a payment ID.
  const MakeRefundRequest.paymentId({
    required String paymentId,
    required this.amount,
    this.serviceChargeOnCustomer,
    this.comment,
    this.externalIdentifier,
    this.amountDeductedFromSupplier,
  }) : keyType = RefundKeyType.paymentId,
       key = paymentId;

  /// Type of key used for refund lookup.
  @JsonKey(name: 'KeyType')
  final RefundKeyType keyType;

  /// InvoiceId or PaymentId value, based on [keyType].
  @JsonKey(name: 'Key')
  final String key;

  /// Whether the customer is charged for service fees.
  @JsonKey(name: 'ServiceChargeOnCustomer')
  final bool? serviceChargeOnCustomer;

  /// Amount to refund.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Amount')
  final String amount;

  /// Extra comments for merchant reference.
  @JsonKey(name: 'Comment')
  final String? comment;

  /// External data associated with the refund and received in webhook.
  @JsonKey(name: 'ExternalIdentifier')
  final String? externalIdentifier;

  /// Amount deducted from the supplier in the refund process.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'AmountDeductedFromSupplier')
  final String? amountDeductedFromSupplier;

  /// Creates a refund request from JSON.
  factory MakeRefundRequest.fromJson(Map<String, Object?> json) =>
      _$MakeRefundRequestFromJson(json);

  /// Converts this request to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$MakeRefundRequestToJson(this));
  }

  /// Returns validation messages for documented required fields.
  List<String> validate() {
    final parsedAmount = num.tryParse(amount.trim());
    final parsedSupplierAmount = amountDeductedFromSupplier == null
        ? null
        : num.tryParse(amountDeductedFromSupplier!.trim());
    return [
      if (key.trim().isEmpty)
        '${keyType == RefundKeyType.invoiceId ? 'InvoiceId' : 'PaymentId'} is required.',
      if (amount.trim().isEmpty)
        'Amount is required.'
      else if (parsedAmount == null || parsedAmount <= 0)
        'Amount must be positive.',
      if (amountDeductedFromSupplier != null &&
          amountDeductedFromSupplier!.trim().isNotEmpty &&
          (parsedSupplierAmount == null || parsedSupplierAmount < 0))
        'AmountDeductedFromSupplier must be zero or positive.',
    ];
  }
}

/// Documented key types accepted by MakeRefund.
enum RefundKeyType {
  /// Refund by InvoiceId.
  @JsonValue('InvoiceId')
  invoiceId,

  /// Refund by PaymentId.
  @JsonValue('PaymentId')
  paymentId,
}
