import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_date_converter.dart';
import '../../../serialization/my_fatoorah_decimal_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';
import 'embedded_session.dart';

part 'initiate_session_response.g.dart';

/// Data model returned by Embedded Payment v3 `POST /v3/sessions`.
@JsonSerializable(explicitToJson: true)
final class InitiateSessionResponse {
  /// Creates an embedded session response.
  const InitiateSessionResponse({
    required this.sessionId,
    this.sessionExpiry,
    required this.encryptionKey,
    required this.operationType,
    required this.order,
    required this.customer,
  });

  /// Session identifier.
  ///
  /// SessionId is valid for one payment only. Create a new session for each
  /// payment attempt.
  @JsonKey(name: 'SessionId')
  final String sessionId;

  /// Session expiry date.
  @MyFatoorahDateConverter()
  @JsonKey(name: 'SessionExpiry')
  final DateTime? sessionExpiry;

  /// Encryption key returned by MyFatoorah.
  @JsonKey(name: 'EncryptionKey')
  final String encryptionKey;

  /// Operation type, for example `PAY`.
  @JsonKey(name: 'OperationType')
  final String operationType;

  /// Session order details.
  @JsonKey(name: 'Order')
  final EmbeddedSessionOrder order;

  /// Session customer details.
  @JsonKey(name: 'Customer')
  final EmbeddedSessionCustomer customer;

  /// Convenience embedded session value.
  EmbeddedSession get session {
    return EmbeddedSession(
      sessionId: sessionId,
      sessionExpiry: sessionExpiry,
      encryptionKey: encryptionKey,
      operationType: operationType,
      amount: order.amount,
      currency: order.currency,
      externalIdentifier: order.externalIdentifier,
    );
  }

  /// Creates an embedded session response from JSON.
  factory InitiateSessionResponse.fromJson(Map<String, Object?> json) =>
      _$InitiateSessionResponseFromJson(json);

  /// Converts this response to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InitiateSessionResponseToJson(this));
  }
}

/// Embedded session order returned by MyFatoorah.
@JsonSerializable()
final class EmbeddedSessionOrder {
  /// Creates embedded session order details.
  const EmbeddedSessionOrder({
    required this.amount,
    required this.currency,
    this.externalIdentifier,
  });

  /// Order amount.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Amount')
  final String amount;

  /// Order currency.
  @JsonKey(name: 'Currency')
  final String currency;

  /// External identifier.
  @JsonKey(name: 'ExternalIdentifier')
  final String? externalIdentifier;

  /// Creates embedded session order details from JSON.
  factory EmbeddedSessionOrder.fromJson(Map<String, Object?> json) =>
      _$EmbeddedSessionOrderFromJson(json);

  /// Converts embedded session order details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$EmbeddedSessionOrderToJson(this));
  }
}

/// Embedded session customer details returned by MyFatoorah.
@JsonSerializable()
final class EmbeddedSessionCustomer {
  /// Creates embedded session customer details.
  const EmbeddedSessionCustomer({this.reference, this.cards});

  /// Customer reference.
  @JsonKey(name: 'Reference')
  final String? reference;

  /// Customer cards.
  ///
  /// TODO: Replace with a typed card-token model if the official Embedded v3
  /// session docs define the non-null `Cards` structure.
  @JsonKey(name: 'Cards')
  final Object? cards;

  /// Creates embedded session customer details from JSON.
  factory EmbeddedSessionCustomer.fromJson(Map<String, Object?> json) =>
      _$EmbeddedSessionCustomerFromJson(json);

  /// Converts embedded session customer details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$EmbeddedSessionCustomerToJson(this));
  }
}
