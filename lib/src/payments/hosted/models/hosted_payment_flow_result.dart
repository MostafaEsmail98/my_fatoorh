/// High-level Hosted Payment flow result.
///
/// This result contains the hosted payment URL and identifiers returned by
/// MyFatoorah. It does not confirm payment. Final payment confirmation must
/// come from Get Payment Details or a backend webhook.
final class HostedPaymentFlowResult {
  /// Creates hosted payment flow details.
  const HostedPaymentFlowResult({
    required this.invoiceId,
    required this.paymentUrl,
    this.paymentId,
  });

  /// Created invoice identifier.
  final String invoiceId;

  /// Payment identifier, when returned by MyFatoorah.
  final String? paymentId;

  /// URL the application should open/redirect to in its own UI layer.
  final String paymentUrl;
}
