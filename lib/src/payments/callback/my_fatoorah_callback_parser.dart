import 'my_fatoorah_callback_result.dart';

/// Parses MyFatoorah redirect/callback URLs.
///
/// Redirects are useful for extracting `paymentId`, but they are not a final
/// payment decision. Always call `myFatoorah.payments.status.get(paymentId)`
/// after redirect to confirm the actual status with MyFatoorah, or read the
/// final state from a backend updated by verified webhooks.
final class MyFatoorahCallbackParser {
  const MyFatoorahCallbackParser._();

  /// Parses a callback URL string.
  ///
  /// This method never marks a payment as paid. It only extracts identifiers
  /// that can be used for status lookup.
  static MyFatoorahCallbackResult parseString(String url) {
    return parseUri(Uri.parse(url));
  }

  /// Parses a callback URI.
  ///
  /// This method never marks a payment as paid. It only extracts identifiers
  /// that can be used for status lookup.
  static MyFatoorahCallbackResult parseUri(Uri uri) {
    final query = _caseInsensitiveQuery(uri);

    return MyFatoorahCallbackResult(
      uri: uri,
      paymentId: _firstNonEmpty(query, const ['paymentid', 'id']),
      invoiceId: _firstNonEmpty(query, const ['invoiceid']),
      trackId: _firstNonEmpty(query, const ['trackid']),
      status: _firstNonEmpty(query, const ['status']),
    );
  }

  static Map<String, String> _caseInsensitiveQuery(Uri uri) {
    final values = <String, String>{};
    for (final entry in uri.queryParameters.entries) {
      values.putIfAbsent(entry.key.toLowerCase(), () => entry.value);
    }
    return values;
  }

  static String? _firstNonEmpty(Map<String, String> query, List<String> keys) {
    for (final key in keys) {
      final value = query[key];
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
