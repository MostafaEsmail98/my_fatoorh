// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fatoorah_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFatoorahApiResponse<T> _$MyFatoorahApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => MyFatoorahApiResponse<T>(
  isSuccess: MyFatoorahApiResponse._boolFromJson(json['IsSuccess']),
  message: json['Message'] as String?,
  validationErrors: (json['ValidationErrors'] as List<dynamic>?)
      ?.map(
        (e) => MyFatoorahValidationError.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  fieldsErrors: (json['FieldsErrors'] as List<dynamic>?)
      ?.map(
        (e) => MyFatoorahValidationError.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  data: _$nullableGenericFromJson(json['Data'], fromJsonT),
);

Map<String, dynamic> _$MyFatoorahApiResponseToJson<T>(
  MyFatoorahApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'IsSuccess': instance.isSuccess,
  'Message': instance.message,
  'ValidationErrors': instance.validationErrors,
  'FieldsErrors': instance.fieldsErrors,
  'Data': _$nullableGenericToJson(instance.data, toJsonT),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

MyFatoorahValidationError _$MyFatoorahValidationErrorFromJson(
  Map<String, dynamic> json,
) => MyFatoorahValidationError(
  name: json['Name'] as String?,
  error: json['Error'] as String?,
);

Map<String, dynamic> _$MyFatoorahValidationErrorToJson(
  MyFatoorahValidationError instance,
) => <String, dynamic>{'Name': instance.name, 'Error': instance.error};
