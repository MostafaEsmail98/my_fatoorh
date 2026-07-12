import 'package:flutter/foundation.dart';

import '../../core/my_fatoorah_environment.dart';
import 'my_fatoorah_embedded_web_interop.dart';
import 'my_fatoorah_embedded_web_script_loader.dart';
import 'my_fatoorah_embedded_web_script_url.dart';

/// Coordinates MyFatoorah Embedded Payment Web script loading and init.
final class MyFatoorahEmbeddedWebController {
  /// Creates an Embedded Payment Web controller.
  const MyFatoorahEmbeddedWebController({
    this.scriptLoader = const MyFatoorahEmbeddedWebScriptLoader(),
    this.initializeInterop = initializeMyFatoorahEmbeddedWeb,
  });

  /// Script loader used by this controller.
  final MyFatoorahEmbeddedWebScriptLoader scriptLoader;

  /// Low-level JS initializer used by this controller.
  final MyFatoorahEmbeddedWebInitialize initializeInterop;

  /// Loads the official script and initializes MyFatoorah JS.
  ///
  /// The JavaScript callback is not final payment proof. Apps must confirm the
  /// payment using backend ExecutePayment/Get Payment Details or a verified
  /// backend webhook before marking an order paid.
  Future<void> initialize({
    required MyFatoorahEnvironment environment,
    required MyFatoorahEmbeddedWebConfig config,
    required ValueChanged<Map<String, dynamic>> onCallback,
    required ValueChanged<Object> onError,
  }) async {
    try {
      final scriptUrl = myFatoorahEmbeddedWebScriptUrl(
        environment: environment,
        countryCode: config.countryCode,
      );
      await scriptLoader.load(scriptUrl);
      initializeInterop(config: config, onCallback: onCallback);
    } on Object catch (error) {
      onError(error);
    }
  }
}

/// Low-level MyFatoorah Embedded JS initializer.
typedef MyFatoorahEmbeddedWebInitialize =
    void Function({
      required MyFatoorahEmbeddedWebConfig config,
      required ValueChanged<Map<String, dynamic>> onCallback,
    });
