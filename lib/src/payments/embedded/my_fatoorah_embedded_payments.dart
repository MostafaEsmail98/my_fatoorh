part of '../my_fatoorah_payments.dart';

/// Public Embedded Payment facade.
///
/// Access this through `myFatoorah.payments.embedded`.
///
/// This facade currently creates Embedded Payment sessions only. It does not
/// render UI, run JavaScript, or execute a payment.
final class MyFatoorahEmbeddedPayments {
  /// Creates the embedded payments facade.
  ///
  /// SDK consumers normally receive this from `myFatoorah.payments.embedded`.
  const MyFatoorahEmbeddedPayments._(this._client);

  final EmbeddedPaymentClient _client;

  /// Creates an Embedded Payment session.
  ///
  /// SessionId is valid for one payment only. Create a new session for each
  /// payment attempt.
  Future<MyFatoorahResult<InitiateSessionResponse>> initiateSession(
    InitiateSessionRequest request,
  ) {
    return _client.initiateSession(request);
  }
}
