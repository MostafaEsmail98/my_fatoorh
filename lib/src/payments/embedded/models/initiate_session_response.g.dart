// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateSessionResponse _$InitiateSessionResponseFromJson(
  Map<String, dynamic> json,
) => InitiateSessionResponse(
  sessionId: json['SessionId'] as String,
  sessionExpiry: const MyFatoorahDateConverter().fromJson(
    json['SessionExpiry'],
  ),
  encryptionKey: json['EncryptionKey'] as String,
  operationType: json['OperationType'] as String,
  order: EmbeddedSessionOrder.fromJson(json['Order'] as Map<String, dynamic>),
  customer: EmbeddedSessionCustomer.fromJson(
    json['Customer'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$InitiateSessionResponseToJson(
  InitiateSessionResponse instance,
) => <String, dynamic>{
  'SessionId': instance.sessionId,
  'SessionExpiry': const MyFatoorahDateConverter().toJson(
    instance.sessionExpiry,
  ),
  'EncryptionKey': instance.encryptionKey,
  'OperationType': instance.operationType,
  'Order': instance.order.toJson(),
  'Customer': instance.customer.toJson(),
};

EmbeddedSessionOrder _$EmbeddedSessionOrderFromJson(
  Map<String, dynamic> json,
) => EmbeddedSessionOrder(
  amount: const MyFatoorahDecimalConverter().fromJson(json['Amount']),
  currency: json['Currency'] as String,
  externalIdentifier: json['ExternalIdentifier'] as String?,
);

Map<String, dynamic> _$EmbeddedSessionOrderToJson(
  EmbeddedSessionOrder instance,
) => <String, dynamic>{
  'Amount': const MyFatoorahDecimalConverter().toJson(instance.amount),
  'Currency': instance.currency,
  'ExternalIdentifier': instance.externalIdentifier,
};

EmbeddedSessionCustomer _$EmbeddedSessionCustomerFromJson(
  Map<String, dynamic> json,
) => EmbeddedSessionCustomer(
  reference: json['Reference'] as String?,
  cards: json['Cards'],
);

Map<String, dynamic> _$EmbeddedSessionCustomerToJson(
  EmbeddedSessionCustomer instance,
) => <String, dynamic>{
  'Reference': instance.reference,
  'Cards': instance.cards,
};
