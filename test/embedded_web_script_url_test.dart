import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_environment.dart';
import 'package:my_fatoorah/src/web/embedded/my_fatoorah_embedded_web_script_url.dart';

void main() {
  test('selects official test script URL for every country', () {
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.test,
        countryCode: 'KWT',
      ),
      'https://demo.myfatoorah.com/payment/v1/session.js',
    );
  });

  test('selects official live script URLs by country group', () {
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'KWT',
      ),
      'https://portal.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'BHR',
      ),
      'https://portal.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'JOR',
      ),
      'https://portal.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'OMN',
      ),
      'https://portal.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'ARE',
      ),
      'https://ae.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'SAU',
      ),
      'https://sa.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'QAT',
      ),
      'https://qa.myfatoorah.com/payment/v1/session.js',
    );
    expect(
      myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'EGY',
      ),
      'https://eg.myfatoorah.com/payment/v1/session.js',
    );
  });

  test('throws for unsupported live country code', () {
    expect(
      () => myFatoorahEmbeddedWebScriptUrl(
        environment: MyFatoorahEnvironment.live,
        countryCode: 'XYZ',
      ),
      throwsArgumentError,
    );
  });
}
