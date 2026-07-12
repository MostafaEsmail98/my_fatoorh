// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentTransaction _$PaymentTransactionFromJson(
  Map<String, dynamic> json,
) => PaymentTransaction(
  id: json['Id'] as String,
  status: json['Status'] as String,
  paymentMethod: json['PaymentMethod'] as String?,
  paymentId: json['PaymentId'] as String?,
  referenceId: json['ReferenceId'] as String?,
  trackId: json['TrackId'] as String?,
  authorizationId: json['AuthorizationId'] as String?,
  transactionDate: const MyFatoorahDateConverter().fromJson(
    json['TransactionDate'],
  ),
  eci: json['ECI'] as String?,
  ip: json['IP'] == null
      ? null
      : PaymentTransactionIp.fromJson(json['IP'] as Map<String, dynamic>),
  error: json['Error'] == null
      ? null
      : PaymentTransactionError.fromJson(json['Error'] as Map<String, dynamic>),
  card: json['Card'] == null
      ? null
      : PaymentTransactionCard.fromJson(json['Card'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentTransactionToJson(PaymentTransaction instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Status': instance.status,
      'PaymentMethod': instance.paymentMethod,
      'PaymentId': instance.paymentId,
      'ReferenceId': instance.referenceId,
      'TrackId': instance.trackId,
      'AuthorizationId': instance.authorizationId,
      'TransactionDate': const MyFatoorahDateConverter().toJson(
        instance.transactionDate,
      ),
      'ECI': instance.eci,
      'IP': instance.ip?.toJson(),
      'Error': instance.error?.toJson(),
      'Card': instance.card?.toJson(),
    };

PaymentTransactionIp _$PaymentTransactionIpFromJson(
  Map<String, dynamic> json,
) => PaymentTransactionIp(
  address: json['Address'] as String?,
  country: json['Country'] as String?,
);

Map<String, dynamic> _$PaymentTransactionIpToJson(
  PaymentTransactionIp instance,
) => <String, dynamic>{
  'Address': instance.address,
  'Country': instance.country,
};

PaymentTransactionError _$PaymentTransactionErrorFromJson(
  Map<String, dynamic> json,
) => PaymentTransactionError(
  code: json['Code'] as String?,
  message: json['Message'] as String?,
);

Map<String, dynamic> _$PaymentTransactionErrorToJson(
  PaymentTransactionError instance,
) => <String, dynamic>{'Code': instance.code, 'Message': instance.message};

PaymentTransactionCard _$PaymentTransactionCardFromJson(
  Map<String, dynamic> json,
) => PaymentTransactionCard(
  nameOnCard: json['NameOnCard'] as String?,
  number: json['Number'] as String?,
  token: json['Token'] as String?,
  panHash: json['PanHash'] as String?,
  expiryMonth: json['ExpiryMonth'] as String?,
  expiryYear: json['ExpiryYear'] as String?,
  brand: json['Brand'] as String?,
  issuer: json['Issuer'] as String?,
  issuerCountry: json['IssuerCountry'] as String?,
  fundingMethod: json['FundingMethod'] as String?,
);

Map<String, dynamic> _$PaymentTransactionCardToJson(
  PaymentTransactionCard instance,
) => <String, dynamic>{
  'NameOnCard': instance.nameOnCard,
  'Number': instance.number,
  'Token': instance.token,
  'PanHash': instance.panHash,
  'ExpiryMonth': instance.expiryMonth,
  'ExpiryYear': instance.expiryYear,
  'Brand': instance.brand,
  'Issuer': instance.issuer,
  'IssuerCountry': instance.issuerCountry,
  'FundingMethod': instance.fundingMethod,
};
