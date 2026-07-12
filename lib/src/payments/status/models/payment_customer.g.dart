// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentCustomer _$PaymentCustomerFromJson(Map<String, dynamic> json) =>
    PaymentCustomer(
      reference: json['Reference'] as String?,
      name: json['Name'] as String?,
      mobile: json['Mobile'] as String?,
      email: json['Email'] as String?,
    );

Map<String, dynamic> _$PaymentCustomerToJson(PaymentCustomer instance) =>
    <String, dynamic>{
      'Reference': instance.reference,
      'Name': instance.name,
      'Mobile': instance.mobile,
      'Email': instance.email,
    };
