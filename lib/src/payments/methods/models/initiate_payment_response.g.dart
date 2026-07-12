// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiatePaymentResponse _$InitiatePaymentResponseFromJson(
  Map<String, dynamic> json,
) => InitiatePaymentResponse(
  paymentMethods: (json['PaymentMethods'] as List<dynamic>)
      .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InitiatePaymentResponseToJson(
  InitiatePaymentResponse instance,
) => <String, dynamic>{
  'PaymentMethods': instance.paymentMethods.map((e) => e.toJson()).toList(),
};
