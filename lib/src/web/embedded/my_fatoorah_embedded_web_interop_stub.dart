/// Configuration passed to MyFatoorah Embedded Payment JavaScript.
final class MyFatoorahEmbeddedWebConfig {
  /// Creates Embedded Payment JavaScript configuration.
  const MyFatoorahEmbeddedWebConfig({
    required this.sessionId,
    required this.countryCode,
    required this.currencyCode,
    required this.amount,
    required this.containerId,
  });

  /// Session ID returned by `POST /v3/sessions`.
  final String sessionId;

  /// MyFatoorah country code returned by Initiate Session.
  final String countryCode;

  /// Payment currency code.
  final String currencyCode;

  /// Amount displayed by supported wallet methods.
  final String amount;

  /// HTML container ID used by MyFatoorah JS.
  final String containerId;

  /// Serializes the documented configuration fields.
  Map<String, Object?> toJson() {
    return {
      'sessionId': sessionId,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
      'amount': amount,
      'containerId': containerId,
    };
  }
}

/// Initializes MyFatoorah Embedded Payment JavaScript.
void initializeMyFatoorahEmbeddedWeb({
  required MyFatoorahEmbeddedWebConfig config,
  required void Function(Map<String, dynamic> data) onCallback,
}) {
  throw UnsupportedError(
    'Embedded Web checkout is only available on Flutter Web.',
  );
}
