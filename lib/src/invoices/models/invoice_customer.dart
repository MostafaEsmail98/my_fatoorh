import 'package:json_annotation/json_annotation.dart';

import '../../serialization/my_fatoorah_json.dart';

part 'invoice_customer.g.dart';

/// Customer fields documented by MyFatoorah SendPayment.
@JsonSerializable()
final class InvoiceCustomer {
  /// Creates invoice customer details.
  const InvoiceCustomer({
    required this.name,
    this.mobileCountryCode,
    this.mobile,
    this.email,
    this.civilId,
  });

  /// Customer name displayed during checkout.
  @JsonKey(name: 'CustomerName')
  final String name;

  /// Customer mobile country code.
  @JsonKey(name: 'MobileCountryCode')
  final String? mobileCountryCode;

  /// Customer mobile number.
  @JsonKey(name: 'CustomerMobile')
  final String? mobile;

  /// Customer email address.
  @JsonKey(name: 'CustomerEmail')
  final String? email;

  /// Customer civil ID.
  @JsonKey(name: 'CustomerCivilId')
  final String? civilId;

  /// Creates customer details from JSON.
  factory InvoiceCustomer.fromJson(Map<String, Object?> json) =>
      _$InvoiceCustomerFromJson(json);

  /// Converts customer details to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InvoiceCustomerToJson(this));
  }

  /// Returns validation messages for documented required/conditional fields.
  List<String> validate(SendPaymentNotificationOption notificationOption) {
    return [
      if (name.trim().isEmpty) 'CustomerName is required.',
      if ((notificationOption == SendPaymentNotificationOption.sms ||
              notificationOption == SendPaymentNotificationOption.all) &&
          (mobile == null || mobile!.trim().isEmpty))
        'CustomerMobile is required when NotificationOption is SMS or ALL.',
      if ((notificationOption == SendPaymentNotificationOption.email ||
              notificationOption == SendPaymentNotificationOption.all) &&
          (email == null || email!.trim().isEmpty))
        'CustomerEmail is required when NotificationOption is EML or ALL.',
    ];
  }
}

/// Documented SendPayment notification options.
enum SendPaymentNotificationOption {
  /// Send invoice link by email.
  @JsonValue('EML')
  email,

  /// Send invoice link by SMS.
  @JsonValue('SMS')
  sms,

  /// Return invoice link in the response only.
  @JsonValue('LNK')
  link,

  /// Send by email and SMS, and return the link in the response.
  @JsonValue('ALL')
  all,
}
