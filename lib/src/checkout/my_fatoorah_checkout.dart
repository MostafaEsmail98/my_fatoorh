import '../client/my_fatoorah_client.dart';
import '../core/my_fatoorah_result.dart';
import '../exceptions/my_fatoorah_validation_exception.dart';
import '../payments/callback/my_fatoorah_callback_parser.dart';
import '../payments/hosted/hosted_payment_client.dart';
import '../payments/hosted/hosted_payment_launcher.dart';
import '../payments/hosted/models/create_hosted_payment_response.dart';
import '../payments/methods/models/initiate_payment_response.dart';
import '../payments/methods/models/payment_method.dart';
import '../payments/methods/payment_methods_client.dart';
import '../payments/status/models/get_payment_details_response.dart';
import '../payments/status/payment_status_client.dart';
import 'models/hosted_checkout_request.dart';
import 'models/hosted_checkout_result.dart';

/// Creates the public checkout facade from an internal API client.
///
/// This helper is intentionally not exported from the public SDK barrel.
MyFatoorahCheckout createMyFatoorahCheckout(
  MyFatoorahClient client, {
  HostedPaymentLauncher launcher = const HostedPaymentLauncher(),
}) {
  return MyFatoorahCheckout._(
    methodsClient: PaymentMethodsClient(client),
    hostedClient: HostedPaymentClient(client),
    statusClient: PaymentStatusClient(client),
    launcher: launcher,
  );
}

/// High-level checkout facade built on top of existing SDK APIs.
///
/// The checkout facade orchestrates Payment Methods, Hosted Payment URL
/// creation, URL opening, and redirect confirmation. It does not add new
/// MyFatoorah endpoints and it never treats opening a checkout URL as proof of
/// payment.
final class MyFatoorahCheckout {
  const MyFatoorahCheckout._({
    required PaymentMethodsClient methodsClient,
    required HostedPaymentClient hostedClient,
    required PaymentStatusClient statusClient,
    required HostedPaymentLauncher launcher,
  }) : _methodsClient = methodsClient,
       _hostedClient = hostedClient,
       _statusClient = statusClient,
       _launcher = launcher;

  final PaymentMethodsClient _methodsClient;
  final HostedPaymentClient _hostedClient;
  final PaymentStatusClient _statusClient;
  final HostedPaymentLauncher _launcher;

  /// Creates a Hosted Payment checkout.
  ///
  /// If [HostedCheckoutRequest.loadPaymentMethods] is true, this first loads
  /// available payment methods using `POST /v2/InitiatePayment`, then creates
  /// the Hosted Payment URL using `POST /v3/payments`.
  Future<MyFatoorahResult<HostedCheckoutResult>> createHostedCheckout(
    HostedCheckoutRequest request,
  ) async {
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      return MyFatoorahResult.failure(
        MyFatoorahValidationException(
          validationErrors.join(' '),
          details: validationErrors,
        ),
      );
    }

    var paymentMethods = const <PaymentMethod>[];
    if (request.loadPaymentMethods) {
      final methodsResult = await _methodsClient.get(
        request.toInitiatePaymentRequest(),
      );
      switch (methodsResult) {
        case MyFatoorahSuccess<InitiatePaymentResponse>(:final value):
          paymentMethods = value.paymentMethods;
        case MyFatoorahFailure<InitiatePaymentResponse>(:final exception):
          return MyFatoorahResult.failure(exception);
      }
    }

    final hostedResult = await _hostedClient.create(
      request.toCreateHostedPaymentRequest(),
    );

    return switch (hostedResult) {
      MyFatoorahSuccess<CreateHostedPaymentResponse>(:final value) =>
        MyFatoorahResult.success(
          HostedCheckoutResult(
            invoiceId: value.invoiceId,
            paymentId: value.paymentId,
            paymentUrl: value.paymentUrl,
            paymentMethods: paymentMethods,
          ),
        ),
      MyFatoorahFailure<CreateHostedPaymentResponse>(:final exception) =>
        MyFatoorahResult.failure(exception),
    };
  }

  /// Opens a Hosted Payment checkout URL.
  ///
  /// Opening checkout is not payment confirmation. Confirm the redirect with
  /// [confirmHostedCallback] or call `payments.status.get(paymentId)`.
  Future<MyFatoorahResult<void>> openHostedCheckout(
    HostedCheckoutResult checkout,
  ) {
    return _launcher.open(checkout.paymentUrl);
  }

  /// Confirms hosted checkout payment details from a redirect callback URL.
  ///
  /// Redirect data alone is not a final payment decision. This extracts
  /// `paymentId` and calls the official Get Payment Details API.
  Future<MyFatoorahResult<GetPaymentDetailsResponse>> confirmHostedCallback(
    String callbackUrl,
  ) {
    final callback = MyFatoorahCallbackParser.parseString(callbackUrl);
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
