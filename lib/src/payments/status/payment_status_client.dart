import '../../client/my_fatoorah_client.dart';
import '../../client/my_fatoorah_request.dart';
import '../../core/my_fatoorah_result.dart';
import '../../exceptions/my_fatoorah_api_exception.dart';
import '../../exceptions/my_fatoorah_validation_exception.dart';
import '../../models/my_fatoorah_api_response.dart';
import '../../serialization/my_fatoorah_json.dart';
import 'models/get_payment_details_response.dart';

/// Internal client for payment status APIs.
final class PaymentStatusClient {
  /// Creates a payment status client.
  const PaymentStatusClient(this._client);

  final MyFatoorahClient _client;

  /// Gets payment details by payment ID.
  ///
  /// Official endpoint: `GET /v3/payments/{paymentId}`.
  Future<MyFatoorahResult<GetPaymentDetailsResponse>> get(String paymentId) {
    final normalizedPaymentId = paymentId.trim();
    if (normalizedPaymentId.isEmpty) {
      return Future.value(
        const MyFatoorahResult.failure(
          MyFatoorahValidationException('PaymentId is required.'),
        ),
      );
    }

    return _client.request<GetPaymentDetailsResponse>(
      MyFatoorahRequest<GetPaymentDetailsResponse>(
        method: MyFatoorahHttpMethod.get,
        path: '/v3/payments/${Uri.encodeComponent(normalizedPaymentId)}',
        parser: (response) {
          final apiResponse =
              MyFatoorahApiResponse<GetPaymentDetailsResponse>.fromJson(
                MyFatoorahJson.asObject(response.data),
                (json) => GetPaymentDetailsResponse.fromJson(
                  MyFatoorahJson.asObject(json),
                ),
              );

          final data = apiResponse.data;
          if (!apiResponse.isSuccess || data == null) {
            throw MyFatoorahApiException(
              apiResponse.message ?? 'MyFatoorah payment status lookup failed.',
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
