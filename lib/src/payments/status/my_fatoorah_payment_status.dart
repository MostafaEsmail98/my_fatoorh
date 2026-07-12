part of '../my_fatoorah_payments.dart';

/// Public payment status facade.
///
/// Access this through `myFatoorah.payments.status`.
///
/// Use this API to confirm payment state after redirects, hosted payment
/// callbacks, or backend webhook processing.
final class MyFatoorahPaymentStatus {
  /// Creates the payment status facade.
  ///
  /// SDK consumers normally receive this from `myFatoorah.payments.status`.
  const MyFatoorahPaymentStatus._(this._client);

  final PaymentStatusClient _client;

  /// Gets official payment details by payment ID.
  ///
  /// This is the trusted confirmation step for redirects. Do not mark an order
  /// as paid from redirect data alone.
  Future<MyFatoorahResult<GetPaymentDetailsResponse>> get(String paymentId) {
    return _client.get(paymentId);
  }
}
