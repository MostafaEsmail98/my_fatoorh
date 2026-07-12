import '../client/my_fatoorah_client.dart';
import '../core/my_fatoorah_result.dart';
import 'invoice_client.dart';
import 'models/send_payment_request.dart';
import 'models/send_payment_response.dart';

/// Creates the public invoices facade from an internal API client.
///
/// This helper is intentionally not exported from the public SDK barrel.
MyFatoorahInvoices createMyFatoorahInvoices(MyFatoorahClient client) {
  return MyFatoorahInvoices._(InvoiceClient(client));
}

/// Public facade for MyFatoorah invoice APIs.
///
/// Access this from `myFatoorah.invoices`.
final class MyFatoorahInvoices {
  /// Creates the invoices facade.
  const MyFatoorahInvoices._(this._client);

  final InvoiceClient _client;

  /// Creates and sends a MyFatoorah invoice/payment link.
  Future<MyFatoorahResult<SendPaymentResponse>> send(
    SendPaymentRequest request,
  ) {
    return _client.send(request);
  }
}
