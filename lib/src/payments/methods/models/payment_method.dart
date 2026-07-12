import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_decimal_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';

part 'payment_method.g.dart';

/// Payment method returned by `POST /v2/InitiatePayment`.
@JsonSerializable()
final class PaymentMethod {
  /// Creates a payment method.
  const PaymentMethod({
    required this.paymentMethodId,
    this.paymentMethodAr,
    required this.paymentMethodEn,
    required this.paymentMethodCode,
    required this.isDirectPayment,
    required this.serviceCharge,
    required this.totalAmount,
    required this.currencyIso,
    required this.imageUrl,
    required this.isEmbeddedSupported,
    required this.paymentCurrencyIso,
  });

  /// Payment method ID in MyFatoorah.
  @JsonKey(name: 'PaymentMethodId')
  final int paymentMethodId;

  /// Payment method Arabic name.
  @JsonKey(name: 'PaymentMethodAr')
  final String? paymentMethodAr;

  /// Payment method English name.
  @JsonKey(name: 'PaymentMethodEn')
  final String paymentMethodEn;

  /// Payment method code.
  @JsonKey(name: 'PaymentMethodCode')
  final String paymentMethodCode;

  /// Whether this method supports Direct Payment.
  @JsonKey(name: 'IsDirectPayment')
  final bool isDirectPayment;

  /// Transaction service charge.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'ServiceCharge')
  final String serviceCharge;

  /// Total amount including service charges.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'TotalAmount')
  final String totalAmount;

  /// Currency code sent in `CurrencyIso`.
  @JsonKey(name: 'CurrencyIso')
  final String currencyIso;

  /// Payment icon URL.
  @JsonKey(name: 'ImageUrl')
  final String imageUrl;

  /// Whether this method supports Embedded Payment.
  @JsonKey(name: 'IsEmbeddedSupported')
  final bool isEmbeddedSupported;

  /// Gateway currency in which payment will be made.
  @JsonKey(name: 'PaymentCurrencyIso')
  final String paymentCurrencyIso;

  /// Whether this method is a card method based on documented sample values.
  bool get isCard {
    final name = paymentMethodEn.toUpperCase();
    return paymentMethodCode.toLowerCase() == 'vm' ||
        name.contains('VISA') ||
        name.contains('MASTER') ||
        name.contains('AMEX');
  }

  /// Whether this method is Apple Pay based on documented sample values.
  bool get isApplePay {
    return paymentMethodCode.toLowerCase() == 'ap' ||
        paymentMethodEn.toLowerCase().contains('apple pay');
  }

  /// Whether this method is Google Pay based on documented sample values.
  bool get isGooglePay {
    final name = paymentMethodEn.toLowerCase().replaceAll(' ', '');
    return paymentMethodCode.toLowerCase() == 'gp' || name == 'googlepay';
  }

  /// Creates a payment method from JSON.
  factory PaymentMethod.fromJson(Map<String, Object?> json) =>
      _$PaymentMethodFromJson(json);

  /// Converts this payment method to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentMethodToJson(this));
  }
}
