import 'dart:convert';

import '../core/my_fatoorah_result.dart';
import '../exceptions/my_fatoorah_validation_exception.dart';
import '../serialization/my_fatoorah_json.dart';
import 'my_fatoorah_webhook_event.dart';

/// Parses MyFatoorah webhook payloads.
///
/// Webhooks should update backend order state. Flutter apps should read status
/// from your backend or call Get Payment Details. Webhook handlers should be
/// idempotent because duplicate delivery can happen.
final class MyFatoorahWebhookParser {
  const MyFatoorahWebhookParser._();

  /// Parses a webhook JSON string.
  static MyFatoorahResult<MyFatoorahWebhookEvent> parseJsonString(String body) {
    try {
      return parseMap(MyFatoorahJson.asObject(jsonDecode(body)));
    } catch (error, stackTrace) {
      return MyFatoorahResult.failure(
        MyFatoorahValidationException(
          'Invalid MyFatoorah webhook JSON.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Parses a webhook JSON map.
  static MyFatoorahResult<MyFatoorahWebhookEvent> parseMap(
    Map<String, Object?> json,
  ) {
    try {
      return MyFatoorahResult.success(MyFatoorahWebhookEvent.fromJson(json));
    } catch (error, stackTrace) {
      return MyFatoorahResult.failure(
        MyFatoorahValidationException(
          'Invalid MyFatoorah webhook payload.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
