import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_decimal_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';

part 'initiate_payment_request.g.dart';

/// Request body for `POST /v2/InitiatePayment`.
@JsonSerializable()
final class InitiatePaymentRequest {
  /// Creates an Initiate Payment request.
  const InitiatePaymentRequest({
    required this.invoiceAmount,
    required this.currencyIso,
  });

  /// Transaction amount to charge the customer.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'InvoiceAmount')
  final String invoiceAmount;

  /// Currency code to charge the customer through.
  @JsonKey(name: 'CurrencyIso')
  final String currencyIso;

  /// Creates an Initiate Payment request from JSON.
  factory InitiatePaymentRequest.fromJson(Map<String, Object?> json) =>
      _$InitiatePaymentRequestFromJson(json);

  /// Converts this request to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InitiatePaymentRequestToJson(this));
  }

  /// Returns validation messages for required documented fields.
  List<String> validate() {
    final amount = num.tryParse(invoiceAmount.trim());
    return [
      if (invoiceAmount.trim().isEmpty)
        'InvoiceAmount is required.'
      else if (amount == null || amount <= 0)
        'InvoiceAmount must be positive.',
      if (currencyIso.trim().isEmpty) 'CurrencyIso is required.',
    ];
  }
}
