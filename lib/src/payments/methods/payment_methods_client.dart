import '../../client/my_fatoorah_client.dart';
import '../../client/my_fatoorah_request.dart';
import '../../core/my_fatoorah_result.dart';
import '../../exceptions/my_fatoorah_api_exception.dart';
import '../../exceptions/my_fatoorah_validation_exception.dart';
import '../../models/my_fatoorah_api_response.dart';
import '../../serialization/my_fatoorah_json.dart';
import 'models/initiate_payment_request.dart';
import 'models/initiate_payment_response.dart';

/// Internal client for Payment Methods APIs.
final class PaymentMethodsClient {
  /// Creates a payment methods client.
  const PaymentMethodsClient(this._client);

  final MyFatoorahClient _client;

  /// Gets available payment methods.
  ///
  /// Official endpoint: `POST /v2/InitiatePayment`.
  Future<MyFatoorahResult<InitiatePaymentResponse>> get(
    InitiatePaymentRequest request,
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

    return _client.request<InitiatePaymentResponse>(
      MyFatoorahRequest<InitiatePaymentResponse>(
        method: MyFatoorahHttpMethod.post,
        path: '/v2/InitiatePayment',
        body: request.toJson(),
        parser: (response) {
          final apiResponse =
              MyFatoorahApiResponse<InitiatePaymentResponse>.fromJson(
                MyFatoorahJson.asObject(response.data),
                (json) => InitiatePaymentResponse.fromJson(
                  MyFatoorahJson.asObject(json),
                ),
              );

          final data = apiResponse.data;
          if (!apiResponse.isSuccess || data == null) {
            throw MyFatoorahApiException(
              apiResponse.message ??
                  'MyFatoorah payment methods lookup failed.',
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
