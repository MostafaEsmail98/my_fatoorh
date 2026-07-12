/// Parsed MyFatoorah redirect/callback URL parameters.
///
/// Redirect results are not a reliable final payment source. Always confirm
/// payment state by calling `myFatoorah.payments.status.get(paymentId)` after
/// receiving a redirect with a payment ID, or by reading backend state updated
/// by a verified webhook.
final class MyFatoorahCallbackResult {
  /// Creates parsed callback details.
  const MyFatoorahCallbackResult({
    required this.uri,
    this.paymentId,
    this.invoiceId,
    this.trackId,
    this.status,
  });

  /// Original callback URI.
  final Uri uri;

  /// Payment ID appended by MyFatoorah in documented redirect flows.
  final String? paymentId;

  /// Invoice ID, when present in a callback URL.
  final String? invoiceId;

  /// Track ID, when present in a callback URL.
  final String? trackId;

  /// Raw redirect status, when present.
  ///
  /// Do not treat this value as proof of payment. Use Get Payment Details to
  /// confirm the real status with MyFatoorah.
  final String? status;

  /// Whether the callback contains a payment ID.
  bool get hasPaymentId => paymentId != null && paymentId!.trim().isNotEmpty;

  /// Identifier to use with `myFatoorah.payments.status.get(...)`, if present.
  String? get idForStatusLookup => hasPaymentId ? paymentId!.trim() : null;
}
