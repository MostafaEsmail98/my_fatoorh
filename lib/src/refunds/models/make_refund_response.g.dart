// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_refund_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeRefundResponse _$MakeRefundResponseFromJson(Map<String, dynamic> json) =>
    MakeRefundResponse(
      key: json['Key'] as String,
      refundId: (json['RefundId'] as num).toInt(),
      refundReference: json['RefundReference'] as String,
      refundInvoiceId: const MyFatoorahDecimalConverter().fromJson(
        json['RefundInvoiceId'],
      ),
      amount: const MyFatoorahDecimalConverter().fromJson(json['Amount']),
      comment: json['Comment'] as String?,
      externalIdentifier: json['ExternalIdentifier'] as String?,
    );

Map<String, dynamic> _$MakeRefundResponseToJson(MakeRefundResponse instance) =>
    <String, dynamic>{
      'Key': instance.key,
      'RefundId': instance.refundId,
      'RefundReference': instance.refundReference,
      'RefundInvoiceId': const MyFatoorahDecimalConverter().toJson(
        instance.refundInvoiceId,
      ),
      'Amount': const MyFatoorahDecimalConverter().toJson(instance.amount),
      'Comment': instance.comment,
      'ExternalIdentifier': instance.externalIdentifier,
    };
