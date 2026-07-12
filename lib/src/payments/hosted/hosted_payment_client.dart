import '../../client/my_fatoorah_client.dart';
import '../../client/my_fatoorah_request.dart';
import '../../core/my_fatoorah_result.dart';
import '../../exceptions/my_fatoorah_api_exception.dart';
import '../../exceptions/my_fatoorah_validation_exception.dart';
import '../../models/my_fatoorah_api_response.dart';
import '../../serialization/my_fatoorah_json.dart';
import 'models/create_hosted_payment_request.dart';
import 'models/create_hosted_payment_response.dart';

/// Internal client for Hosted Payment Page v3 APIs.
final class HostedPaymentClient {
  /// Creates a hosted payment client.
  const HostedPaymentClient(this._client);

  final MyFatoorahClient _client;

  /// Creates a Hosted Payment Page payment.
  ///
  /// Official endpoint: `POST /v3/payments`.
  Future<MyFatoorahResult<CreateHostedPaymentResponse>> create(
    CreateHostedPaymentRequest request,
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

    return _client.request<CreateHostedPaymentResponse>(
      MyFatoorahRequest<CreateHostedPaymentResponse>(
        method: MyFatoorahHttpMethod.post,
        path: '/v3/payments',
        body: request.toJson(),
        parser: (response) {
          final apiResponse =
              MyFatoorahApiResponse<CreateHostedPaymentResponse>.fromJson(
                MyFatoorahJson.asObject(response.data),
                (json) => CreateHostedPaymentResponse.fromJson(
                  MyFatoorahJson.asObject(json),
                ),
              );

          final data = apiResponse.data;
          if (!apiResponse.isSuccess || data == null) {
            throw MyFatoorahApiException(
              apiResponse.message ?? 'MyFatoorah hosted payment failed.',
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
