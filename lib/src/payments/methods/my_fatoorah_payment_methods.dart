part of '../my_fatoorah_payments.dart';

/// Public Payment Methods facade.
///
/// Access this through `myFatoorah.payments.methods`.
final class MyFatoorahPaymentMethods {
  /// Creates the payment methods facade.
  ///
  /// SDK consumers normally receive this from `myFatoorah.payments.methods`.
  const MyFatoorahPaymentMethods._(this._client);

  final PaymentMethodsClient _client;

  /// Gets available and enabled payment methods for the configured account.
  Future<MyFatoorahResult<InitiatePaymentResponse>> get(
    InitiatePaymentRequest request,
  ) {
    return _client.get(request);
  }
}
