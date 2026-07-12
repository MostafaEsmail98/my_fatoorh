/// Loads a MyFatoorah Embedded Payment script.
Future<void> loadMyFatoorahEmbeddedWebScript(String url) {
  return Future<void>.error(
    UnsupportedError('Embedded Web checkout is only available on Flutter Web.'),
  );
}
