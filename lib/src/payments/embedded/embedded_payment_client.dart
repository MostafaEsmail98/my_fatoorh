import '../../client/my_fatoorah_client.dart';
import '../../client/my_fatoorah_request.dart';
import '../../core/my_fatoorah_result.dart';
import '../../exceptions/my_fatoorah_api_exception.dart';
import '../../exceptions/my_fatoorah_validation_exception.dart';
import '../../models/my_fatoorah_api_response.dart';
import '../../serialization/my_fatoorah_json.dart';
import 'models/initiate_session_request.dart';
import 'models/initiate_session_response.dart';

/// Internal client for Embedded Payment APIs.
final class EmbeddedPaymentClient {
  /// Creates an embedded payment client.
  const EmbeddedPaymentClient(this._client);

  final MyFatoorahClient _client;

  /// Creates an Embedded Payment session.
  ///
  /// Official endpoint: `POST /v3/sessions`.
  Future<MyFatoorahResult<InitiateSessionResponse>> initiateSession(
    InitiateSessionRequest request,
  ) {
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      return Future.value(
        MyFatoorahResult.failure(
          MyFatoorahValidationException(
            validationErrors.join(' '),
            details: validationErrors,
          ),
        ),
      );
    }

    return _client.request<InitiateSessionResponse>(
      MyFatoorahRequest<InitiateSessionResponse>(
        method: MyFatoorahHttpMethod.post,
        path: '/v3/sessions',
        body: request.toJson(),
        parser: (response) {
          final apiResponse =
              MyFatoorahApiResponse<InitiateSessionResponse>.fromJson(
                MyFatoorahJson.asObject(response.data),
                (json) => InitiateSessionResponse.fromJson(
                  MyFatoorahJson.asObject(json),
                ),
              );

          final data = apiResponse.data;
          if (!apiResponse.isSuccess || data == null) {
            throw MyFatoorahApiException(
              apiResponse.message ??
                  'MyFatoorah embedded session creation failed.',
              details: {
                'ValidationErrors': apiResponse.validationErrors
                    ?.map((error) => error.toJson())
                    .toList(growable: false),
                'FieldsErrors': apiResponse.fieldsErrors
                    ?.map((error) => error.toJson())
                    .toList(growable: false),
              },
            );
          }

          return data;
        },
      ),
    );
  }
}
