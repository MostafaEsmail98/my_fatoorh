// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_hosted_payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateHostedPaymentResponse _$CreateHostedPaymentResponseFromJson(
  Map<String, dynamic> json,
) => CreateHostedPaymentResponse(
  invoiceId: json['InvoiceId'] as String,
  paymentId: json['PaymentId'] as String?,
  paymentUrl: json['PaymentURL'] as String,
  paymentCompleted: json['PaymentCompleted'] as bool,
  transactionDetails: json['TransactionDetails'],
);

Map<String, dynamic> _$CreateHostedPaymentResponseToJson(
  CreateHostedPaymentResponse instance,
) => <String, dynamic>{
  'InvoiceId': instance.invoiceId,
  'PaymentId': instance.paymentId,
  'PaymentURL': instance.paymentUrl,
  'PaymentCompleted': instance.paymentCompleted,
  'TransactionDetails': instance.transactionDetails,
};
