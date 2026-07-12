import 'package:flutter/widgets.dart';

/// Lightweight styling for MyFatoorah payment method widgets.
final class MyFatoorahPaymentMethodsStyle {
  /// Creates payment methods widget styling.
  const MyFatoorahPaymentMethodsStyle({
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.all(12),
    this.spacing = 8,
    this.showImages = true,
  });

  /// Border radius used by each payment method tile.
  final BorderRadius borderRadius;

  /// Inner padding used by each payment method tile.
  final EdgeInsetsGeometry padding;

  /// Space between payment method tiles.
  final double spacing;

  /// Whether payment method images should be shown when an image URL exists.
  final bool showImages;

  /// Creates a copy with selected fields replaced.
  MyFatoorahPaymentMethodsStyle copyWith({
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    double? spacing,
    bool? showImages,
  }) {
    return MyFatoorahPaymentMethodsStyle(
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      showImages: showImages ?? this.showImages,
    );
  }
}
