import 'package:json_annotation/json_annotation.dart';

import '../serialization/my_fatoorah_decimal_converter.dart';
import '../serialization/my_fatoorah_json.dart';

part 'my_fatoorah_money.g.dart';

/// Money value with currency.
@JsonSerializable()
final class MyFatoorahMoney {
  /// Creates a money value.
  const MyFatoorahMoney({required this.amount, required this.currency});

  /// Decimal amount represented as text to preserve precision.
  @MyFatoorahDecimalConverter()
  @JsonKey(name: 'Amount')
  final String amount;

  /// Currency ISO/code value.
  @JsonKey(name: 'Currency')
  final String currency;

  /// Creates money from JSON.
  factory MyFatoorahMoney.fromJson(Map<String, Object?> json) =>
      _$MyFatoorahMoneyFromJson(json);

  /// Converts this money value to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$MyFatoorahMoneyToJson(this));
  }
}
