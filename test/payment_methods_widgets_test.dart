import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

void main() {
  testWidgets('renders payment methods and selected state', (tester) async {
    PaymentMethod? selectedMethod;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyFatoorahPaymentMethodsList(
            methods: _methods,
            selectedPaymentMethodId: 2,
            onSelected: (method) {
              selectedMethod = method;
            },
            style: const MyFatoorahPaymentMethodsStyle(showImages: false),
          ),
        ),
      ),
    );

    expect(find.text('VISA/MASTER'), findsOneWidget);
    expect(find.text('Apple Pay'), findsOneWidget);
    final selectedTile = tester.widget<MyFatoorahPaymentMethodTile>(
      find.byWidgetPredicate(
        (widget) =>
            widget is MyFatoorahPaymentMethodTile &&
            widget.method.paymentMethodId == 2,
      ),
    );
    expect(selectedTile.selected, isTrue);

    await tester.tap(find.text('Apple Pay'));
    expect(selectedMethod?.paymentMethodId, 11);
  });

  testWidgets('renders image when enabled and URL exists', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MyFatoorahPaymentMethodTile(
            method: _cardMethod,
            selected: false,
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('VISA/MASTER'), findsOneWidget);
  });

  testWidgets('hides images when style disables images', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MyFatoorahPaymentMethodsList(
            methods: _methods,
            style: MyFatoorahPaymentMethodsStyle(showImages: false),
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsNothing);
    expect(find.text('VISA/MASTER'), findsOneWidget);
    expect(find.text('Apple Pay'), findsOneWidget);
  });

  testWidgets('supports horizontal scrolling', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 72,
            child: MyFatoorahPaymentMethodsList(
              methods: _methods,
              scrollDirection: Axis.horizontal,
              style: MyFatoorahPaymentMethodsStyle(showImages: false),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.widget<ListView>(find.byType(ListView)).scrollDirection,
      Axis.horizontal,
    );
    expect(find.text('VISA/MASTER'), findsOneWidget);
  });
}

const _cardMethod = PaymentMethod(
  paymentMethodId: 2,
  paymentMethodAr: 'فيزا / ماستر',
  paymentMethodEn: 'VISA/MASTER',
  paymentMethodCode: 'vm',
  isDirectPayment: false,
  serviceCharge: '0.2',
  totalAmount: '100',
  currencyIso: 'KWD',
  imageUrl: 'https://demo.myfatoorah.com/imgs/payment-methods/vm.png',
  isEmbeddedSupported: true,
  paymentCurrencyIso: 'KWD',
);

const _applePayMethod = PaymentMethod(
  paymentMethodId: 11,
  paymentMethodAr: 'أبل الدفع',
  paymentMethodEn: 'Apple Pay',
  paymentMethodCode: 'ap',
  isDirectPayment: false,
  serviceCharge: '2',
  totalAmount: '100',
  currencyIso: 'KWD',
  imageUrl: 'https://demo.myfatoorah.com/imgs/payment-methods/ap.png',
  isEmbeddedSupported: true,
  paymentCurrencyIso: 'QAR',
);

const _methods = [_cardMethod, _applePayMethod];
