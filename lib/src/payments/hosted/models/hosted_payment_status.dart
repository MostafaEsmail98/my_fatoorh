import 'package:json_annotation/json_annotation.dart';

/// SDK-level status for a hosted payment create response.
///
/// The Hosted Payment v3 create-payment response documents
/// `PaymentCompleted`; detailed transaction status must come from
/// `GET /v3/payments/{paymentId}` in a later task.
enum HostedPaymentStatus {
  /// Payment URL was created and the customer should be redirected.
  @JsonValue('created')
  created,

  /// Create-payment response indicates payment completion.
  @JsonValue('completed')
  completed;

  /// Converts the documented `PaymentCompleted` value into SDK status.
  static HostedPaymentStatus fromPaymentCompleted(bool paymentCompleted) {
    return paymentCompleted ? completed : created;
  }
}
