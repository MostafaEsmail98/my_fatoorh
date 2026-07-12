// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiatePaymentRequest _$InitiatePaymentRequestFromJson(
  Map<String, dynamic> json,
) => InitiatePaymentRequest(
  invoiceAmount: const MyFatoorahDecimalConverter().fromJson(
    json['InvoiceAmount'],
  ),
  currencyIso: json['CurrencyIso'] as String,
);

Map<String, dynamic> _$InitiatePaymentRequestToJson(
  InitiatePaymentRequest instance,
) => <String, dynamic>{
  'InvoiceAmount': const MyFatoorahDecimalConverter().toJson(
    instance.invoiceAmount,
  ),
  'CurrencyIso': instance.currencyIso,
};
