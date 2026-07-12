// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendPaymentResponse _$SendPaymentResponseFromJson(Map<String, dynamic> json) =>
    SendPaymentResponse(
      invoiceId: (json['InvoiceId'] as num).toInt(),
      invoiceUrl: json['InvoiceURL'] as String,
      customerReference: json['CustomerReference'] as String?,
      userDefinedField: json['UserDefinedField'] as String?,
    );

Map<String, dynamic> _$SendPaymentResponseToJson(
  SendPaymentResponse instance,
) => <String, dynamic>{
  'InvoiceId': instance.invoiceId,
  'InvoiceURL': instance.invoiceUrl,
  'CustomerReference': instance.customerReference,
  'UserDefinedField': instance.userDefinedField,
};
