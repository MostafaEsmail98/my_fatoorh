import 'my_fatoorah_country.dart';
import 'my_fatoorah_environment.dart';
import 'my_fatoorah_language.dart';
import 'my_fatoorah_transport_mode.dart';

/// Immutable configuration for the MyFatoorah SDK.
///
/// The Flutter package sends payment API requests to your backend only. Your
/// backend owns the MyFatoorah API key and forwards validated requests to
/// MyFatoorah.
final class MyFatoorahConfig {
  /// Creates backend-only configuration for the SDK.
  const MyFatoorahConfig({
    required this.backendBaseUrl,
    required this.environment,
    required this.country,
    this.language = MyFatoorahLanguage.english,
    this.timeout = const Duration(seconds: 30),
    this.enableLogging = false,
  });

  /// Creates configuration for merchant backend integrations.
  const MyFatoorahConfig.backendProxy({
    required Uri backendBaseUrl,
    MyFatoorahEnvironment environment = MyFatoorahEnvironment.test,
    MyFatoorahCountry country = const MyFatoorahCountry('KWT'),
    MyFatoorahLanguage language = MyFatoorahLanguage.english,
    Duration timeout = const Duration(seconds: 30),
    bool enableLogging = false,
  }) : this(
         environment: environment,
         country: country,
         backendBaseUrl: backendBaseUrl,
         language: language,
         timeout: timeout,
         enableLogging: enableLogging,
       );

  /// HTTP transport mode.
  MyFatoorahTransportMode get transportMode =>
      MyFatoorahTransportMode.backendProxy;

  /// Merchant backend base URL.
  ///
  /// The SDK resolves supported payment endpoint paths against this URL. Your
  /// backend should store the MyFatoorah API key, validate requests, forward to
  /// MyFatoorah, and return the same response envelope.
  final Uri backendBaseUrl;

  /// MyFatoorah target environment.
  final MyFatoorahEnvironment environment;

  /// Merchant/customer country context.
  final MyFatoorahCountry country;

  /// Preferred response or checkout language where supported.
  final MyFatoorahLanguage language;

  /// Network timeout for API calls.
  final Duration timeout;

  /// Enables SDK diagnostic logging.
  final bool enableLogging;
}
