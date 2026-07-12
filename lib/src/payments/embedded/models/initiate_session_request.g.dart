// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_session_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateSessionRequest _$InitiateSessionRequestFromJson(
  Map<String, dynamic> json,
) => InitiateSessionRequest(
  paymentMode: $enumDecode(_$EmbeddedPaymentModeEnumMap, json['PaymentMode']),
  order: InitiateSessionOrder.fromJson(json['Order'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InitiateSessionRequestToJson(
  InitiateSessionRequest instance,
) => <String, dynamic>{
  'PaymentMode': _$EmbeddedPaymentModeEnumMap[instance.paymentMode]!,
  'Order': instance.order.toJson(),
};

const _$EmbeddedPaymentModeEnumMap = {
  EmbeddedPaymentMode.completePayment: 'COMPLETE_PAYMENT',
  EmbeddedPaymentMode.collectDetails: 'COLLECT_DETAILS',
};

InitiateSessionOrder _$InitiateSessionOrderFromJson(
  Map<String, dynamic> json,
) => InitiateSessionOrder(
  amount: const MyFatoorahDecimalConverter().fromJson(json['Amount']),
);

Map<String, dynamic> _$InitiateSessionOrderToJson(
  InitiateSessionOrder instance,
) => <String, dynamic>{
  'Amount': const MyFatoorahDecimalConverter().toJson(instance.amount),
};
