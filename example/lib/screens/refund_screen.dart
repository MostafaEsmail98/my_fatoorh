import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

enum _RefundLookupType { invoiceId, paymentId }

final class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

final class _RefundScreenState extends State<RefundScreen> {
  final _keyController = TextEditingController();
  final _amountController = TextEditingController(text: '1.000');
  var _lookupType = _RefundLookupType.invoiceId;
  var _loading = false;
  String? _error;
  MakeRefundResponse? _response;

  @override
  void dispose() {
    _keyController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _makeRefund() async {
    setState(() {
      _loading = true;
      _error = null;
      _response = null;
    });

    try {
      final client = ExampleScope.of(context).createClient();
      final request = switch (_lookupType) {
        _RefundLookupType.invoiceId => MakeRefundRequest.invoiceId(
          invoiceId: _keyController.text,
          amount: _amountController.text,
          comment: 'Example app refund',
        ),
        _RefundLookupType.paymentId => MakeRefundRequest.paymentId(
          paymentId: _keyController.text,
          amount: _amountController.text,
          comment: 'Example app refund',
        ),
      };
      final result = await client.refunds.make(request);

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
        const InfoBox(
          icon: Icons.admin_panel_settings_outlined,
          message:
              'Refunds should normally run from a backend/admin context, not a public customer app.',
        ),
        SegmentedButton<_RefundLookupType>(
          segments: const [
            ButtonSegment(
              value: _RefundLookupType.invoiceId,
              label: Text('Invoice ID'),
            ),
            ButtonSegment(
              value: _RefundLookupType.paymentId,
              label: Text('Payment ID'),
            ),
          ],
          selected: {_lookupType},
          onSelectionChanged: (selection) {
            setState(() => _lookupType = selection.single);
          },
        ),
        TextField(
          controller: _keyController,
          decoration: InputDecoration(
            labelText: _lookupType == _RefundLookupType.invoiceId
                ? 'Invoice ID'
                : 'Payment ID',
          ),
        ),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Refund amount'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _makeRefund,
          icon: const Icon(Icons.undo),
          label: Text(_loading ? 'Refunding...' : 'Make refund'),
        ),
        if (_error case final error?) ErrorText(error),
        if (_response case final response?)
          ResultPanel(
            title: 'Refund result',
            children: [
              FieldRow(label: 'Key', value: response.key),
              FieldRow(label: 'Refund ID', value: response.refundId),
              FieldRow(
                label: 'Refund reference',
                value: response.refundReference,
              ),
              FieldRow(
                label: 'Refund invoice ID',
                value: response.refundInvoiceId,
              ),
              FieldRow(label: 'Amount', value: response.amount),
              FieldRow(label: 'Comment', value: response.comment),
            ],
          ),
      ],
    );
  }
}
