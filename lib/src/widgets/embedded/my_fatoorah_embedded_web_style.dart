import 'package:flutter/widgets.dart';

/// Styling for the optional MyFatoorah Embedded Web checkout widget.
final class MyFatoorahEmbeddedWebStyle {
  /// Creates Embedded Web checkout styling.
  const MyFatoorahEmbeddedWebStyle({
    this.height = 420,
    this.loadingText = 'Loading MyFatoorah checkout...',
    this.unsupportedText =
        'Embedded Web checkout is only available on Flutter Web.',
    this.padding = const EdgeInsets.all(16),
  });

  /// Height reserved for the web checkout container.
  final double height;

  /// Text shown inside the web HTML container before MyFatoorah JS renders.
  final String loadingText;

  /// Text shown on Android, iOS, desktop, and other non-web platforms.
  final String unsupportedText;

  /// Padding around fallback text on unsupported platforms.
  final EdgeInsetsGeometry padding;

  /// Creates a copy with selected fields replaced.
  MyFatoorahEmbeddedWebStyle copyWith({
    double? height,
    String? loadingText,
    String? unsupportedText,
    EdgeInsetsGeometry? padding,
  }) {
    return MyFatoorahEmbeddedWebStyle(
      height: height ?? this.height,
      loadingText: loadingText ?? this.loadingText,
      unsupportedText: unsupportedText ?? this.unsupportedText,
      padding: padding ?? this.padding,
    );
  }
}
