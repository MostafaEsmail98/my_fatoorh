import '../client/my_fatoorah_client.dart';
import '../core/my_fatoorah_result.dart';
import '../exceptions/my_fatoorah_validation_exception.dart';
import 'callback/my_fatoorah_callback_parser.dart';
import 'embedded/embedded_payment_client.dart';
import 'embedded/models/initiate_session_request.dart';
import 'embedded/models/initiate_session_response.dart';
import 'hosted/hosted_payment_client.dart';
import 'hosted/hosted_payment_launcher.dart';
import 'hosted/models/create_hosted_payment_request.dart';
import 'hosted/models/create_hosted_payment_response.dart';
import 'hosted/models/hosted_payment_flow_result.dart';
import 'methods/models/initiate_payment_request.dart';
import 'methods/models/initiate_payment_response.dart';
import 'methods/payment_methods_client.dart';
import 'status/models/get_payment_details_response.dart';
import 'status/payment_status_client.dart';

part 'embedded/my_fatoorah_embedded_payments.dart';
part 'hosted/my_fatoorah_hosted_payments.dart';
part 'methods/my_fatoorah_payment_methods.dart';
part 'status/my_fatoorah_payment_status.dart';

/// Creates the public payments facade from an internal API client.
///
/// This helper is intentionally not exported from the public SDK barrel.
MyFatoorahPayments createMyFatoorahPayments(MyFatoorahClient client) {
  return MyFatoorahPayments._(client);
}

/// Public facade grouping MyFatoorah payment APIs.
///
/// Access this from [MyFatoorah.payments]. It exposes:
///
/// * [hosted] for Hosted Payment Page.
/// * [embedded] for Embedded Payment sessions.
/// * [methods] for available Payment Methods.
/// * [status] for Get Payment Details.
final class MyFatoorahPayments {
  /// Creates the payments facade.
  const MyFatoorahPayments._(this._client);

  final MyFatoorahClient _client;

  /// Hosted Payment Page APIs.
  MyFatoorahHostedPayments get hosted {
    return MyFatoorahHostedPayments._(
      HostedPaymentClient(_client),
      PaymentStatusClient(_client),
      const HostedPaymentLauncher(),
    );
  }

  /// Payment status APIs.
  MyFatoorahPaymentStatus get status {
    return MyFatoorahPaymentStatus._(PaymentStatusClient(_client));
  }

  /// Payment Methods APIs.
  MyFatoorahPaymentMethods get methods {
    return MyFatoorahPaymentMethods._(PaymentMethodsClient(_client));
  }

  /// Embedded Payment APIs.
  MyFatoorahEmbeddedPayments get embedded {
    return MyFatoorahEmbeddedPayments._(EmbeddedPaymentClient(_client));
  }
}
