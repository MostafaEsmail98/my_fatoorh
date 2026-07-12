import 'package:json_annotation/json_annotation.dart';

import '../serialization/my_fatoorah_json.dart';

part 'my_fatoorah_customer.g.dart';

/// Reusable customer details documented across MyFatoorah request/response
/// examples.
@JsonSerializable()
final class MyFatoorahCustomer {
  /// Creates customer details.
  const MyFatoorahCustomer({
    this.name,
    this.mobile,
    this.email,
    this.reference,
  });

  /// Customer name.
  @JsonKey(name: 'Name')
  final String? name;

  /// Customer mobile.
  @JsonKey(name: 'Mobile')
  final String? mobile;

  /// Customer email.
  @JsonKey(name: 'Email')
  final String? email;

  /// Merchant-side customer reference, when returned by an endpoint.
  @JsonKey(name: 'Reference')
  final String? reference;

  /// Creates customer details from JSON.
  factory MyFatoorahCustomer.fromJson(Map<String, Object?> json) =>
      _$MyFatoorahCustomerFromJson(json);

  /// Converts this customer to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$MyFatoorahCustomerToJson(this));
  }
}
