// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fatoorah_money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFatoorahMoney _$MyFatoorahMoneyFromJson(Map<String, dynamic> json) =>
    MyFatoorahMoney(
      amount: const MyFatoorahDecimalConverter().fromJson(json['Amount']),
      currency: json['Currency'] as String,
    );

Map<String, dynamic> _$MyFatoorahMoneyToJson(MyFatoorahMoney instance) =>
    <String, dynamic>{
      'Amount': const MyFatoorahDecimalConverter().toJson(instance.amount),
      'Currency': instance.currency,
    };
