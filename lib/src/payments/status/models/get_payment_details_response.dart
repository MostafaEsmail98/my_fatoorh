import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_json.dart';
import 'payment_customer.dart';
import 'payment_details.dart';
import 'payment_invoice.dart';
import 'payment_transaction.dart';

part 'get_payment_details_response.g.dart';

/// Data model returned by `GET /v3/payments/{paymentId}`.
@JsonSerializable(explicitToJson: true)
final class GetPaymentDetailsResponse {
  /// Creates a Get Payment Details response.
  const GetPaymentDetailsResponse({
    required this.invoice,
    required this.transaction,
    required this.customer,
    required this.amount,
    this.suppliers = const [],
  });

  /// Creates a response directly from payment details.
  factory GetPaymentDetailsResponse.fromDetails(PaymentDetails details) {
    return GetPaymentDetailsResponse(
      invoice: details.invoice,
      transaction: details.transaction,
      customer: details.customer,
      amount: details.amount,
      suppliers: details.suppliers,
    );
  }

  /// Invoice details.
  @JsonKey(name: 'Invoice')
  final PaymentInvoice invoice;

  /// Transaction details.
  @JsonKey(name: 'Transaction')
  final PaymentTransaction transaction;

  /// Customer details.
  @JsonKey(name: 'Customer')
  final PaymentCustomer customer;

  /// Amount details.
  @JsonKey(name: 'Amount')
  final PaymentAmount amount;

  /// Supplier details.
  ///
  /// TODO: The Get Payment Details sample only shows an empty array. Replace
  /// with a typed supplier model if official docs define the non-empty shape
  /// for this endpoint.
  @JsonKey(name: 'Suppliers')
  final List<Object?> suppliers;

  /// Convenience grouped payment details.
  PaymentDetails get details {
    return PaymentDetails(
      invoice: invoice,
      transaction: transaction,
      customer: customer,
      amount: amount,
      suppliers: suppliers,
    );
  }

  /// Whether the invoice is paid and the transaction succeeded.
  bool get isPaid => details.isPaid;

  /// Whether the invoice or transaction is pending.
  bool get isPending => details.isPending;

  /// Whether the transaction failed or was canceled.
  bool get isFailed => details.isFailed;

  /// Creates a Get Payment Details response from JSON.
  factory GetPaymentDetailsResponse.fromJson(Map<String, Object?> json) =>
      _$GetPaymentDetailsResponseFromJson(json);

  /// Converts this response to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$GetPaymentDetailsResponseToJson(this));
  }
}
