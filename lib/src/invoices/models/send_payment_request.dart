import '../../models/my_fatoorah_address.dart';
import '../../serialization/my_fatoorah_json.dart';
import 'invoice_customer.dart';
import 'invoice_item.dart';

/// Request body for `POST /v2/SendPayment`.
final class SendPaymentRequest {
  /// Creates a SendPayment invoice request.
  const SendPaymentRequest({
    required this.invoiceValue,
    required this.customer,
    required this.notificationOption,
    this.displayCurrencyIso,
    this.callBackUrl,
    this.errorUrl,
    this.language,
    this.customerReference,
    this.userDefinedField,
    this.customerAddress,
    this.expiryDate,
    this.invoiceItems,
    this.webhookUrl,
    this.invoicePaymentMethods,
  });

  /// Amount to charge the customer.
  final String invoiceValue;

  /// Customer details. Serialized into documented SendPayment fields.
  final InvoiceCustomer customer;

  /// Notification option for the invoice link.
  final SendPaymentNotificationOption notificationOption;

  /// Currency ISO code displayed to the customer.
  final String? displayCurrencyIso;

  /// Return URL after successful payment.
  final String? callBackUrl;

  /// Return URL in case of failed payment or exceptions.
  final String? errorUrl;

  /// Checkout page language. Documented values are `EN` and `AR`.
  final String? language;

  /// Merchant order or transaction reference.
  final String? customerReference;

  /// Custom field stored with the transaction.
  final String? userDefinedField;

  /// Customer address.
  final MyFatoorahAddress? customerAddress;

  /// Invoice link expiry date string.
  final String? expiryDate;

  /// Invoice item list.
  final List<InvoiceItem>? invoiceItems;

  /// Invoice-specific webhook URL.
  final String? webhookUrl;

  /// Payment method IDs to display on the invoice.
  final List<int>? invoicePaymentMethods;

  // TODO: Add typed SendPayment submodels for documented shipping, supplier,
  // source, and processing fields in dedicated tasks. Do not add raw maps.

  /// Creates a SendPayment request from JSON.
  factory SendPaymentRequest.fromJson(Map<String, Object?> json) {
    return SendPaymentRequest(
      invoiceValue: _decimalFromJson(json['InvoiceValue']),
      customer: InvoiceCustomer.fromJson(json),
      notificationOption: _notificationOptionFromJson(
        json['NotificationOption'],
      ),
      displayCurrencyIso: json['DisplayCurrencyIso'] as String?,
      callBackUrl: json['CallBackUrl'] as String?,
      errorUrl: json['ErrorUrl'] as String?,
      language: json['Language'] as String?,
      customerReference: json['CustomerReference'] as String?,
      userDefinedField: json['UserDefinedField'] as String?,
      customerAddress: json['CustomerAddress'] == null
          ? null
          : MyFatoorahAddress.fromJson(
              json['CustomerAddress']! as Map<String, Object?>,
            ),
      expiryDate: json['ExpiryDate'] as String?,
      invoiceItems: (json['InvoiceItems'] as List<Object?>?)
          ?.map((item) => InvoiceItem.fromJson(item! as Map<String, Object?>))
          .toList(growable: false),
      webhookUrl: json['WebhookUrl'] as String?,
      invoicePaymentMethods: (json['InvoicePaymentMethods'] as List<Object?>?)
          ?.map((id) => (id! as num).toInt())
          .toList(growable: false),
    );
  }

  /// Converts this request to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls({
      'InvoiceValue': invoiceValue,
      ...customer.toJson(),
      'NotificationOption': _notificationOptionToJson(notificationOption),
      'DisplayCurrencyIso': displayCurrencyIso,
      'CallBackUrl': callBackUrl,
      'ErrorUrl': errorUrl,
      'Language': language,
      'CustomerReference': customerReference,
      'UserDefinedField': userDefinedField,
      'CustomerAddress': customerAddress?.toJson(),
      'ExpiryDate': expiryDate,
      'InvoiceItems': invoiceItems
          ?.map((item) => item.toJson())
          .toList(growable: false),
      'WebhookUrl': webhookUrl,
      'InvoicePaymentMethods': invoicePaymentMethods,
    });
  }

  /// Returns validation messages for documented required fields.
  List<String> validate() {
    final parsedInvoiceValue = num.tryParse(invoiceValue.trim());
    return [
      if (invoiceValue.trim().isEmpty)
        'InvoiceValue is required.'
      else if (parsedInvoiceValue == null || parsedInvoiceValue <= 0)
        'InvoiceValue must be positive.',
      ...customer.validate(notificationOption),
      for (final item in invoiceItems ?? const <InvoiceItem>[])
        ...item.validate(),
    ];
  }
}

String _decimalFromJson(Object? json) {
  if (json is String) {
    return json;
  }
  if (json is num) {
    return json.toString();
  }
  throw FormatException('Expected a decimal string or number, got $json.');
}

SendPaymentNotificationOption _notificationOptionFromJson(Object? json) {
  return switch (json) {
    'EML' => SendPaymentNotificationOption.email,
    'SMS' => SendPaymentNotificationOption.sms,
    'LNK' => SendPaymentNotificationOption.link,
    'ALL' => SendPaymentNotificationOption.all,
    _ => throw FormatException('Unknown NotificationOption: $json.'),
  };
}

String _notificationOptionToJson(SendPaymentNotificationOption option) {
  return switch (option) {
    SendPaymentNotificationOption.email => 'EML',
    SendPaymentNotificationOption.sms => 'SMS',
    SendPaymentNotificationOption.link => 'LNK',
    SendPaymentNotificationOption.all => 'ALL',
  };
}
