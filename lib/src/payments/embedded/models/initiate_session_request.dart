import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_decimal_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';

part 'initiate_session_request.g.dart';

/// Embedded Payment v3 session creation request.
///
/// Official endpoint shown in the docs is `POST /v3/sessions`. The SDK uses
/// "initiate session" naming to match MyFatoorah embedded terminology.
@JsonSerializable(explicitToJson: true)
final class InitiateSessionRequest {
  /// Creates an embedded session request.
  const InitiateSessionRequest({
    required this.paymentMode,
    required this.order,
  });

  /// Payment mode, for example `COMPLETE_PAYMENT` or `COLLECT_DETAILS`.
  @JsonKey(name: 'PaymentMode')
  final EmbeddedPaymentMode paymentMode;

  /// Order details for the session.
  @JsonKey(name: 'Order')
  final InitiateSessionOrder order;

  /// Creates an embedded session request from JSON.
  factory InitiateSessionRequest.fromJson(Map<String, Object?> json) =>
      _$InitiateSessionRequestFromJson(json);

  /// Converts this request to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InitiateSessionRequestToJson(this));
  }

  /// Returns validation messages for required documented fields.
  List<String> validate() {
    return order.validate();
  }
}

/// Documented Embedded Payment v3 payment modes.
enum EmbeddedPaymentMode {
  /// Complete Payment Mode.
  @JsonValue('COMPLETE_PAYMENT')
  completePayment,

  /// Collect Details Mode.
  @JsonValue('COLLECT_DETAILS')
  collectDetails,
}

/// Order details for creating an embedded session.
@JsonSerializable()
final class InitiateSessionOrder {
  /// Creates order details.
  const InitiateSessionOrder({required this.amount});

  /// Order amount.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Amount')
  final String amount;

  /// Creates order details from JSON.
  factory InitiateSessionOrder.fromJson(Map<String, Object?> json) =>
      _$InitiateSessionOrderFromJson(json);

  /// Converts order details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InitiateSessionOrderToJson(this));
  }

  /// Returns validation messages for required documented fields.
  List<String> validate() {
    final parsedAmount = num.tryParse(amount.trim());
    return [
      if (amount.trim().isEmpty)
        'Order.Amount is required.'
      else if (parsedAmount == null || parsedAmount <= 0)
        'Order.Amount must be positive.',
    ];
  }
}
