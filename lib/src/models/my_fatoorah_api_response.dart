import 'package:json_annotation/json_annotation.dart';

import '../serialization/my_fatoorah_json.dart';

part 'my_fatoorah_api_response.g.dart';

/// Common MyFatoorah API response wrapper.
///
/// Official docs describe a standard shape containing `IsSuccess`, `Message`,
/// `ValidationErrors`/`FieldsErrors`, and endpoint-specific `Data`.
@JsonSerializable(genericArgumentFactories: true)
final class MyFatoorahApiResponse<T> {
  /// Creates a common API response wrapper.
  const MyFatoorahApiResponse({
    required this.isSuccess,
    this.message,
    this.validationErrors,
    this.fieldsErrors,
    this.data,
  });

  /// Whether the API request succeeded.
  @JsonKey(name: 'IsSuccess', fromJson: _boolFromJson)
  final bool isSuccess;

  /// API message.
  @JsonKey(name: 'Message')
  final String? message;

  /// Validation errors returned by the API.
  @JsonKey(name: 'ValidationErrors')
  final List<MyFatoorahValidationError>? validationErrors;

  /// Field errors returned by some API responses.
  @JsonKey(name: 'FieldsErrors')
  final List<MyFatoorahValidationError>? fieldsErrors;

  /// Endpoint-specific response data.
  @JsonKey(name: 'Data')
  final T? data;

  /// Creates an API response from JSON.
  factory MyFatoorahApiResponse.fromJson(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT,
  ) => _$MyFatoorahApiResponseFromJson(json, fromJsonT);

  /// Converts this API response to JSON.
  Map<String, Object?> toJson(Object? Function(T value) toJsonT) {
    return MyFatoorahJson.withoutNulls(
      _$MyFatoorahApiResponseToJson(this, toJsonT),
    );
  }

  static bool _boolFromJson(Object? json) {
    if (json is bool) {
      return json;
    }
    if (json is String) {
      return json.toLowerCase() == 'true';
    }
    throw FormatException('Expected a boolean or boolean string, got $json.');
  }
}

/// Validation error item from the common MyFatoorah response model.
@JsonSerializable()
final class MyFatoorahValidationError {
  /// Creates a validation error.
  const MyFatoorahValidationError({this.name, this.error});

  /// Parameter or field name.
  @JsonKey(name: 'Name')
  final String? name;

  /// Validation error text.
  @JsonKey(name: 'Error')
  final String? error;

  /// Creates a validation error from JSON.
  factory MyFatoorahValidationError.fromJson(Map<String, Object?> json) =>
      _$MyFatoorahValidationErrorFromJson(json);

  /// Converts this validation error to JSON.
  Map<String, Object?> toJson() {
    return MyFatoorahJson.withoutNulls(_$MyFatoorahValidationErrorToJson(this));
  }
}
