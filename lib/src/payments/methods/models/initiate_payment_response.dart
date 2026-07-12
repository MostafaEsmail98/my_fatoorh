import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_json.dart';
import 'payment_method.dart';

part 'initiate_payment_response.g.dart';

/// Data model returned by `POST /v2/InitiatePayment`.
@JsonSerializable(explicitToJson: true)
final class InitiatePaymentResponse {
  /// Creates an Initiate Payment response.
  const InitiatePaymentResponse({required this.paymentMethods});

  /// Available and enabled payment methods for the portal account.
  @JsonKey(name: 'PaymentMethods')
  final List<PaymentMethod> paymentMethods;

  /// Creates an Initiate Payment response from JSON.
  factory InitiatePaymentResponse.fromJson(Map<String, Object?> json) =>
      _$InitiatePaymentResponseFromJson(json);

  /// Converts this response to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InitiatePaymentResponseToJson(this));
  }
}
