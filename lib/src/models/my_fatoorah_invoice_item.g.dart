// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fatoorah_invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFatoorahInvoiceItem _$MyFatoorahInvoiceItemFromJson(
  Map<String, dynamic> json,
) => MyFatoorahInvoiceItem(
  itemName: json['ItemName'] as String,
  quantity: (json['Quantity'] as num).toInt(),
  unitPrice: const MyFatoorahDecimalConverter().fromJson(json['UnitPrice']),
  weight: const MyFatoorahDecimalConverter().fromJson(json['Weight']),
  width: const MyFatoorahDecimalConverter().fromJson(json['Width']),
  height: const MyFatoorahDecimalConverter().fromJson(json['Height']),
  depth: const MyFatoorahDecimalConverter().fromJson(json['Depth']),
);

Map<String, dynamic> _$MyFatoorahInvoiceItemToJson(
  MyFatoorahInvoiceItem instance,
) => <String, dynamic>{
  'ItemName': instance.itemName,
  'Quantity': instance.quantity,
  'UnitPrice': const MyFatoorahDecimalConverter().toJson(instance.unitPrice),
  'Weight': _$JsonConverterToJson<Object?, String>(
    instance.weight,
    const MyFatoorahDecimalConverter().toJson,
  ),
  'Width': _$JsonConverterToJson<Object?, String>(
    instance.width,
    const MyFatoorahDecimalConverter().toJson,
  ),
  'Height': _$JsonConverterToJson<Object?, String>(
    instance.height,
    const MyFatoorahDecimalConverter().toJson,
  ),
  'Depth': _$JsonConverterToJson<Object?, String>(
    instance.depth,
    const MyFatoorahDecimalConverter().toJson,
  ),
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
