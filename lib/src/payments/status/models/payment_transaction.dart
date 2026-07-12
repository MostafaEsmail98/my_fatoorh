import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_date_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';

part 'payment_transaction.g.dart';

/// Transaction details returned by `GET /v3/payments/{paymentId}`.
@JsonSerializable(explicitToJson: true)
final class PaymentTransaction {
  /// Creates payment transaction details.
  const PaymentTransaction({
    required this.id,
    required this.status,
    this.paymentMethod,
    this.paymentId,
    this.referenceId,
    this.trackId,
    this.authorizationId,
    this.transactionDate,
    this.eci,
    this.ip,
    this.error,
    this.card,
  });

  /// Unique transaction identifier.
  @JsonKey(name: 'Id')
  final String id;

  /// Transaction status, for example `SUCCESS`, `FAILED`, or `CANCELED`.
  @JsonKey(name: 'Status')
  final String status;

  /// Payment method used.
  @JsonKey(name: 'PaymentMethod')
  final String? paymentMethod;

  /// Payment identifier.
  @JsonKey(name: 'PaymentId')
  final String? paymentId;

  /// Transaction reference identifier.
  @JsonKey(name: 'ReferenceId')
  final String? referenceId;

  /// Track identifier.
  @JsonKey(name: 'TrackId')
  final String? trackId;

  /// Authorization identifier.
  @JsonKey(name: 'AuthorizationId')
  final String? authorizationId;

  /// Transaction date.
  @MyFatoorahDateConverter()
  @JsonKey(name: 'TransactionDate')
  final DateTime? transactionDate;

  /// Electronic Commerce Indicator.
  @JsonKey(name: 'ECI')
  final String? eci;

  /// IP information.
  @JsonKey(name: 'IP')
  final PaymentTransactionIp? ip;

  /// Transaction error information.
  @JsonKey(name: 'Error')
  final PaymentTransactionError? error;

  /// Card information.
  @JsonKey(name: 'Card')
  final PaymentTransactionCard? card;

  /// Whether this transaction succeeded.
  bool get isSuccess => status.toUpperCase() == 'SUCCESS';

  /// Whether this transaction is pending/in progress.
  bool get isPending {
    final normalized = status.toUpperCase();
    return normalized == 'INPROGRESS' || normalized == 'AUTHORIZE';
  }

  /// Whether this transaction failed or was canceled.
  bool get isFailed {
    final normalized = status.toUpperCase();
    return normalized == 'FAILED' || normalized == 'CANCELED';
  }

  /// Creates transaction details from JSON.
  factory PaymentTransaction.fromJson(Map<String, Object?> json) =>
      _$PaymentTransactionFromJson(json);

  /// Converts transaction details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentTransactionToJson(this));
  }
}

/// IP information returned in transaction details.
@JsonSerializable()
final class PaymentTransactionIp {
  /// Creates transaction IP information.
  const PaymentTransactionIp({this.address, this.country});

  /// IP address.
  @JsonKey(name: 'Address')
  final String? address;

  /// IP country.
  @JsonKey(name: 'Country')
  final String? country;

  /// Creates transaction IP information from JSON.
  factory PaymentTransactionIp.fromJson(Map<String, Object?> json) =>
      _$PaymentTransactionIpFromJson(json);

  /// Converts transaction IP information to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentTransactionIpToJson(this));
  }
}

/// Transaction error details.
@JsonSerializable()
final class PaymentTransactionError {
  /// Creates transaction error details.
  const PaymentTransactionError({this.code, this.message});

  /// Error code.
  @JsonKey(name: 'Code')
  final String? code;

  /// Error message.
  @JsonKey(name: 'Message')
  final String? message;

  /// Creates transaction error details from JSON.
  factory PaymentTransactionError.fromJson(Map<String, Object?> json) =>
      _$PaymentTransactionErrorFromJson(json);

  /// Converts transaction error details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentTransactionErrorToJson(this));
  }
}

/// Card details returned in transaction details.
@JsonSerializable()
final class PaymentTransactionCard {
  /// Creates transaction card details.
  const PaymentTransactionCard({
    this.nameOnCard,
    this.number,
    this.token,
    this.panHash,
    this.expiryMonth,
    this.expiryYear,
    this.brand,
    this.issuer,
    this.issuerCountry,
    this.fundingMethod,
  });

  /// Name on card.
  @JsonKey(name: 'NameOnCard')
  final String? nameOnCard;

  /// Masked card number.
  @JsonKey(name: 'Number')
  final String? number;

  /// Card token.
  @JsonKey(name: 'Token')
  final String? token;

  /// PAN hash.
  @JsonKey(name: 'PanHash')
  final String? panHash;

  /// Expiry month.
  @JsonKey(name: 'ExpiryMonth')
  final String? expiryMonth;

  /// Expiry year.
  @JsonKey(name: 'ExpiryYear')
  final String? expiryYear;

  /// Card brand.
  @JsonKey(name: 'Brand')
  final String? brand;

  /// Card issuer.
  @JsonKey(name: 'Issuer')
  final String? issuer;

  /// Card issuer country.
  @JsonKey(name: 'IssuerCountry')
  final String? issuerCountry;

  /// Funding method.
  @JsonKey(name: 'FundingMethod')
  final String? fundingMethod;

  /// Creates transaction card details from JSON.
  factory PaymentTransactionCard.fromJson(Map<String, Object?> json) =>
      _$PaymentTransactionCardFromJson(json);

  /// Converts transaction card details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$PaymentTransactionCardToJson(this));
  }
}
