import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/core/my_fatoorah_environment.dart';
import 'package:my_fatoorah/src/web/embedded/my_fatoorah_embedded_web_controller.dart';
import 'package:my_fatoorah/src/web/embedded/my_fatoorah_embedded_web_interop.dart';
import 'package:my_fatoorah/src/web/embedded/my_fatoorah_embedded_web_script_loader.dart';

void main() {
  tearDown(MyFatoorahEmbeddedWebScriptLoader.resetForTesting);

  test('script loader loads each script URL once', () async {
    final loadedUrls = <String>[];
    final loader = MyFatoorahEmbeddedWebScriptLoader(
      loadScript: (url) async {
        loadedUrls.add(url);
      },
    );

    await loader.load('https://demo.myfatoorah.com/payment/v1/session.js');
    await loader.load('https://demo.myfatoorah.com/payment/v1/session.js');

    expect(loadedUrls, ['https://demo.myfatoorah.com/payment/v1/session.js']);
  });

  test('serializes documented JS config fields', () {
    const config = MyFatoorahEmbeddedWebConfig(
      sessionId: 'KWT-123',
      countryCode: 'KWT',
      currencyCode: 'KWD',
      amount: '10.000',
      containerId: 'embedded-payment',
    );

    expect(config.toJson(), {
      'sessionId': 'KWT-123',
      'countryCode': 'KWT',
      'currencyCode': 'KWD',
      'amount': '10.000',
      'containerId': 'embedded-payment',
    });
  });

  test('controller loads script and initializes interop', () async {
    final loadedUrls = <String>[];
    MyFatoorahEmbeddedWebConfig? initializedConfig;

    final controller = MyFatoorahEmbeddedWebController(
      scriptLoader: MyFatoorahEmbeddedWebScriptLoader(
        loadScript: (url) async {
          loadedUrls.add(url);
        },
      ),
      initializeInterop: ({required config, required onCallback}) {
        initializedConfig = config;
        onCallback({'isSuccess': true, 'sessionId': config.sessionId});
      },
    );

    Map<String, dynamic>? callbackData;
    Object? error;

    await controller.initialize(
      environment: MyFatoorahEnvironment.test,
      config: const MyFatoorahEmbeddedWebConfig(
        sessionId: 'KWT-123',
        countryCode: 'KWT',
        currencyCode: 'KWD',
        amount: '10.000',
        containerId: 'embedded-payment',
      ),
      onCallback: (data) {
        callbackData = data;
      },
      onError: (value) {
        error = value;
      },
    );

    expect(loadedUrls, ['https://demo.myfatoorah.com/payment/v1/session.js']);
    expect(initializedConfig?.containerId, 'embedded-payment');
    expect(callbackData, {'isSuccess': true, 'sessionId': 'KWT-123'});
    expect(error, isNull);
  });

  test('controller forwards loader errors to onError', () async {
    final controller = MyFatoorahEmbeddedWebController(
      scriptLoader: MyFatoorahEmbeddedWebScriptLoader(
        loadScript: (url) => Future<void>.error(StateError('load failed')),
      ),
      initializeInterop: ({required config, required onCallback}) {
        fail('Interop should not initialize when script loading fails.');
      },
    );

    Object? error;
    await controller.initialize(
      environment: MyFatoorahEnvironment.test,
      config: const MyFatoorahEmbeddedWebConfig(
        sessionId: 'KWT-123',
        countryCode: 'KWT',
        currencyCode: 'KWD',
        amount: '10.000',
        containerId: 'embedded-payment',
      ),
      onCallback: (_) {},
      onError: (value) {
        error = value;
      },
    );

    expect(error, isA<StateError>());
  });
}
