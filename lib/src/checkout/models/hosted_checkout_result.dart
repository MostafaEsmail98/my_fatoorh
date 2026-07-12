import '../../payments/methods/models/payment_method.dart';

/// Result returned by high-level hosted checkout creation.
///
/// This does not mean payment is complete. Final confirmation must come from
/// Get Payment Details or a verified backend webhook.
final class HostedCheckoutResult {
  /// Creates hosted checkout result details.
  const HostedCheckoutResult({
    required this.invoiceId,
    required this.paymentUrl,
    this.paymentId,
    this.paymentMethods = const [],
  });

  /// Created invoice identifier.
  final String invoiceId;

  /// Payment identifier, when returned by MyFatoorah.
  final String? paymentId;

  /// Hosted checkout URL to open in the browser layer.
  final String paymentUrl;

  /// Payment methods loaded during checkout creation, when requested.
  final List<PaymentMethod> paymentMethods;
}
