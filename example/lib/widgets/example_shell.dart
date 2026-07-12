import 'package:flutter/material.dart';

import '../screens/callback_parser_screen.dart';
import '../screens/embedded_web_screen.dart';
import '../screens/hosted_payment_screen.dart';
import '../screens/invoice_screen.dart';
import '../screens/payment_methods_screen.dart';
import '../screens/payment_status_screen.dart';
import '../screens/refund_screen.dart';
import '../screens/setup_screen.dart';

final class ExampleShell extends StatelessWidget {
  const ExampleShell({super.key});

  static const _tabs = [
    Tab(icon: Icon(Icons.settings_outlined), text: 'Configuration'),
    Tab(icon: Icon(Icons.credit_card), text: 'Payment Methods'),
    Tab(icon: Icon(Icons.link), text: 'Hosted Payment'),
    Tab(icon: Icon(Icons.fact_check_outlined), text: 'Payment Status'),
    Tab(icon: Icon(Icons.route_outlined), text: 'Callback Parser'),
    Tab(icon: Icon(Icons.web_asset), text: 'Embedded Web'),
    Tab(icon: Icon(Icons.receipt_long), text: 'Invoice'),
    Tab(icon: Icon(Icons.undo), text: 'Refund'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MyFatoorah SDK Example'),
          bottom: const TabBar(isScrollable: true, tabs: _tabs),
        ),
        body: const TabBarView(
          children: [
            SetupScreen(),
            PaymentMethodsScreen(),
            HostedPaymentScreen(),
            PaymentStatusScreen(),
            CallbackParserScreen(),
            EmbeddedWebScreen(),
            InvoiceScreen(),
            RefundScreen(),
          ],
        ),
      ),
    );
  }
}
