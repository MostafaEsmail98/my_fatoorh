import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class HostedPaymentScreen extends StatefulWidget {
  const HostedPaymentScreen({super.key});

  @override
  State<HostedPaymentScreen> createState() => _HostedPaymentScreenState();
}

final class _HostedPaymentScreenState extends State<HostedPaymentScreen> {
  final _amountController = TextEditingController(text: '10.000');
  final _redirectController = TextEditingController(
    text: 'https://example.com/payment/callback',
  );
  var _loading = false;
  String? _error;
  HostedPaymentFlowResult? _flow;

  @override
  void dispose() {
    _amountController.dispose();
    _redirectController.dispose();
    super.dispose();
  }

  Future<void> _createPaymentUrl() async {
    setState(() {
      _loading = true;
      _error = null;
      _flow = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.payments.hosted.createPaymentUrl(
        CreateHostedPaymentRequest(
          paymentMethod: 'CARD',
          order: HostedPaymentOrder(amount: _amountController.text),
          integrationUrls: HostedPaymentIntegrationUrls(
            redirection: _redirectController.text,
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        switch (result) {
          case MyFatoorahSuccess(:final value):
            _flow = value;
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

  Future<void> _copyPaymentUrl() async {
    final url = _flow?.paymentUrl;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Payment URL copied.')));
  }

  Future<void> _openPaymentUrl() async {
    final url = _flow?.paymentUrl;
    if (url == null) {
      return;
    }
    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.payments.hosted.openPaymentUrl(url);
      if (!mounted) return;
      switch (result) {
        case MyFatoorahSuccess<void>():
          break;
        case MyFatoorahFailure<void>(:final exception):
          setState(
            () => _error = '${exception.runtimeType}: ${exception.message}',
          );
      }
    } on Object catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      children: [
        const InfoBox(
          message:
              'This creates a hosted payment URL only. Open the URL in your app, then confirm the final status using Get Payment Details or your backend webhook.',
        ),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        TextField(
          controller: _redirectController,
          decoration: const InputDecoration(labelText: 'Redirect URL'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _createPaymentUrl,
          icon: const Icon(Icons.link),
          label: Text(_loading ? 'Creating...' : 'Create payment URL'),
        ),
        if (_error case final error?) ErrorText(error),
        if (_flow case final flow?)
          ResultPanel(
            title: 'Hosted payment result',
            children: [
              FieldRow(label: 'Payment ID', value: flow.paymentId),
              FieldRow(label: 'Invoice ID', value: flow.invoiceId),
              FieldRow(label: 'Payment URL', value: flow.paymentUrl),
              Wrap(
                spacing: 12,
                children: [
                  OutlinedButton.icon(
                    onPressed: _copyPaymentUrl,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy URL'),
                  ),
                  FilledButton.icon(
                    onPressed: _openPaymentUrl,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open URL'),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
