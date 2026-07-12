import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

void main() {
  test('creates SDK with backend-only configuration', () {
    final config = MyFatoorahConfig.backendProxy(
      backendBaseUrl: Uri.parse('https://backend.example.com/myfatoorah/'),
      country: MyFatoorahCountry('TODO_OFFICIAL_COUNTRY_CODE'),
    );

    final sdk = MyFatoorah(config: config);

    expect(sdk.config.environment, MyFatoorahEnvironment.test);
    expect(sdk.config.language, MyFatoorahLanguage.english);
    expect(sdk.config.enableLogging, isFalse);
    expect(sdk.logger, isA<MyFatoorahNoopLogger>());
  });

  test('backendProxy config does not require API key', () {
    final config = MyFatoorahConfig.backendProxy(
      backendBaseUrl: Uri.parse('https://backend.example.com/myfatoorah/'),
    );

    expect(config.transportMode, MyFatoorahTransportMode.backendProxy);
    expect(
      config.backendBaseUrl,
      Uri.parse('https://backend.example.com/myfatoorah/'),
    );
  });

  test('public barrel does not export internal HTTP or service clients', () {
    if (kIsWeb) {
      return;
    }

    final publicBarrel = File('lib/my_fatoorah.dart').readAsStringSync();

    expect(publicBarrel, isNot(contains("export 'src/client/")));
    expect(
      publicBarrel,
      isNot(
        contains("export 'src/payments/hosted/hosted_payment_client.dart'"),
      ),
    );
    expect(
      publicBarrel,
      isNot(
        contains("export 'src/payments/status/payment_status_client.dart'"),
      ),
    );
    expect(
      publicBarrel,
      isNot(
        contains("export 'src/payments/embedded/embedded_payment_client.dart'"),
      ),
    );
    expect(publicBarrel, isNot(contains('MyFatoorahClient')));
    expect(publicBarrel, isNot(contains('MyFatoorahHttpClient')));
    expect(publicBarrel, isNot(contains('HostedPaymentClient')));
    expect(publicBarrel, isNot(contains('PaymentStatusClient')));
    expect(publicBarrel, isNot(contains('EmbeddedPaymentClient')));
  });
}
