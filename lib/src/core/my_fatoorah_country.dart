/// MyFatoorah country context.
///
/// Includes only countries and base URL groups documented by MyFatoorah.
final class MyFatoorahCountry {
  /// Creates a country context from a documented MyFatoorah country code.
  const MyFatoorahCountry(this.code, {String? liveApiBaseUrl})
    : liveApiBaseUrl = liveApiBaseUrl ?? _defaultLiveApiBaseUrl;

  /// Kuwait.
  static final kuwait = MyFatoorahCountry('KWT');

  /// Bahrain.
  static final bahrain = MyFatoorahCountry('BHR');

  /// Jordan.
  static final jordan = MyFatoorahCountry('JOR');

  /// Oman.
  static final oman = MyFatoorahCountry('OMN');

  /// United Arab Emirates.
  static final unitedArabEmirates = MyFatoorahCountry(
    'ARE',
    liveApiBaseUrl: 'https://api-ae.myfatoorah.com/',
  );

  /// Saudi Arabia.
  static final saudiArabia = MyFatoorahCountry(
    'SAU',
    liveApiBaseUrl: 'https://api-sa.myfatoorah.com/',
  );

  /// Qatar.
  static final qatar = MyFatoorahCountry(
    'QAT',
    liveApiBaseUrl: 'https://api-qa.myfatoorah.com/',
  );

  /// Egypt.
  static final egypt = MyFatoorahCountry(
    'EGY',
    liveApiBaseUrl: 'https://api-eg.myfatoorah.com/',
  );

  static const _defaultLiveApiBaseUrl = 'https://api.myfatoorah.com/';

  /// Official MyFatoorah country code, for example the code returned by
  /// documented MyFatoorah APIs.
  final String code;

  /// Live API base URL documented for this country group.
  final String liveApiBaseUrl;

  @override
  String toString() => code;
}
