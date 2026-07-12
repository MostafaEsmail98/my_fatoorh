import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Loads a MyFatoorah Embedded Payment script in the browser.
Future<void> loadMyFatoorahEmbeddedWebScript(String url) {
  final existing = web.document.querySelector('script[src="$url"]');
  if (existing != null) {
    return Future<void>.value();
  }

  final completer = Completer<void>();
  final script = web.HTMLScriptElement()
    ..src = url
    ..async = true;

  script.addEventListener(
    'load',
    ((web.Event event) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }).toJS,
  );
  script.addEventListener(
    'error',
    ((web.Event event) {
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Failed to load MyFatoorah Embedded script: $url'),
        );
      }
    }).toJS,
  );

  final parent = web.document.head ?? web.document.body;
  if (parent == null) {
    return Future<void>.error(
      StateError('Unable to attach MyFatoorah Embedded script to the page.'),
    );
  }

  parent.append(script);
  return completer.future;
}
