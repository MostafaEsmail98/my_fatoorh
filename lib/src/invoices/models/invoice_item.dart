import 'package:json_annotation/json_annotation.dart';

import '../../serialization/my_fatoorah_decimal_converter.dart';
import '../../serialization/my_fatoorah_json.dart';

part 'invoice_item.g.dart';

/// Invoice item model documented by MyFatoorah SendPayment.
@JsonSerializable()
final class InvoiceItem {
  /// Creates an invoice item.
  const InvoiceItem({
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
  factory InvoiceItem.fromJson(Map<String, Object?> json) =>
      _$InvoiceItemFromJson(json);

  /// Converts this invoice item to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$InvoiceItemToJson(this));
  }

  /// Returns validation messages for documented required fields.
  List<String> validate() {
    final parsedUnitPrice = num.tryParse(unitPrice.trim());
    return [
      if (itemName.trim().isEmpty) 'InvoiceItems.ItemName is required.',
      if (quantity <= 0) 'InvoiceItems.Quantity must be positive.',
      if (unitPrice.trim().isEmpty)
        'InvoiceItems.UnitPrice is required.'
      else if (parsedUnitPrice == null || parsedUnitPrice <= 0)
        'InvoiceItems.UnitPrice must be positive.',
    ];
  }
}
