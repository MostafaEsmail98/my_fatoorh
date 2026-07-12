import 'package:json_annotation/json_annotation.dart';

/// Converts MyFatoorah ISO-8601 date/time strings to [DateTime].
final class MyFatoorahDateConverter
    implements JsonConverter<DateTime?, Object?> {
  /// Creates a nullable date converter.
  const MyFatoorahDateConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null || json == '') {
      return null;
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    throw FormatException('Expected an ISO-8601 date string, got $json.');
  }

  @override
  String? toJson(DateTime? object) {
    return object?.toIso8601String();
  }
}
