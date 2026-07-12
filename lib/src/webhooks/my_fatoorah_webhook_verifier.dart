import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../serialization/my_fatoorah_json.dart';
import 'my_fatoorah_webhook_event.dart';
import 'my_fatoorah_webhook_type.dart';

/// Verifies MyFatoorah webhook signatures.
///
/// Webhook V2 requires the secret key from the MyFatoorah portal and the
/// `myfatoorah-signature` header. Verification should happen before updating
/// backend order state, and handlers should process duplicate webhook delivery
/// idempotently.
final class MyFatoorahWebhookVerifier {
  const MyFatoorahWebhookVerifier._();

  /// Documented signature header.
  static const signatureHeader = 'myfatoorah-signature';

  /// Verifies a webhook signature.
  static MyFatoorahWebhookVerificationResult verify({
    required MyFatoorahWebhookEvent event,
    required String signature,
    required String secretKey,
  }) {
    if (secretKey.isEmpty) {
      return const MyFatoorahWebhookVerificationResult.invalid(
        'Webhook secret key is required.',
      );
    }
    if (signature.isEmpty) {
      return const MyFatoorahWebhookVerificationResult.invalid(
        'Webhook signature is required.',
      );
    }

    final canonical = signaturePayloadFor(event);
    if (canonical == null) {
      return MyFatoorahWebhookVerificationResult.unsupported(
        'Signature field order is not implemented for ${event.name}.',
      );
    }

    final expected = computeSignature(
      orderedData: canonical,
      secretKey: secretKey,
    );
    return _constantTimeEquals(expected, signature)
        ? const MyFatoorahWebhookVerificationResult.valid()
        : const MyFatoorahWebhookVerificationResult.invalid(
            'Webhook signature mismatch.',
          );
  }

  /// Computes HMAC SHA-256 signature as documented by MyFatoorah.
  static String computeSignature({
    required String orderedData,
    required String secretKey,
  }) {
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    return base64Encode(hmac.convert(utf8.encode(orderedData)).bytes);
  }

  /// Returns documented ordered signature data for supported event types.
  static String? signaturePayloadFor(MyFatoorahWebhookEvent event) {
    return switch (event.type) {
      MyFatoorahWebhookType.paymentStatusChanged =>
        _paymentStatusChangedPayload(event.data),
      // TODO: Implement signature field order for other documented webhook
      // event types after their official data-model pages are mapped.
      MyFatoorahWebhookType.refundStatusChanged ||
      MyFatoorahWebhookType.balanceTransferred ||
      MyFatoorahWebhookType.supplierStatusChanged ||
      MyFatoorahWebhookType.recurringUpdates ||
      MyFatoorahWebhookType.disputeStatusChanged ||
      MyFatoorahWebhookType.supplierUpdateRequestChanged => null,
    };
  }

  static String _paymentStatusChangedPayload(Map<String, Object?> data) {
    final invoice = MyFatoorahJson.asObject(data['Invoice']);
    final transaction = MyFatoorahJson.asObject(data['Transaction']);
    final values = {
      'Invoice.Id': invoice['Id'],
      'Invoice.Status': invoice['Status'],
      'Transaction.Status': transaction['Status'],
      'Transaction.PaymentId': transaction['PaymentId'],
      'Invoice.ExternalIdentifier': invoice['ExternalIdentifier'],
    };

    return values.entries
        .map((entry) => '${entry.key}=${entry.value ?? ''}')
        .join(',');
  }

  static bool _constantTimeEquals(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);
    if (aBytes.length != bBytes.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < aBytes.length; i += 1) {
      diff |= aBytes[i] ^ bBytes[i];
    }
    return diff == 0;
  }
}

/// Safe result for webhook signature verification.
final class MyFatoorahWebhookVerificationResult {
  const MyFatoorahWebhookVerificationResult._({
    required this.isValid,
    required this.isSupported,
    this.message,
  });

  /// Valid signature.
  const MyFatoorahWebhookVerificationResult.valid()
    : this._(isValid: true, isSupported: true);

  /// Invalid signature or missing verification input.
  const MyFatoorahWebhookVerificationResult.invalid(String message)
    : this._(isValid: false, isSupported: true, message: message);

  /// Verification is not supported for the event type yet.
  const MyFatoorahWebhookVerificationResult.unsupported(String message)
    : this._(isValid: false, isSupported: false, message: message);

  /// Whether the signature is valid.
  final bool isValid;

  /// Whether this event type has a documented signature field order implemented.
  final bool isSupported;

  /// Failure or unsupported reason.
  final String? message;
}
