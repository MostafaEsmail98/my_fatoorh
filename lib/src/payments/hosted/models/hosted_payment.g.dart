// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hosted_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostedPayment _$HostedPaymentFromJson(Map<String, dynamic> json) =>
    HostedPayment(
      invoiceId: json['InvoiceId'] as String,
      paymentId: json['PaymentId'] as String?,
      paymentUrl: json['PaymentURL'] as String,
      status: $enumDecode(_$HostedPaymentStatusEnumMap, json['Status']),
    );

Map<String, dynamic> _$HostedPaymentToJson(HostedPayment instance) =>
    <String, dynamic>{
      'InvoiceId': instance.invoiceId,
      'PaymentId': instance.paymentId,
      'PaymentURL': instance.paymentUrl,
      'Status': _$HostedPaymentStatusEnumMap[instance.status]!,
    };

const _$HostedPaymentStatusEnumMap = {
  HostedPaymentStatus.created: 'created',
  HostedPaymentStatus.completed: 'completed',
};
