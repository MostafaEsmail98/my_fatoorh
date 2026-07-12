// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_hosted_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateHostedPaymentRequest _$CreateHostedPaymentRequestFromJson(
  Map<String, dynamic> json,
) => CreateHostedPaymentRequest(
  paymentMethod: json['PaymentMethod'] as String,
  order: HostedPaymentOrder.fromJson(json['Order'] as Map<String, dynamic>),
  integrationUrls: HostedPaymentIntegrationUrls.fromJson(
    json['IntegrationUrls'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateHostedPaymentRequestToJson(
  CreateHostedPaymentRequest instance,
) => <String, dynamic>{
  'PaymentMethod': instance.paymentMethod,
  'Order': instance.order.toJson(),
  'IntegrationUrls': instance.integrationUrls.toJson(),
};

HostedPaymentOrder _$HostedPaymentOrderFromJson(Map<String, dynamic> json) =>
    HostedPaymentOrder(
      amount: const MyFatoorahDecimalConverter().fromJson(json['Amount']),
    );

Map<String, dynamic> _$HostedPaymentOrderToJson(HostedPaymentOrder instance) =>
    <String, dynamic>{
      'Amount': const MyFatoorahDecimalConverter().toJson(instance.amount),
    };

HostedPaymentIntegrationUrls _$HostedPaymentIntegrationUrlsFromJson(
  Map<String, dynamic> json,
) => HostedPaymentIntegrationUrls(redirection: json['Redirection'] as String);

Map<String, dynamic> _$HostedPaymentIntegrationUrlsToJson(
  HostedPaymentIntegrationUrls instance,
) => <String, dynamic>{'Redirection': instance.redirection};
