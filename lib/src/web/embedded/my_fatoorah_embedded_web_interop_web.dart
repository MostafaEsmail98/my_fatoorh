import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Configuration passed to MyFatoorah Embedded Payment JavaScript.
final class MyFatoorahEmbeddedWebConfig {
  /// Creates Embedded Payment JavaScript configuration.
  const MyFatoorahEmbeddedWebConfig({
    required this.sessionId,
    required this.countryCode,
    required this.currencyCode,
    required this.amount,
    required this.containerId,
  });

  /// Session ID returned by `POST /v3/sessions`.
  final String sessionId;

  /// MyFatoorah country code returned by Initiate Session.
  final String countryCode;

  /// Payment currency code.
  final String currencyCode;

  /// Amount displayed by supported wallet methods.
  final String amount;

  /// HTML container ID used by MyFatoorah JS.
  final String containerId;

  /// Serializes the documented configuration fields.
  Map<String, Object?> toJson() {
    return {
      'sessionId': sessionId,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
      'amount': amount,
      'containerId': containerId,
    };
  }
}

/// Initializes MyFatoorah Embedded Payment JavaScript.
void initializeMyFatoorahEmbeddedWeb({
  required MyFatoorahEmbeddedWebConfig config,
  required void Function(Map<String, dynamic> data) onCallback,
}) {
  final myFatoorah = globalContext['myfatoorah'] as JSObject?;
  if (myFatoorah == null) {
    throw StateError(
      'MyFatoorah Embedded script loaded, but global myfatoorah was not found.',
    );
  }

  final jsConfig =
      {
            ...config.toJson(),
            'callback': ((JSAny? response) {
              onCallback(_toStringDynamicMap(response?.dartify()));
            }).toJS,
          }.jsify()
          as JSObject;

  myFatoorah.callMethod<JSAny?>('init'.toJS, jsConfig);
}

Map<String, dynamic> _toStringDynamicMap(Object? value) {
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return {'value': value};
}
