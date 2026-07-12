import 'package:url_launcher/url_launcher.dart';

import '../../core/my_fatoorah_result.dart';
import '../../exceptions/my_fatoorah_exception.dart';
import '../../exceptions/my_fatoorah_validation_exception.dart';

typedef HostedUrlLauncher =
    Future<bool> Function(Uri url, {required LaunchMode mode});
typedef HostedLaunchModeSupport = Future<bool> Function(LaunchMode mode);

/// Internal Hosted Payment URL launcher.
///
/// This class is intentionally internal so the public SDK does not expose
/// `url_launcher` types. The public facade returns [MyFatoorahResult] only.
final class HostedPaymentLauncher {
  /// Creates a Hosted Payment launcher.
  const HostedPaymentLauncher({
    HostedUrlLauncher? launch,
    HostedLaunchModeSupport? supportsLaunchModeFn,
  }) : _launch = launch ?? launchUrl,
       _supportsLaunchMode = supportsLaunchModeFn ?? supportsLaunchMode;

  final HostedUrlLauncher _launch;
  final HostedLaunchModeSupport _supportsLaunchMode;

  /// Opens a MyFatoorah Hosted Payment URL.
  Future<MyFatoorahResult<void>> open(String paymentUrl) async {
    final trimmedUrl = paymentUrl.trim();
    final uri = Uri.tryParse(trimmedUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return const MyFatoorahResult.failure(
        MyFatoorahValidationException(
          'PaymentURL must be a valid absolute URL.',
        ),
      );
    }

    if (uri.scheme != 'https' && uri.scheme != 'http') {
      return const MyFatoorahResult.failure(
        MyFatoorahValidationException('PaymentURL must use http or https.'),
      );
    }

    try {
      final supportsInAppBrowser = await _supportsLaunchMode(
        LaunchMode.inAppBrowserView,
      );

      if (supportsInAppBrowser) {
        final openedInApp = await _launch(
          uri,
          mode: LaunchMode.inAppBrowserView,
        );
        if (openedInApp) {
          return const MyFatoorahResult.success(null);
        }
      }

      final opened = await _launch(uri, mode: LaunchMode.platformDefault);
      if (opened) {
        return const MyFatoorahResult.success(null);
      }

      return const MyFatoorahResult.failure(
        MyFatoorahException('Could not open Hosted Payment URL.'),
      );
    } on Object catch (error, stackTrace) {
      return MyFatoorahResult.failure(
        MyFatoorahException(
          'Could not open Hosted Payment URL.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
