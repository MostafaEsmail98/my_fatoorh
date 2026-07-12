// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_refund_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeRefundRequest _$MakeRefundRequestFromJson(Map<String, dynamic> json) =>
    MakeRefundRequest(
      keyType: $enumDecode(_$RefundKeyTypeEnumMap, json['KeyType']),
      key: json['Key'] as String,
      amount: const MyFatoorahDecimalConverter().fromJson(json['Amount']),
      serviceChargeOnCustomer: json['ServiceChargeOnCustomer'] as bool?,
      comment: json['Comment'] as String?,
      externalIdentifier: json['ExternalIdentifier'] as String?,
      amountDeductedFromSupplier: const MyFatoorahDecimalConverter().fromJson(
        json['AmountDeductedFromSupplier'],
      ),
    );

Map<String, dynamic> _$MakeRefundRequestToJson(MakeRefundRequest instance) =>
    <String, dynamic>{
      'KeyType': _$RefundKeyTypeEnumMap[instance.keyType]!,
      'Key': instance.key,
      'ServiceChargeOnCustomer': instance.serviceChargeOnCustomer,
      'Amount': const MyFatoorahDecimalConverter().toJson(instance.amount),
      'Comment': instance.comment,
      'ExternalIdentifier': instance.externalIdentifier,
      'AmountDeductedFromSupplier': _$JsonConverterToJson<Object?, String>(
        instance.amountDeductedFromSupplier,
        const MyFatoorahDecimalConverter().toJson,
      ),
    };

const _$RefundKeyTypeEnumMap = {
  RefundKeyType.invoiceId: 'InvoiceId',
  RefundKeyType.paymentId: 'PaymentId',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
