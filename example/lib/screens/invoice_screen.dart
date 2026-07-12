import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

final class _InvoiceScreenState extends State<InvoiceScreen> {
  final _amountController = TextEditingController(text: '10.000');
  final _nameController = TextEditingController(text: 'Test Customer');
  final _emailController = TextEditingController(text: 'customer@example.com');
  final _mobileController = TextEditingController();
  var _loading = false;
  String? _error;
  SendPaymentResponse? _response;

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _sendPayment() async {
    setState(() {
      _loading = true;
      _error = null;
      _response = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.invoices.send(
        SendPaymentRequest(
          invoiceValue: _amountController.text,
          customer: InvoiceCustomer(
            name: _nameController.text,
            email: _emailController.text,
            mobileCountryCode: _mobileController.text.trim().isEmpty
                ? null
                : '+965',
            mobile: _mobileController.text.trim().isEmpty
                ? null
                : _mobileController.text,
          ),
          notificationOption: SendPaymentNotificationOption.email,
          displayCurrencyIso: 'KWD',
        ),
      );

      if (!mounted) return;
      setState(() {
        switch (result) {
          case MyFatoorahSuccess(:final value):
            _response = value;
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
        const Text('Send a MyFatoorah invoice/payment link.'),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Customer name'),
        ),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Customer email'),
        ),
        TextField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Customer mobile',
            helperText: 'Optional in this email-link example.',
          ),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _sendPayment,
          icon: const Icon(Icons.send_outlined),
          label: Text(_loading ? 'Sending...' : 'Send payment'),
        ),
        if (_error case final error?) ErrorText(error),
        if (_response case final response?)
          ResultPanel(
            title: 'Invoice result',
            children: [
              FieldRow(label: 'Invoice ID', value: response.invoiceId),
              FieldRow(label: 'Invoice URL', value: response.invoiceUrl),
              FieldRow(
                label: 'Customer reference',
                value: response.customerReference,
              ),
              FieldRow(
                label: 'User-defined field',
                value: response.userDefinedField,
              ),
            ],
          ),
      ],
    );
  }
}
