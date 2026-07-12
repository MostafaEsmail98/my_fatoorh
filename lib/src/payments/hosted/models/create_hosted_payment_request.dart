import 'package:json_annotation/json_annotation.dart';

import '../../../serialization/my_fatoorah_decimal_converter.dart';
import '../../../serialization/my_fatoorah_json.dart';

part 'create_hosted_payment_request.g.dart';

/// Request body for Hosted Payment Page `POST /v3/payments`.
@JsonSerializable(explicitToJson: true)
final class CreateHostedPaymentRequest {
  /// Creates a hosted payment request.
  const CreateHostedPaymentRequest({
    required this.paymentMethod,
    required this.order,
    required this.integrationUrls,
  });

  /// Selected payment method, for example `CARD` or `APPLE_PAY`.
  @JsonKey(name: 'PaymentMethod')
  final String paymentMethod;

  /// Order details.
  @JsonKey(name: 'Order')
  final HostedPaymentOrder order;

  /// Integration callback URLs.
  @JsonKey(name: 'IntegrationUrls')
  final HostedPaymentIntegrationUrls integrationUrls;

  /// Creates a hosted payment request from JSON.
  factory CreateHostedPaymentRequest.fromJson(Map<String, Object?> json) =>
      _$CreateHostedPaymentRequestFromJson(json);

  /// Converts this request to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(
      _$CreateHostedPaymentRequestToJson(this),
    );
  }

  /// Returns validation messages for required documented fields.
  List<String> validate() {
    return [
      if (paymentMethod.trim().isEmpty) 'PaymentMethod is required.',
      ...order.validate(),
      ...integrationUrls.validate(),
    ];
  }
}

/// Hosted payment order details.
@JsonSerializable()
final class HostedPaymentOrder {
  /// Creates hosted payment order details.
  const HostedPaymentOrder({required this.amount});

  /// Order amount.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Amount')
  final String amount;

  /// Creates order details from JSON.
  factory HostedPaymentOrder.fromJson(Map<String, Object?> json) =>
      _$HostedPaymentOrderFromJson(json);

  /// Converts this order to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$HostedPaymentOrderToJson(this));
  }

  /// Returns validation messages for required documented fields.
  List<String> validate() {
    return [if (amount.trim().isEmpty) 'Order.Amount is required.'];
  }
}

/// Hosted payment integration URLs.
@JsonSerializable()
final class HostedPaymentIntegrationUrls {
  /// Creates hosted payment integration URLs.
  const HostedPaymentIntegrationUrls({required this.redirection});

  /// URL MyFatoorah redirects the customer to after payment completion.
  @JsonKey(name: 'Redirection')
  final String redirection;

  /// Creates integration URLs from JSON.
  factory HostedPaymentIntegrationUrls.fromJson(Map<String, Object?> json) =>
      _$HostedPaymentIntegrationUrlsFromJson(json);

  /// Converts these integration URLs to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(
      _$HostedPaymentIntegrationUrlsToJson(this),
    );
  }

  /// Returns validation messages for required documented fields.
  List<String> validate() {
    return [
      if (redirection.trim().isEmpty)
        'IntegrationUrls.Redirection is required.',
    ];
  }
}
