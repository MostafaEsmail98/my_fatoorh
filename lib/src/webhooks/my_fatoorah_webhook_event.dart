import '../payments/status/models/payment_details.dart';
import '../serialization/my_fatoorah_date_converter.dart';
import '../serialization/my_fatoorah_json.dart';
import 'my_fatoorah_webhook_type.dart';

/// Parsed MyFatoorah Webhook V2 event.
///
/// Webhooks should update backend order state. Handle duplicate delivery
/// idempotently, using [reference] and your own order/payment identifiers.
/// Flutter apps should read status from your backend or confirm with
/// Get Payment Details rather than trusting client-side redirects alone.
final class MyFatoorahWebhookEvent {
  /// Creates a webhook event.
  const MyFatoorahWebhookEvent({
    required this.code,
    required this.name,
    required this.countryIsoCode,
    required this.creationDate,
    required this.reference,
    required this.type,
    required this.data,
    this.paymentDetails,
  });

  /// Event code.
  final int code;

  /// Event name.
  final String name;

  /// Country ISO code for the portal account.
  final String countryIsoCode;

  /// Event creation date.
  final DateTime? creationDate;

  /// Unique webhook reference.
  final String reference;

  /// Documented event type.
  final MyFatoorahWebhookType type;

  /// Raw documented `Data` object.
  final Map<String, Object?> data;

  /// Typed payment details for `PAYMENT_STATUS_CHANGED` events.
  final PaymentDetails? paymentDetails;

  /// Creates a webhook event from JSON.
  factory MyFatoorahWebhookEvent.fromJson(Map<String, Object?> json) {
    final eventJson = MyFatoorahJson.asObject(json['Event']);
    final data = MyFatoorahJson.asObject(json['Data']);
    final code = _intFromJson(eventJson['Code']);
    final name = eventJson['Name'] as String? ?? '';
    final type = MyFatoorahWebhookType.from(code: code, name: name);
    if (type == null) {
      throw FormatException('Unsupported MyFatoorah webhook event: $name.');
    }

    return MyFatoorahWebhookEvent(
      code: code,
      name: name,
      countryIsoCode: eventJson['CountryIsoCode'] as String? ?? '',
      creationDate: const MyFatoorahDateConverter().fromJson(
        eventJson['CreationDate'],
      ),
      reference: eventJson['Reference'] as String? ?? '',
      type: type,
      data: data,
      paymentDetails: type == MyFatoorahWebhookType.paymentStatusChanged
          ? PaymentDetails.fromJson(data)
          : null,
    );
  }

  /// Converts the event to JSON.
  Map<String, Object?> toJson() {
    return {
      'Event': {
        'Code': code,
        'Name': name,
        'CountryIsoCode': countryIsoCode,
        'CreationDate': const MyFatoorahDateConverter().toJson(creationDate),
        'Reference': reference,
      },
      'Data': data,
    };
  }

  static int _intFromJson(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.parse(value);
    }
    throw FormatException('Expected webhook event code, got $value.');
  }
}
