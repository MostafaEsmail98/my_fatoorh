import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_json.dart';
import 'hosted_payment.dart';
import 'hosted_payment_status.dart';

part 'create_hosted_payment_response.g.dart';

/// Data model returned by Hosted Payment Page `POST /v3/payments`.
@JsonSerializable()
final class CreateHostedPaymentResponse {
  /// Creates a hosted payment creation response.
  const CreateHostedPaymentResponse({
    required this.invoiceId,
    this.paymentId,
    required this.paymentUrl,
    required this.paymentCompleted,
    this.transactionDetails,
  });

  /// Created invoice identifier.
  @JsonKey(name: 'InvoiceId')
  final String invoiceId;

  /// Payment identifier, when available.
  @JsonKey(name: 'PaymentId')
  final String? paymentId;

  /// URL used to redirect the customer to the MyFatoorah hosted page.
  @JsonKey(name: 'PaymentURL')
  final String paymentUrl;

  /// Whether the payment was completed in the create-payment response.
  @JsonKey(name: 'PaymentCompleted')
  final bool paymentCompleted;

  /// Transaction details.
  ///
  /// TODO: The Hosted Payment v3 create-payment sample shows this field as
  /// `null` only. Replace this flexible value with a typed model when official
  /// docs provide the non-null shape for this endpoint.
  @JsonKey(name: 'TransactionDetails')
  final Object? transactionDetails;

  /// Convenience hosted payment value object.
  HostedPayment get hostedPayment {
    return HostedPayment(
      invoiceId: invoiceId,
      paymentId: paymentId,
      paymentUrl: paymentUrl,
      status: HostedPaymentStatus.fromPaymentCompleted(paymentCompleted),
    );
  }

  /// Creates a hosted payment response from JSON.
  factory CreateHostedPaymentResponse.fromJson(Map<String, Object?> json) =>
      _$CreateHostedPaymentResponseFromJson(json);

  /// Converts this response to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(
      _$CreateHostedPaymentResponseToJson(this),
    );
  }
}
