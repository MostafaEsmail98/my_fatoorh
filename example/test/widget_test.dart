import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah_example/main.dart';

void main() {
  testWidgets('renders SDK example sections', (tester) async {
    await tester.pumpWidget(const MyFatoorahExampleApp());

    expect(find.text('MyFatoorah SDK Example'), findsOneWidget);
    expect(find.text('Configuration'), findsOneWidget);
    expect(find.text('Hosted Payment'), findsOneWidget);
    expect(find.text('Payment Status'), findsOneWidget);
  });
}
