import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_decimal_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';
import 'payment_customer.dart';
import 'payment_invoice.dart';
import 'payment_transaction.dart';

part 'payment_details.g.dart';

/// Payment details returned by `GET /v3/payments/{paymentId}`.
@JsonSerializable(explicitToJson: true)
final class PaymentDetails {
  /// Creates payment details.
  const PaymentDetails({
    required this.invoice,
    required this.transaction,
    required this.customer,
    required this.amount,
    this.suppliers = const [],
  });

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

  /// Whether the invoice is paid and the transaction succeeded.
  bool get isPaid => invoice.isPaid && transaction.isSuccess;

  /// Whether the invoice or transaction is pending.
  bool get isPending => invoice.isPending || transaction.isPending;

  /// Whether the transaction failed or was canceled.
  bool get isFailed => transaction.isFailed;

  /// Creates payment details from JSON.
  factory PaymentDetails.fromJson(Map<String, Object?> json) =>
      _$PaymentDetailsFromJson(json);

  /// Converts payment details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentDetailsToJson(this));
  }
}

/// Amount details returned by Get Payment Details.
@JsonSerializable()
final class PaymentAmount {
  /// Creates payment amount details.
  const PaymentAmount({
    this.baseCurrency,
    this.valueInBaseCurrency,
    this.serviceCharge,
    this.serviceChargeVat,
    this.receivableAmount,
    this.displayCurrency,
    this.valueInDisplayCurrency,
    this.payCurrency,
    this.valueInPayCurrency,
  });

  /// Base currency.
  @JsonKey(name: 'BaseCurrency')
  final String? baseCurrency;

  /// Value in base currency.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ValueInBaseCurrency')
  final String? valueInBaseCurrency;

  /// Service charge.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ServiceCharge')
  final String? serviceCharge;

  /// VAT on service charge.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ServiceChargeVAT')
  final String? serviceChargeVat;

  /// Receivable amount.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ReceivableAmount')
  final String? receivableAmount;

  /// Display currency.
  @JsonKey(name: 'DisplayCurrency')
  final String? displayCurrency;

  /// Value in display currency.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ValueInDisplayCurrency')
  final String? valueInDisplayCurrency;

  /// Pay currency.
  @JsonKey(name: 'PayCurrency')
  final String? payCurrency;

  /// Value in pay currency.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ValueInPayCurrency')
  final String? valueInPayCurrency;

  /// Creates payment amount details from JSON.
  factory PaymentAmount.fromJson(Map<String, Object?> json) =>
      _$PaymentAmountFromJson(json);

  /// Converts payment amount details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentAmountToJson(this));
  }
}
