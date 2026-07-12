/// Convenience value object for an Embedded Payment session.
///
/// SessionId is valid for one payment only. Create a new session for each
/// payment attempt.
final class EmbeddedSession {
  /// Creates embedded session details.
  const EmbeddedSession({
    required this.sessionId,
    this.sessionExpiry,
    required this.encryptionKey,
    required this.operationType,
    required this.amount,
    required this.currency,
    this.externalIdentifier,
  });

  /// Session identifier.
  final String sessionId;

  /// Session expiry date.
  final DateTime? sessionExpiry;

  /// Encryption key returned by MyFatoorah.
  final String encryptionKey;

  /// Operation type, for example `PAY`.
  final String operationType;

  /// Session amount.
  final String amount;

  /// Session currency.
  final String currency;

  /// External identifier.
  final String? externalIdentifier;
}
