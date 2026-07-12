import 'package:json_annotation/json_annotation.dart';

import '../../serialization/my_fatoorah_json.dart';

part 'send_payment_response.g.dart';

/// Data returned by `POST /v2/SendPayment`.
@JsonSerializable()
final class SendPaymentResponse {
  /// Creates a SendPayment response.
  const SendPaymentResponse({
    required this.invoiceId,
    required this.invoiceUrl,
    this.customerReference,
    this.userDefinedField,
  });

  /// Invoice number used to inquire payment status later.
  @JsonKey(name: 'InvoiceId')
  final int invoiceId;

  /// Invoice URL sent to the customer to proceed with payment.
  @JsonKey(name: 'InvoiceURL')
  final String invoiceUrl;

  /// Merchant order or transaction reference returned by MyFatoorah.
  @JsonKey(name: 'CustomerReference')
  final String? customerReference;

  /// Custom field returned by MyFatoorah.
  @JsonKey(name: 'UserDefinedField')
  final String? userDefinedField;

  /// Creates a SendPayment response from JSON.
  factory SendPaymentResponse.fromJson(Map<String, Object?> json) =>
      _$SendPaymentResponseFromJson(json);

  /// Converts this response to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$SendPaymentResponseToJson(this));
  }
}
