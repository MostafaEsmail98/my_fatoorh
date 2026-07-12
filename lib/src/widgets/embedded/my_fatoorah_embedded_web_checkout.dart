import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/my_fatoorah_environment.dart';
import '../../web/embedded/my_fatoorah_embedded_web_controller.dart';
import '../../web/embedded/my_fatoorah_embedded_web_interop.dart';
import 'my_fatoorah_embedded_web_registry.dart';
import 'my_fatoorah_embedded_web_style.dart';

/// Optional Flutter Web container for MyFatoorah Embedded Payment.
///
/// This widget only provides the Flutter Web host container foundation. Apps
/// must create a session using `myFatoorah.payments.embedded.initiateSession`
/// before rendering this widget.
///
/// MyFatoorah JavaScript callbacks are not final payment proof. Always confirm
/// payment with Get Payment Details or a verified backend webhook before
/// marking an order paid.
final class MyFatoorahEmbeddedWebCheckout extends StatefulWidget {
  /// Creates an Embedded Web checkout container.
  const MyFatoorahEmbeddedWebCheckout({
    required this.sessionId,
    required this.countryCode,
    required this.currencyCode,
    required this.amount,
    required this.onCallback,
    required this.onError,
    this.containerId,
    this.environment = MyFatoorahEnvironment.test,
    this.controller = const MyFatoorahEmbeddedWebController(),
    this.style = const MyFatoorahEmbeddedWebStyle(),
    super.key,
  });

  /// Session ID returned by `POST /v3/sessions`.
  ///
  /// A MyFatoorah SessionId is valid for one payment only.
  final String sessionId;

  /// MyFatoorah country code selected by the app.
  final String countryCode;

  /// Currency code selected by the app.
  final String currencyCode;

  /// Amount associated with this embedded checkout session.
  final String amount;

  /// Optional HTML container id passed to MyFatoorah JS.
  final String? containerId;

  /// MyFatoorah environment used to select the official Embedded JS script.
  final MyFatoorahEnvironment environment;

  /// Controller that loads the official script and initializes MyFatoorah JS.
  final MyFatoorahEmbeddedWebController controller;

  /// Receives raw MyFatoorah JS callback data.
  ///
  /// The callback alone is not final payment proof. Confirm on your backend or
  /// with Get Payment Details before updating order state.
  final ValueChanged<Map<String, dynamic>> onCallback;

  /// Receives widget or future JS initialization errors.
  final ValueChanged<Object> onError;

  /// Visual text and sizing options.
  final MyFatoorahEmbeddedWebStyle style;

  @override
  State<MyFatoorahEmbeddedWebCheckout> createState() =>
      _MyFatoorahEmbeddedWebCheckoutState();
}

final class _MyFatoorahEmbeddedWebCheckoutState
    extends State<MyFatoorahEmbeddedWebCheckout> {
  static int _nextViewId = 0;

  late final String _containerId;
  late final String _viewType;
  Object? _registrationError;
  Object? _initializationError;

  @override
  void initState() {
    super.initState();

    final viewId = _nextViewId++;
    _containerId =
        widget.containerId ?? 'my-fatoorah-embedded-checkout-$viewId';
    _viewType = 'my_fatoorah_embedded_web_checkout_$viewId';

    if (kIsWeb) {
      _registerWebContainer();
    }
  }

  void _registerWebContainer() {
    try {
      registerMyFatoorahEmbeddedWebContainer(
        viewType: _viewType,
        containerId: _containerId,
        height: widget.style.height,
        loadingText: widget.style.loadingText,
      );

      unawaited(_initializeCheckout());
    } on Object catch (error) {
      _registrationError = error;
      widget.onError(error);
    }
  }

  Future<void> _initializeCheckout() {
    return widget.controller.initialize(
      environment: widget.environment,
      config: MyFatoorahEmbeddedWebConfig(
        sessionId: widget.sessionId,
        countryCode: widget.countryCode,
        currencyCode: widget.currencyCode,
        amount: widget.amount,
        containerId: _containerId,
      ),
      onCallback: widget.onCallback,
      onError: (error) {
        if (mounted) {
          setState(() {
            _initializationError = error;
          });
        } else {
          _initializationError = error;
        }
        widget.onError(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return _UnsupportedEmbeddedWebCheckout(style: widget.style);
    }

    final error = _registrationError;
    if (error != null) {
      return _EmbeddedWebError(error: error, style: widget.style);
    }

    final initializationError = _initializationError;
    if (initializationError != null) {
      return _EmbeddedWebError(error: initializationError, style: widget.style);
    }

    return SizedBox(
      height: widget.style.height,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

final class _UnsupportedEmbeddedWebCheckout extends StatelessWidget {
  const _UnsupportedEmbeddedWebCheckout({required this.style});

  final MyFatoorahEmbeddedWebStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.padding,
      child: Text(style.unsupportedText, textAlign: TextAlign.center),
    );
  }
}

final class _EmbeddedWebError extends StatelessWidget {
  const _EmbeddedWebError({required this.error, required this.style});

  final Object error;
  final MyFatoorahEmbeddedWebStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.padding,
      child: Text(error.toString(), textAlign: TextAlign.center),
    );
  }
}
