import '../client/my_fatoorah_client.dart';
import '../core/my_fatoorah_result.dart';
import 'models/make_refund_request.dart';
import 'models/make_refund_response.dart';
import 'refund_client.dart';

/// Creates the public refunds facade from an internal API client.
///
/// This helper is intentionally not exported from the public SDK barrel.
MyFatoorahRefunds createMyFatoorahRefunds(MyFatoorahClient client) {
  return MyFatoorahRefunds._(RefundClient(client));
}

/// Public facade for MyFatoorah refund APIs.
///
/// Access this from `myFatoorah.refunds`.
final class MyFatoorahRefunds {
  /// Creates the refunds facade.
  const MyFatoorahRefunds._(this._client);

  final RefundClient _client;

  /// Creates a refund request.
  ///
  /// Creating a refund request is not final proof that the funds have been
  /// returned. Confirm refund state from your backend, portal, or webhook.
  Future<MyFatoorahResult<MakeRefundResponse>> make(MakeRefundRequest request) {
    return _client.make(request);
  }
}
