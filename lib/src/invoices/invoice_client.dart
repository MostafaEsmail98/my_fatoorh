import '../client/my_fatoorah_client.dart';
import '../client/my_fatoorah_request.dart';
import '../core/my_fatoorah_result.dart';
import '../exceptions/my_fatoorah_api_exception.dart';
import '../exceptions/my_fatoorah_validation_exception.dart';
import '../models/my_fatoorah_api_response.dart';
import '../serialization/my_fatoorah_json.dart';
import 'models/send_payment_request.dart';
import 'models/send_payment_response.dart';

/// Internal client for MyFatoorah invoice APIs.
final class InvoiceClient {
  /// Creates an invoice client.
  const InvoiceClient(this._client);

  final MyFatoorahClient _client;

  /// Sends a MyFatoorah invoice/payment link.
  ///
  /// Official endpoint: `POST /v2/SendPayment`.
  Future<MyFatoorahResult<SendPaymentResponse>> send(
    SendPaymentRequest request,
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

    return _client.request<SendPaymentResponse>(
      MyFatoorahRequest<SendPaymentResponse>(
        method: MyFatoorahHttpMethod.post,
        path: '/v2/SendPayment',
        body: request.toJson(),
        parser: (response) {
          final apiResponse =
              MyFatoorahApiResponse<SendPaymentResponse>.fromJson(
                MyFatoorahJson.asObject(response.data),
                (json) =>
                    SendPaymentResponse.fromJson(MyFatoorahJson.asObject(json)),
              );

          final data = apiResponse.data;
          if (!apiResponse.isSuccess || data == null) {
            throw MyFatoorahApiException(
              apiResponse.message ?? 'MyFatoorah SendPayment failed.',
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
