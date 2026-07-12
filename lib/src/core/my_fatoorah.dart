import 'package:flutter/foundation.dart' show visibleForTesting;

import '../checkout/my_fatoorah_checkout.dart';
import '../client/my_fatoorah_client.dart';
import '../client/my_fatoorah_http_client.dart';
import '../invoices/my_fatoorah_invoices.dart';
import '../payments/my_fatoorah_payments.dart';
import '../refunds/my_fatoorah_refunds.dart';
import 'my_fatoorah_config.dart';
import 'my_fatoorah_logger.dart';

/// Main entry point for the MyFatoorah SDK.
///
/// Create one SDK instance with [MyFatoorahConfig], then access payment APIs
/// through [payments], [invoices], and [refunds].
///
/// ```dart
/// final myFatoorah = MyFatoorah(config: config);
/// final result = await myFatoorah.payments.hosted.createPaymentUrl(request);
/// ```
///
/// Payment redirects should never be trusted as final payment state. Confirm
/// payments with `payments.status.get(paymentId)` or with a verified backend
/// webhook.
final class MyFatoorah {
  /// Creates a MyFatoorah SDK instance.
  ///
  /// [logger] can be supplied to integrate SDK diagnostics with an application
  /// logging system. If omitted, logging follows [MyFatoorahConfig.enableLogging].
  MyFatoorah({required this.config, MyFatoorahLogger? logger})
    : logger = logger ?? _loggerForConfig(config),
      _client = MyFatoorahClient(
        config: config,
        logger: logger ?? _loggerForConfig(config),
      );

  /// Creates a MyFatoorah SDK instance with internal test hooks.
  ///
  /// This constructor is for package tests and should not be used by SDK
  /// consumers.
  ///
  /// @nodoc
  @visibleForTesting
  MyFatoorah.internal({
    required this.config,
    MyFatoorahLogger? logger,
    Uri? baseUrl,
    MyFatoorahHttpClient? httpClient,
  }) : logger = logger ?? _loggerForConfig(config),
       _client = MyFatoorahClient(
         config: config,
         logger: logger ?? _loggerForConfig(config),
         baseUrl: baseUrl,
         httpClient: httpClient,
       );

  /// SDK configuration shared by all payment APIs.
  final MyFatoorahConfig config;

  /// Logger used by SDK internals.
  final MyFatoorahLogger logger;

  final MyFatoorahClient _client;

  /// Payment APIs grouped by integration area: `hosted`, `embedded`, and
  /// `status`.
  MyFatoorahPayments get payments => createMyFatoorahPayments(_client);

  /// High-level checkout APIs built on top of existing payment APIs.
  MyFatoorahCheckout get checkout => createMyFatoorahCheckout(_client);

  /// Invoice APIs.
  MyFatoorahInvoices get invoices => createMyFatoorahInvoices(_client);

  /// Refund APIs.
  MyFatoorahRefunds get refunds => createMyFatoorahRefunds(_client);

  static MyFatoorahLogger _loggerForConfig(MyFatoorahConfig config) {
    return config.enableLogging
        ? const MyFatoorahConsoleLogger()
        : const MyFatoorahNoopLogger();
  }
}
