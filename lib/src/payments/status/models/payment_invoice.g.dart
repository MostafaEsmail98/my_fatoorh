// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInvoice _$PaymentInvoiceFromJson(Map<String, dynamic> json) =>
    PaymentInvoice(
      id: json['Id'] as String,
      status: json['Status'] as String,
      reference: json['Reference'] as String?,
      creationDate: const MyFatoorahDateConverter().fromJson(
        json['CreationDate'],
      ),
      expirationDate: const MyFatoorahDateConverter().fromJson(
        json['ExpirationDate'],
      ),
      externalIdentifier: json['ExternalIdentifier'] as String?,
      userDefinedField: json['UserDefinedField'] as String?,
      metaData: json['MetaData'],
    );

Map<String, dynamic> _$PaymentInvoiceToJson(
  PaymentInvoice instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Status': instance.status,
  'Reference': instance.reference,
  'CreationDate': const MyFatoorahDateConverter().toJson(instance.creationDate),
  'ExpirationDate': const MyFatoorahDateConverter().toJson(
    instance.expirationDate,
  ),
  'ExternalIdentifier': instance.externalIdentifier,
  'UserDefinedField': instance.userDefinedField,
  'MetaData': instance.metaData,
};
