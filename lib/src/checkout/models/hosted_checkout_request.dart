import '../../payments/hosted/models/create_hosted_payment_request.dart';
import '../../payments/methods/models/initiate_payment_request.dart';
import 'checkout_customer.dart';

/// High-level request for creating a Hosted Payment checkout.
///
/// This model orchestrates existing SDK APIs only. It does not introduce new
/// MyFatoorah endpoint fields.
final class HostedCheckoutRequest {
  /// Creates a high-level hosted checkout request.
  const HostedCheckoutRequest({
    required this.amount,
    required this.currencyIso,
    required this.redirectUrl,
    this.paymentMethod = 'CARD',
    this.loadPaymentMethods = false,
    this.customer,
  });

  /// Checkout amount.
  final String amount;

  /// Currency code used when loading available payment methods.
  final String currencyIso;

  /// Absolute redirect URL configured for Hosted Payment.
  final String redirectUrl;

  /// Hosted Payment method sent to `POST /v3/payments`.
  ///
  /// Defaults to the documented Hosted Payment card method. Pass another
  /// documented value when your integration needs it.
  final String paymentMethod;

  /// Whether checkout creation should also load available payment methods.
  final bool loadPaymentMethods;

  /// Optional app-level customer information.
  final CheckoutCustomer? customer;

  /// Returns validation messages for this checkout request.
  List<String> validate() {
    final parsedAmount = num.tryParse(amount.trim());
    final parsedRedirectUrl = Uri.tryParse(redirectUrl.trim());
    return [
      if (amount.trim().isEmpty)
        'Amount is required.'
      else if (parsedAmount == null || parsedAmount <= 0)
        'Amount must be positive.',
      if (currencyIso.trim().isEmpty) 'Currency is required.',
      if (redirectUrl.trim().isEmpty)
        'RedirectUrl is required.'
      else if (parsedRedirectUrl == null || !parsedRedirectUrl.isAbsolute)
        'RedirectUrl must be an absolute URL.',
      if (paymentMethod.trim().isEmpty) 'PaymentMethod is required.',
      ...?customer?.validate(),
    ];
  }

  /// Converts this request into the Payment Methods request.
  InitiatePaymentRequest toInitiatePaymentRequest() {
    return InitiatePaymentRequest(
      invoiceAmount: amount,
      currencyIso: currencyIso,
    );
  }

  /// Converts this request into the Hosted Payment create request.
  CreateHostedPaymentRequest toCreateHostedPaymentRequest() {
    return CreateHostedPaymentRequest(
      paymentMethod: paymentMethod,
      order: HostedPaymentOrder(amount: amount),
      integrationUrls: HostedPaymentIntegrationUrls(redirection: redirectUrl),
    );
  }
}
