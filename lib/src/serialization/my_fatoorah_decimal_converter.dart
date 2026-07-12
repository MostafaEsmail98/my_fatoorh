import 'package:json_annotation/json_annotation.dart';

/// Converts MyFatoorah decimal values while preserving their textual precision.
///
/// MyFatoorah examples use both JSON numbers and strings for amount-like
/// values. Until endpoint-specific numeric constraints are implemented, the SDK
/// stores decimals as strings to avoid floating-point precision surprises.
final class MyFatoorahDecimalConverter
    implements JsonConverter<String, Object?> {
  /// Creates a decimal converter.
  const MyFatoorahDecimalConverter();

  @override
  String fromJson(Object? json) {
    if (json is String) {
      return json;
    }
    if (json is num) {
      return json.toString();
    }
    throw FormatException('Expected a decimal string or number, got $json.');
  }

  @override
  Object toJson(String object) {
    return object;
  }
}
