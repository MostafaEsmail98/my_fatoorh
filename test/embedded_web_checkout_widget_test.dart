import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

void main() {
  testWidgets('shows clear non-web fallback', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MyFatoorahEmbeddedWebCheckout(
          sessionId: 'KWT-123',
          countryCode: 'KWT',
          currencyCode: 'KWD',
          amount: '10.000',
          onCallback: (_) {},
          onError: (_) {},
        ),
      ),
    );

    expect(
      find.text('Embedded Web checkout is only available on Flutter Web.'),
      findsOneWidget,
    );
  }, skip: kIsWeb);
}
