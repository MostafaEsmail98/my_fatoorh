import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({super.key});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

final class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  final _paymentIdController = TextEditingController();
  var _loading = false;
  String? _error;
  GetPaymentDetailsResponse? _details;

  @override
  void dispose() {
    _paymentIdController.dispose();
    super.dispose();
  }

  Future<void> _getStatus() async {
    setState(() {
      _loading = true;
      _error = null;
      _details = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.payments.status.get(
        _paymentIdController.text,
      );

      if (!mounted) return;
      setState(() {
        switch (result) {
          case MyFatoorahSuccess(:final value):
            _details = value;
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
    final details = _details;
    return ExamplePage(
      children: [
        const Text('Confirm the real payment state with Get Payment Details.'),
        TextField(
          controller: _paymentIdController,
          decoration: const InputDecoration(labelText: 'Payment ID'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _getStatus,
          icon: const Icon(Icons.fact_check_outlined),
          label: Text(_loading ? 'Checking...' : 'Get status'),
        ),
        if (_error case final error?) ErrorText(error),
        if (details != null)
          ResultPanel(
            title: 'Payment details',
            children: [
              FieldRow(label: 'isPaid', value: details.isPaid),
              FieldRow(label: 'isPending', value: details.isPending),
              FieldRow(label: 'isFailed', value: details.isFailed),
              FieldRow(label: 'Invoice status', value: details.invoice.status),
              FieldRow(
                label: 'Transaction status',
                value: details.transaction.status,
              ),
              FieldRow(
                label: 'Display amount',
                value: details.amount.valueInDisplayCurrency,
              ),
              FieldRow(
                label: 'Display currency',
                value: details.amount.displayCurrency,
              ),
              FieldRow(
                label: 'Pay amount',
                value: details.amount.valueInPayCurrency,
              ),
              FieldRow(
                label: 'Pay currency',
                value: details.amount.payCurrency,
              ),
              FieldRow(label: 'Raw summary', value: details.toJson()),
            ],
          ),
      ],
    );
  }
}
