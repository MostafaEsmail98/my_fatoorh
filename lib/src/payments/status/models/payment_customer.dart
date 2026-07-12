import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_json.dart';

part 'payment_customer.g.dart';

/// Customer details returned by `GET /v3/payments/{paymentId}`.
@JsonSerializable()
final class PaymentCustomer {
  /// Creates payment customer details.
  const PaymentCustomer({this.reference, this.name, this.mobile, this.email});

  /// Customer reference.
  @JsonKey(name: 'Reference')
  final String? reference;

  /// Customer name.
  @JsonKey(name: 'Name')
  final String? name;

  /// Customer mobile.
  @JsonKey(name: 'Mobile')
  final String? mobile;

  /// Customer email.
  @JsonKey(name: 'Email')
  final String? email;

  /// Creates payment customer details from JSON.
  factory PaymentCustomer.fromJson(Map<String, Object?> json) =>
      _$PaymentCustomerFromJson(json);

  /// Converts payment customer details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentCustomerToJson(this));
  }
}
