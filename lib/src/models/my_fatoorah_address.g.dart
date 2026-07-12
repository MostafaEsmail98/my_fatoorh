// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fatoorah_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFatoorahAddress _$MyFatoorahAddressFromJson(Map<String, dynamic> json) =>
    MyFatoorahAddress(
      block: json['Block'] as String?,
      street: json['Street'] as String?,
      houseBuildingNo: json['HouseBuildingNo'] as String?,
      address: json['Address'] as String?,
      addressInstructions: json['AddressInstructions'] as String?,
    );

Map<String, dynamic> _$MyFatoorahAddressToJson(MyFatoorahAddress instance) =>
    <String, dynamic>{
      'Block': instance.block,
      'Street': instance.street,
      'HouseBuildingNo': instance.houseBuildingNo,
      'Address': instance.address,
      'AddressInstructions': instance.addressInstructions,
    };
