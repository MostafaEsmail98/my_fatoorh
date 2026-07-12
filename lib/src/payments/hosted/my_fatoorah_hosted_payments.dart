part of '../my_fatoorah_payments.dart';

/// Public Hosted Payment Page facade.
///
/// Access this through `myFatoorah.payments.hosted`.
///
/// This facade can create a hosted payment URL and help confirm a redirect
/// callback. It does not open a browser and it does not mark payments as paid
/// from redirect data alone.
final class MyFatoorahHostedPayments {
  /// Creates the hosted payments facade.
  ///
  /// SDK consumers normally receive this from `myFatoorah.payments.hosted`.
  const MyFatoorahHostedPayments._(
    this._client,
    this._statusClient,
    this._launcher,
  );

  final HostedPaymentClient _client;
  final PaymentStatusClient _statusClient;
  final HostedPaymentLauncher _launcher;

  /// Creates a Hosted Payment Page payment.
  ///
  /// This is the low-level Hosted Payment create operation. The response
  /// contains the MyFatoorah payment URL and identifiers, but final payment
  /// confirmation must still come from Get Payment Details or a verified
  /// backend webhook.
  Future<MyFatoorahResult<CreateHostedPaymentResponse>> create(
    CreateHostedPaymentRequest request,
  ) {
    return _client.create(request);
  }

  /// Creates a Hosted Payment Page URL and returns redirect-ready details.
  ///
  /// This does not confirm payment. Final confirmation must come from
  /// `myFatoorah.payments.status.get(paymentId)` or a backend webhook.
  Future<MyFatoorahResult<HostedPaymentFlowResult>> createPaymentUrl(
    CreateHostedPaymentRequest request,
  ) async {
    final result = await create(request);
    return switch (result) {
      MyFatoorahSuccess<CreateHostedPaymentResponse>(:final value) =>
        MyFatoorahResult.success(
          HostedPaymentFlowResult(
            invoiceId: value.invoiceId,
            paymentId: value.paymentId,
            paymentUrl: value.paymentUrl,
          ),
        ),
      MyFatoorahFailure<CreateHostedPaymentResponse>(:final exception) =>
        MyFatoorahResult.failure(exception),
    };
  }

  /// Opens a Hosted Payment URL using the platform browser integration.
  ///
  /// On Android/iOS, the SDK asks `url_launcher` for an in-app browser view
  /// first, which maps to Chrome Custom Tabs or Safari View Controller when
  /// available. On Web, `url_launcher` opens a browser tab/window.
  ///
  /// Opening the URL does not confirm payment. After the user redirects back
  /// to your app, call [confirmFromCallback] or
  /// `myFatoorah.payments.status.get(paymentId)`.
  Future<MyFatoorahResult<void>> openPaymentUrl(String paymentUrl) {
    return _launcher.open(paymentUrl);
  }

  /// Confirms payment details from a MyFatoorah redirect URL.
  ///
  /// Redirect data alone is not a final payment decision. This method extracts
  /// `paymentId` and calls the official Get Payment Details API.
  Future<MyFatoorahResult<GetPaymentDetailsResponse>> confirmFromCallback(
    String redirectUrl,
  ) {
    final callback = MyFatoorahCallbackParser.parseString(redirectUrl);
    final paymentId = callback.idForStatusLookup;
    if (paymentId == null) {
      return Future.value(
        const MyFatoorahResult.failure(
          MyFatoorahValidationException(
            'MyFatoorah callback URL does not contain a paymentId.',
          ),
        ),
      );
    }

    return _statusClient.get(paymentId);
  }
}
