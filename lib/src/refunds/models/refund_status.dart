import 'package:json_annotation/json_annotation.dart';

/// Documented MyFatoorah refund statuses.
///
/// MakeRefund creates a refund request. Final refund state should be confirmed
/// from the portal, refund status APIs, or verified backend webhook.
enum RefundStatus {
  /// Refund has been completed.
  @JsonValue('Refunded')
  refunded,

  /// Refund has been canceled.
  @JsonValue('Canceled')
  canceled,

  /// Refund is still pending.
  @JsonValue('Pending')
  pending,
}
