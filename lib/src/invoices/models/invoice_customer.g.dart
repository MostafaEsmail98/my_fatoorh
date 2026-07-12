// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceCustomer _$InvoiceCustomerFromJson(Map<String, dynamic> json) =>
    InvoiceCustomer(
      name: json['CustomerName'] as String,
      mobileCountryCode: json['MobileCountryCode'] as String?,
      mobile: json['CustomerMobile'] as String?,
      email: json['CustomerEmail'] as String?,
      civilId: json['CustomerCivilId'] as String?,
    );

Map<String, dynamic> _$InvoiceCustomerToJson(InvoiceCustomer instance) =>
    <String, dynamic>{
      'CustomerName': instance.name,
      'MobileCountryCode': instance.mobileCountryCode,
      'CustomerMobile': instance.mobile,
      'CustomerEmail': instance.email,
      'CustomerCivilId': instance.civilId,
    };
