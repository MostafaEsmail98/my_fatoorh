import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class EmbeddedWebScreen extends StatefulWidget {
  const EmbeddedWebScreen({super.key});

  @override
  State<EmbeddedWebScreen> createState() => _EmbeddedWebScreenState();
}

final class _EmbeddedWebScreenState extends State<EmbeddedWebScreen> {
  final _amountController = TextEditingController(text: '10.000');
  var _loading = false;
  String? _error;
  InitiateSessionResponse? _session;
  Map<String, dynamic>? _jsCallback;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _initiateSession() async {
    setState(() {
      _loading = true;
      _error = null;
      _session = null;
      _jsCallback = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.payments.embedded.initiateSession(
        InitiateSessionRequest(
          paymentMode: EmbeddedPaymentMode.completePayment,
          order: InitiateSessionOrder(amount: _amountController.text),
        ),
      );

      if (!mounted) return;
      setState(() {
        switch (result) {
          case MyFatoorahSuccess(:final value):
            _session = value;
          case MyFatoorahFailure(:final exception):
            _error = '${exception.runtimeType}: ${exception.message}';
        }
      });
    } on Object catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ExampleScope.of(context);
    final session = _session;
    return ExamplePage(
      children: [
        const InfoBox(
          message:
              'The embedded widget renders the Web form only. A JS callback is not final payment proof; confirm using your backend webhook or Get Payment Details.',
        ),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _initiateSession,
          icon: const Icon(Icons.web_asset),
          label: Text(_loading ? 'Initiating...' : 'Initiate session'),
        ),
        if (_error case final error?) ErrorText(error),
        if (session != null)
          ResultPanel(
            title: 'Embedded session',
            children: [
              FieldRow(label: 'Session ID', value: session.sessionId),
              FieldRow(label: 'Expiry', value: session.sessionExpiry),
              FieldRow(label: 'Operation type', value: session.operationType),
            ],
          ),
        if (session != null && kIsWeb)
          MyFatoorahEmbeddedWebCheckout(
            sessionId: session.sessionId,
            countryCode: appState.country.code,
            currencyCode: 'KWD',
            amount: _amountController.text,
            environment: appState.environment,
            onCallback: (data) => setState(() => _jsCallback = data),
            onError: (error) => setState(() => _error = error.toString()),
          ),
        if (session != null && !kIsWeb)
          const InfoBox(
            message: 'Embedded Web checkout is only available on Flutter Web.',
          ),
        if (_jsCallback case final callback?)
          ResultPanel(
            title: 'Raw JS callback',
            children: [FieldRow(label: 'Callback', value: callback)],
          ),
      ],
    );
  }
}
