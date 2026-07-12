/// Shared JSON helpers used by generated and hand-written serialization code.
final class MyFatoorahJson {
  const MyFatoorahJson._();

  /// Converts a JSON value into an object map.
  static Map<String, Object?> asObject(Object? json) {
    if (json is Map<String, Object?>) {
      return json;
    }
    if (json is Map) {
      return json.map((key, value) => MapEntry(key.toString(), value));
    }
    throw FormatException('Expected a JSON object, got ${json.runtimeType}.');
  }

  /// Converts a JSON value into a list of object maps.
  static List<Map<String, Object?>> asObjectList(Object? json) {
    if (json == null) {
      return const [];
    }
    if (json is! List) {
      throw FormatException('Expected a JSON array, got ${json.runtimeType}.');
    }
    return json.map(asObject).toList(growable: false);
  }

  /// Removes entries whose values are null.
  static Map<String, Object?> withoutNulls(Map<String, Object?> json) {
    return Map.fromEntries(json.entries.where((entry) => entry.value != null));
  }
}
