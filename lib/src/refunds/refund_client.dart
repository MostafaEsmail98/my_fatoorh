import '../client/my_fatoorah_client.dart';
import '../client/my_fatoorah_request.dart';
import '../core/my_fatoorah_result.dart';
import '../exceptions/my_fatoorah_api_exception.dart';
import '../exceptions/my_fatoorah_validation_exception.dart';
import '../models/my_fatoorah_api_response.dart';
import '../serialization/my_fatoorah_json.dart';
import 'models/make_refund_request.dart';
import 'models/make_refund_response.dart';

/// Internal client for MyFatoorah refund APIs.
final class RefundClient {
  /// Creates a refund client.
  const RefundClient(this._client);

  final MyFatoorahClient _client;

  /// Makes a MyFatoorah refund request.
  ///
  /// Official endpoint: `POST /v2/MakeRefund`.
  Future<MyFatoorahResult<MakeRefundResponse>> make(MakeRefundRequest request) {
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

    return _client.request<MakeRefundResponse>(
      MyFatoorahRequest<MakeRefundResponse>(
        method: MyFatoorahHttpMethod.post,
        path: '/v2/MakeRefund',
        body: request.toJson(),
        parser: (response) {
          final apiResponse =
              MyFatoorahApiResponse<MakeRefundResponse>.fromJson(
                MyFatoorahJson.asObject(response.data),
                (json) =>
                    MakeRefundResponse.fromJson(MyFatoorahJson.asObject(json)),
              );

          final data = apiResponse.data;
          if (!apiResponse.isSuccess || data == null) {
            throw MyFatoorahApiException(
              apiResponse.message ?? 'MyFatoorah MakeRefund failed.',
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
