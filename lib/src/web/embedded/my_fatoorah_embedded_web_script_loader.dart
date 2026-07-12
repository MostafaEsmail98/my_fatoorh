import 'my_fatoorah_embedded_web_script_loader_platform.dart';

/// Loads the official MyFatoorah Embedded Payment script.
typedef MyFatoorahEmbeddedWebScriptLoad = Future<void> Function(String url);

/// Ensures MyFatoorah Embedded Payment scripts are loaded once per URL.
final class MyFatoorahEmbeddedWebScriptLoader {
  /// Creates a script loader.
  const MyFatoorahEmbeddedWebScriptLoader({
    this.loadScript = loadMyFatoorahEmbeddedWebScript,
  });

  static final Map<String, Future<void>> _loads = {};

  /// Low-level script loading function.
  final MyFatoorahEmbeddedWebScriptLoad loadScript;

  /// Loads [url] once, sharing any in-flight load with future callers.
  Future<void> load(String url) {
    return _loads.putIfAbsent(url, () => loadScript(url));
  }

  /// Clears cached script loads for tests.
  static void resetForTesting() {
    _loads.clear();
  }
}
