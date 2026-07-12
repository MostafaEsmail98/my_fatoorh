import 'package:flutter/foundation.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

final class ExampleAppState extends ChangeNotifier {
  MyFatoorahEnvironment environment = MyFatoorahEnvironment.test;
  String backendBaseUrl = 'http://localhost:8080';
  MyFatoorahCountry country = const MyFatoorahCountry('KWT');
  MyFatoorahLanguage language = MyFatoorahLanguage.english;

  void save({
    required MyFatoorahEnvironment environment,
    required String backendBaseUrl,
  }) {
    this.environment = environment;
    this.backendBaseUrl = backendBaseUrl.trim();
    notifyListeners();
  }

  String? get configurationError {
    final uri = Uri.tryParse(backendBaseUrl.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Enter a valid backend base URL.';
    }
    return null;
  }

  MyFatoorah createClient() {
    final error = configurationError;
    if (error != null) {
      throw StateError(error);
    }

    final config = MyFatoorahConfig.backendProxy(
      backendBaseUrl: Uri.parse(backendBaseUrl),
      environment: environment,
      country: country,
      language: language,
      enableLogging: true,
    );

    return MyFatoorah(config: config);
  }
}
