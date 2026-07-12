// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      paymentMethodId: (json['PaymentMethodId'] as num).toInt(),
      paymentMethodAr: json['PaymentMethodAr'] as String?,
      paymentMethodEn: json['PaymentMethodEn'] as String,
      paymentMethodCode: json['PaymentMethodCode'] as String,
      isDirectPayment: json['IsDirectPayment'] as bool,
      serviceCharge: const MyFatoorahDecimalConverter().fromJson(
        json['ServiceCharge'],
      ),
      totalAmount: const MyFatoorahDecimalConverter().fromJson(
        json['TotalAmount'],
      ),
      currencyIso: json['CurrencyIso'] as String,
      imageUrl: json['ImageUrl'] as String,
      isEmbeddedSupported: json['IsEmbeddedSupported'] as bool,
      paymentCurrencyIso: json['PaymentCurrencyIso'] as String,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'PaymentMethodId': instance.paymentMethodId,
      'PaymentMethodAr': instance.paymentMethodAr,
      'PaymentMethodEn': instance.paymentMethodEn,
      'PaymentMethodCode': instance.paymentMethodCode,
      'IsDirectPayment': instance.isDirectPayment,
      'ServiceCharge': const MyFatoorahDecimalConverter().toJson(
        instance.serviceCharge,
      ),
      'TotalAmount': const MyFatoorahDecimalConverter().toJson(
        instance.totalAmount,
      ),
      'CurrencyIso': instance.currencyIso,
      'ImageUrl': instance.imageUrl,
      'IsEmbeddedSupported': instance.isEmbeddedSupported,
      'PaymentCurrencyIso': instance.paymentCurrencyIso,
    };
