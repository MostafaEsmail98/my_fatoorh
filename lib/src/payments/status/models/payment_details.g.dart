// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      invoice: PaymentInvoice.fromJson(json['Invoice'] as Map<String, dynamic>),
      transaction: PaymentTransaction.fromJson(
        json['Transaction'] as Map<String, dynamic>,
      ),
      customer: PaymentCustomer.fromJson(
        json['Customer'] as Map<String, dynamic>,
      ),
      amount: PaymentAmount.fromJson(json['Amount'] as Map<String, dynamic>),
      suppliers: json['Suppliers'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'Invoice': instance.invoice.toJson(),
      'Transaction': instance.transaction.toJson(),
      'Customer': instance.customer.toJson(),
      'Amount': instance.amount.toJson(),
      'Suppliers': instance.suppliers,
    };

PaymentAmount _$PaymentAmountFromJson(Map<String, dynamic> json) =>
    PaymentAmount(
      baseCurrency: json['BaseCurrency'] as String?,
      valueInBaseCurrency: const MyFatoorahDecimalConverter().fromJson(
        json['ValueInBaseCurrency'],
      ),
      serviceCharge: const MyFatoorahDecimalConverter().fromJson(
        json['ServiceCharge'],
      ),
      serviceChargeVat: const MyFatoorahDecimalConverter().fromJson(
        json['ServiceChargeVAT'],
      ),
      receivableAmount: const MyFatoorahDecimalConverter().fromJson(
        json['ReceivableAmount'],
      ),
      displayCurrency: json['DisplayCurrency'] as String?,
      valueInDisplayCurrency: const MyFatoorahDecimalConverter().fromJson(
        json['ValueInDisplayCurrency'],
      ),
      payCurrency: json['PayCurrency'] as String?,
      valueInPayCurrency: const MyFatoorahDecimalConverter().fromJson(
        json['ValueInPayCurrency'],
      ),
    );

Map<String, dynamic> _$PaymentAmountToJson(PaymentAmount instance) =>
    <String, dynamic>{
      'BaseCurrency': instance.baseCurrency,
      'ValueInBaseCurrency': _$JsonConverterToJson<Object?, String>(
        instance.valueInBaseCurrency,
        const MyFatoorahDecimalConverter().toJson,
      ),
      'ServiceCharge': _$JsonConverterToJson<Object?, String>(
        instance.serviceCharge,
        const MyFatoorahDecimalConverter().toJson,
      ),
      'ServiceChargeVAT': _$JsonConverterToJson<Object?, String>(
        instance.serviceChargeVat,
        const MyFatoorahDecimalConverter().toJson,
      ),
      'ReceivableAmount': _$JsonConverterToJson<Object?, String>(
        instance.receivableAmount,
        const MyFatoorahDecimalConverter().toJson,
      ),
      'DisplayCurrency': instance.displayCurrency,
      'ValueInDisplayCurrency': _$JsonConverterToJson<Object?, String>(
        instance.valueInDisplayCurrency,
        const MyFatoorahDecimalConverter().toJson,
      ),
      'PayCurrency': instance.payCurrency,
      'ValueInPayCurrency': _$JsonConverterToJson<Object?, String>(
        instance.valueInPayCurrency,
        const MyFatoorahDecimalConverter().toJson,
      ),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
