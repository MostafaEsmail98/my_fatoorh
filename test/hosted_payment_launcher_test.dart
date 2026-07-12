import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/payments/hosted/hosted_payment_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  test('rejects invalid hosted payment URL', () async {
    final launcher = HostedPaymentLauncher(
      launch: (_, {required mode}) async => true,
      supportsLaunchModeFn: (_) async => true,
    );

    final result = await launcher.open('not a url');

    expect(result.isFailure, isTrue);
  });

  test('rejects non-http hosted payment URL', () async {
    final launcher = HostedPaymentLauncher(
      launch: (_, {required mode}) async => true,
      supportsLaunchModeFn: (_) async => true,
    );

    final result = await launcher.open('myapp://callback');

    expect(result.isFailure, isTrue);
  });

  test('uses in-app browser view when supported', () async {
    final launchedModes = <LaunchMode>[];
    final launcher = HostedPaymentLauncher(
      launch: (_, {required mode}) async {
        launchedModes.add(mode);
        return true;
      },
      supportsLaunchModeFn: (mode) async {
        return mode == LaunchMode.inAppBrowserView;
      },
    );

    final result = await launcher.open('https://example.com/pay');

    expect(result.isSuccess, isTrue);
    expect(launchedModes, [LaunchMode.inAppBrowserView]);
  });

  test(
    'falls back to platform default when in-app browser is unavailable',
    () async {
      final launchedModes = <LaunchMode>[];
      final launcher = HostedPaymentLauncher(
        launch: (_, {required mode}) async {
          launchedModes.add(mode);
          return true;
        },
        supportsLaunchModeFn: (_) async => false,
      );

      final result = await launcher.open('https://example.com/pay');

      expect(result.isSuccess, isTrue);
      expect(launchedModes, [LaunchMode.platformDefault]);
    },
  );

  test('falls back to platform default when in-app launch fails', () async {
    final launchedModes = <LaunchMode>[];
    final launcher = HostedPaymentLauncher(
      launch: (_, {required mode}) async {
        launchedModes.add(mode);
        return mode == LaunchMode.platformDefault;
      },
      supportsLaunchModeFn: (_) async => true,
    );

    final result = await launcher.open('https://example.com/pay');

    expect(result.isSuccess, isTrue);
    expect(launchedModes, [
      LaunchMode.inAppBrowserView,
      LaunchMode.platformDefault,
    ]);
  });

  test('returns failure when no launcher mode opens the URL', () async {
    final launcher = HostedPaymentLauncher(
      launch: (_, {required mode}) async => false,
      supportsLaunchModeFn: (_) async => false,
    );

    final result = await launcher.open('https://example.com/pay');

    expect(result.isFailure, isTrue);
  });
}
