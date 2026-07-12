import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

/// Registers a Flutter Web HTML container for Embedded Payment.
bool registerMyFatoorahEmbeddedWebContainer({
  required String viewType,
  required String containerId,
  required double height,
  required String loadingText,
}) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    return web.HTMLDivElement()
      ..id = containerId
      ..textContent = loadingText
      ..setAttribute(
        'style',
        'width: 100%; height: 100%; min-height: ${height}px; '
            'box-sizing: border-box;',
      );
  });

  return true;
}
