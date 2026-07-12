import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_date_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';

part 'payment_invoice.g.dart';

/// Invoice details returned by `GET /v3/payments/{paymentId}`.
@JsonSerializable()
final class PaymentInvoice {
  /// Creates payment invoice details.
  const PaymentInvoice({
    required this.id,
    required this.status,
    this.reference,
    this.creationDate,
    this.expirationDate,
    this.externalIdentifier,
    this.userDefinedField,
    this.metaData,
  });

  /// Unique invoice identifier.
  @JsonKey(name: 'Id')
  final String id;

  /// Current invoice status, for example `PAID` or `PENDING`.
  @JsonKey(name: 'Status')
  final String status;

  /// Invoice reference.
  @JsonKey(name: 'Reference')
  final String? reference;

  /// Invoice creation date.
  @MyFatoorahDateConverter()
  @JsonKey(name: 'CreationDate')
  final DateTime? creationDate;

  /// Invoice expiration date.
  @MyFatoorahDateConverter()
  @JsonKey(name: 'ExpirationDate')
  final DateTime? expirationDate;

  /// External identifier.
  @JsonKey(name: 'ExternalIdentifier')
  final String? externalIdentifier;

  /// Merchant-defined field.
  @JsonKey(name: 'UserDefinedField')
  final String? userDefinedField;

  /// Invoice metadata.
  ///
  /// TODO: Replace with a typed model if official docs define the shape for
  /// `MetaData` in Get Payment Details.
  @JsonKey(name: 'MetaData')
  final Object? metaData;

  /// Whether this invoice is paid.
  bool get isPaid => status.toUpperCase() == 'PAID';

  /// Whether this invoice is pending.
  bool get isPending => status.toUpperCase() == 'PENDING';

  /// Creates invoice details from JSON.
  factory PaymentInvoice.fromJson(Map<String, Object?> json) =>
      _$PaymentInvoiceFromJson(json);

  /// Converts invoice details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentInvoiceToJson(this));
  }
}
