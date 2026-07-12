import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class CallbackParserScreen extends StatefulWidget {
  const CallbackParserScreen({super.key});

  @override
  State<CallbackParserScreen> createState() => _CallbackParserScreenState();
}

final class _CallbackParserScreenState extends State<CallbackParserScreen> {
  final _callbackController = TextEditingController();
  var _loading = false;
  String? _error;
  MyFatoorahCallbackResult? _parsed;
  GetPaymentDetailsResponse? _confirmed;

  @override
  void dispose() {
    _callbackController.dispose();
    super.dispose();
  }

  void _parse() {
    setState(() {
      _error = null;
      _parsed = null;
      _confirmed = null;
    });

    try {
      final parsed = MyFatoorahCallbackParser.parseString(
        _callbackController.text,
      );
      setState(() => _parsed = parsed);
    } on Object catch (error) {
      setState(() => _error = error.toString());
    }
  }

  Future<void> _confirmFromCallback() async {
    setState(() {
      _loading = true;
      _error = null;
      _confirmed = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.payments.hosted.confirmFromCallback(
        _callbackController.text,
      );

      if (!mounted) return;
      setState(() {
        switch (result) {
          case MyFatoorahSuccess(:final value):
            _confirmed = value;
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
    return ExamplePage(
      children: [
        const InfoBox(
          message:
              'Redirect parameters are only identifiers. Do not mark an order paid from this screen unless Get Payment Details or your backend confirms it.',
        ),
        TextField(
          controller: _callbackController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Callback URL'),
        ),
        Wrap(
          spacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: _parse,
              icon: const Icon(Icons.route_outlined),
              label: const Text('Parse callback'),
            ),
            FilledButton.icon(
              onPressed: _loading ? null : _confirmFromCallback,
              icon: const Icon(Icons.verified_outlined),
              label: Text(_loading ? 'Confirming...' : 'Confirm from callback'),
            ),
          ],
        ),
        if (_error case final error?) ErrorText(error),
        if (_parsed case final parsed?)
          ResultPanel(
            title: 'Parsed callback',
            children: [
              FieldRow(label: 'Payment ID', value: parsed.paymentId),
              FieldRow(label: 'Invoice ID', value: parsed.invoiceId),
              FieldRow(label: 'Track ID', value: parsed.trackId),
              FieldRow(label: 'Status', value: parsed.status),
              FieldRow(label: 'Has payment ID', value: parsed.hasPaymentId),
            ],
          ),
        if (_confirmed case final confirmed?)
          ResultPanel(
            title: 'Confirmed payment details',
            children: [
              FieldRow(label: 'isPaid', value: confirmed.isPaid),
              FieldRow(label: 'isPending', value: confirmed.isPending),
              FieldRow(label: 'isFailed', value: confirmed.isFailed),
              FieldRow(
                label: 'Invoice status',
                value: confirmed.invoice.status,
              ),
              FieldRow(
                label: 'Transaction status',
                value: confirmed.transaction.status,
              ),
            ],
          ),
      ],
    );
  }
}
