import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

void main() {
  test('parses success callback with paymentId', () {
    final result = MyFatoorahCallbackParser.parseString(
      'https://your-website.com/payment-callback?paymentId=100201923790872553',
    );

    expect(result.paymentId, '100201923790872553');
    expect(result.hasPaymentId, isTrue);
    expect(result.idForStatusLookup, '100201923790872553');
    expect(result.invoiceId, isNull);
    expect(result.trackId, isNull);
    expect(result.status, isNull);
  });

  test('parses error callback without assuming final payment status', () {
    final result = MyFatoorahCallbackParser.parseUri(
      Uri.parse(
        'https://your-website.com/payment-error'
        '?paymentId=07076389662322472373&status=failed',
      ),
    );

    expect(result.paymentId, '07076389662322472373');
    expect(result.status, 'failed');
    expect(result.idForStatusLookup, '07076389662322472373');
  });

  test('handles missing params safely', () {
    final result = MyFatoorahCallbackParser.parseString(
      'https://your-website.com/payment-callback',
    );

    expect(result.paymentId, isNull);
    expect(result.invoiceId, isNull);
    expect(result.trackId, isNull);
    expect(result.status, isNull);
    expect(result.hasPaymentId, isFalse);
    expect(result.idForStatusLookup, isNull);
  });

  test('parses uppercase and lowercase query variants', () {
    final result = MyFatoorahCallbackParser.parseString(
      'https://your-website.com/payment-callback'
      '?PaymentID=pay-1&InvoiceId=inv-1&TRACKID=track-1&STATUS=success',
    );

    expect(result.paymentId, 'pay-1');
    expect(result.invoiceId, 'inv-1');
    expect(result.trackId, 'track-1');
    expect(result.status, 'success');
  });

  test('uses Id fallback for hosted methods that return Id with paymentId', () {
    final result = MyFatoorahCallbackParser.parseString(
      'https://your-website.com/payment-callback?Id=07076127942302114071',
    );

    expect(result.paymentId, '07076127942302114071');
    expect(result.idForStatusLookup, '07076127942302114071');
  });
}
