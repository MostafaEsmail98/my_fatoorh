import '../../core/my_fatoorah_environment.dart';

/// Selects the official MyFatoorah Embedded Payment script URL.
String myFatoorahEmbeddedWebScriptUrl({
  required MyFatoorahEnvironment environment,
  required String countryCode,
}) {
  if (environment == MyFatoorahEnvironment.test) {
    return 'https://demo.myfatoorah.com/payment/v1/session.js';
  }

  switch (countryCode.trim().toUpperCase()) {
    case 'KWT':
    case 'BHR':
    case 'JOR':
    case 'OMN':
      return 'https://portal.myfatoorah.com/payment/v1/session.js';
    case 'ARE':
    case 'UAE':
      return 'https://ae.myfatoorah.com/payment/v1/session.js';
    case 'SAU':
      return 'https://sa.myfatoorah.com/payment/v1/session.js';
    case 'QAT':
      return 'https://qa.myfatoorah.com/payment/v1/session.js';
    case 'EGY':
      return 'https://eg.myfatoorah.com/payment/v1/session.js';
  }

  throw ArgumentError.value(
    countryCode,
    'countryCode',
    'Unsupported MyFatoorah Embedded Web country code.',
  );
}
