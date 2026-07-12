import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_json.dart';
import 'hosted_payment_status.dart';

part 'hosted_payment.g.dart';

/// SDK value object representing a created hosted payment.
@JsonSerializable()
final class HostedPayment {
  /// Creates hosted payment details.
  const HostedPayment({
    required this.invoiceId,
    this.paymentId,
    required this.paymentUrl,
    required this.status,
  });

  /// Created invoice identifier.
  @JsonKey(name: 'InvoiceId')
  final String invoiceId;

  /// Payment identifier, when available.
  @JsonKey(name: 'PaymentId')
  final String? paymentId;

  /// Hosted payment URL.
  @JsonKey(name: 'PaymentURL')
  final String paymentUrl;

  /// SDK-level status derived from documented create-payment response fields.
  @JsonKey(name: 'Status')
  final HostedPaymentStatus status;

  /// Creates hosted payment details from JSON.
  factory HostedPayment.fromJson(Map<String, Object?> json) =>
      _$HostedPaymentFromJson(json);

  /// Converts hosted payment details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$HostedPaymentToJson(this));
  }
}
