import 'package:json_annotation/json_annotation.dart';

part 'my_fatoorah_metadata.g.dart';

/// Merchant-defined metadata/custom fields.
///
/// TODO: Map endpoint-specific metadata limits once each endpoint is
/// implemented. Current docs mention custom fields such as `UserDefinedField`,
/// but do not define one universal metadata object for all APIs.
@JsonSerializable()
final class MyFatoorahMetadata {
  /// Creates metadata from key-value pairs.
  const MyFatoorahMetadata({this.values = const {}});

  /// Custom metadata values.
  final Map<String, Object?> values;

  /// Creates metadata from JSON.
  factory MyFatoorahMetadata.fromJson(Map<String, Object?> json) =>
      _$MyFatoorahMetadataFromJson(json);

  /// Converts this metadata to JSON.
  Map<String, Object?> toJson() => _$MyFatoorahMetadataToJson(this);
}
