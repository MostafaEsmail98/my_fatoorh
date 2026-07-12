import 'package:json_annotation/json_annotation.dart';

import '../serialization/my_fatoorah_decimal_converter.dart';
import '../serialization/my_fatoorah_json.dart';

part 'my_fatoorah_invoice_item.g.dart';

/// Invoice item model documented by MyFatoorah.
@JsonSerializable()
final class MyFatoorahInvoiceItem {
  /// Creates an invoice item.
  const MyFatoorahInvoiceItem({
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    this.weight,
    this.width,
    this.height,
    this.depth,
  });

  /// Item name displayed in the invoice.
  @JsonKey(name: 'ItemName')
  final String itemName;

  /// Item quantity.
  @JsonKey(name: 'Quantity')
  final int quantity;

  /// Item unit price.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'UnitPrice')
  final String unitPrice;

  /// Weight in kg.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Weight')
  final String? weight;

  /// Width in cm.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Width')
  final String? width;

  /// Height in cm.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Height')
  final String? height;

  /// Depth in cm.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Depth')
  final String? depth;

  /// Creates an invoice item from JSON.
  factory MyFatoorahInvoiceItem.fromJson(Map<String, Object?> json) =>
      _$MyFatoorahInvoiceItemFromJson(json);

  /// Converts this invoice item to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$MyFatoorahInvoiceItemToJson(this));
  }
}
