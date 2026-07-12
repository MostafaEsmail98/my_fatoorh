import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

final class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _amountController = TextEditingController(text: '10.000');
  final _currencyController = TextEditingController(text: 'KWD');
  var _loading = false;
  String? _error;
  List<PaymentMethod> _methods = const [];
  PaymentMethod? _selected;

  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  Future<void> _fetchMethods() async {
    setState(() {
      _loading = true;
      _error = null;
      _methods = const [];
      _selected = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final result = await client.payments.methods.get(
        InitiatePaymentRequest(
          invoiceAmount: _amountController.text,
          currencyIso: _currencyController.text.trim().toUpperCase(),
        ),
      );

      if (!mounted) return;
      setState(() {
        switch (result) {
          case MyFatoorahSuccess(:final value):
            _methods = value.paymentMethods;
            _selected = _methods.isEmpty ? null : _methods.first;
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
        const Text('Fetch available payment methods for an amount/currency.'),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        TextField(
          controller: _currencyController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(labelText: 'Currency ISO'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _fetchMethods,
          icon: const Icon(Icons.refresh),
          label: Text(_loading ? 'Fetching...' : 'Fetch payment methods'),
        ),
        if (_error case final error?) ErrorText(error),
        if (_methods.isNotEmpty)
          SizedBox(
            height: 260,
            child: MyFatoorahPaymentMethodsList(
              methods: _methods,
              selectedPaymentMethodId: _selected?.paymentMethodId,
              onSelected: (method) => setState(() => _selected = method),
            ),
          ),
        if (_selected case final method?)
          ResultPanel(
            title: 'Selected method',
            children: [
              FieldRow(label: 'ID', value: method.paymentMethodId),
              FieldRow(label: 'Name', value: method.paymentMethodEn),
              FieldRow(label: 'Code', value: method.paymentMethodCode),
              FieldRow(label: 'Currency', value: method.currencyIso),
              FieldRow(
                label: 'Gateway currency',
                value: method.paymentCurrencyIso,
              ),
              FieldRow(label: 'Service charge', value: method.serviceCharge),
              FieldRow(label: 'Total amount', value: method.totalAmount),
              FieldRow(label: 'Card', value: method.isCard),
              FieldRow(label: 'Apple Pay', value: method.isApplePay),
              FieldRow(label: 'Google Pay', value: method.isGooglePay),
            ],
          ),
      ],
    );
  }
}
