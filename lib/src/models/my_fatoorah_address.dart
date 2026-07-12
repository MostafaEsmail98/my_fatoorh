import 'package:json_annotation/json_annotation.dart';

import '../serialization/my_fatoorah_json.dart';

part 'my_fatoorah_address.g.dart';

/// Customer delivery address model documented by MyFatoorah.
@JsonSerializable()
final class MyFatoorahAddress {
  /// Creates an address.
  const MyFatoorahAddress({
    this.block,
    this.street,
    this.houseBuildingNo,
    this.address,
    this.addressInstructions,
  });

  /// Block number or area name.
  @JsonKey(name: 'Block')
  final String? block;

  /// Street name.
  @JsonKey(name: 'Street')
  final String? street;

  /// House or building number.
  @JsonKey(name: 'HouseBuildingNo')
  final String? houseBuildingNo;

  /// Full address details.
  @JsonKey(name: 'Address')
  final String? address;

  /// Additional address instructions.
  @JsonKey(name: 'AddressInstructions')
  final String? addressInstructions;

  /// Creates an address from JSON.
  factory MyFatoorahAddress.fromJson(Map<String, Object?> json) =>
      _$MyFatoorahAddressFromJson(json);

  /// Converts this address to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$MyFatoorahAddressToJson(this));
  }
}
