import 'package:flutter/material.dart';

import '../../payments/methods/models/payment_method.dart';
import 'my_fatoorah_payment_methods_style.dart';

/// Displays one MyFatoorah payment method.
///
/// This widget is presentation-only. It does not fetch payment methods or call
/// MyFatoorah APIs.
final class MyFatoorahPaymentMethodTile extends StatelessWidget {
  /// Creates a payment method tile.
  const MyFatoorahPaymentMethodTile({
    required this.method,
    required this.selected,
    this.onSelected,
    this.style = const MyFatoorahPaymentMethodsStyle(),
    super.key,
  });

  /// Payment method to display.
  final PaymentMethod method;

  /// Whether this method is currently selected.
  final bool selected;

  /// Called when the tile is selected.
  final ValueChanged<PaymentMethod>? onSelected;

  /// Visual styling for the tile.
  final MyFatoorahPaymentMethodsStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderColor = selected ? colorScheme.primary : colorScheme.outline;
    final backgroundColor = selected
        ? colorScheme.primaryContainer.withValues(alpha: 0.28)
        : colorScheme.surface;

    return Semantics(
      button: true,
      selected: selected,
      label: method.paymentMethodEn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelected == null ? null : () => onSelected!(method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: style.padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: style.borderRadius,
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final label = Text(
                method.paymentMethodEn,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              );

              return Row(
                mainAxisSize: constraints.hasBoundedWidth
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  if (style.showImages &&
                      method.imageUrl.trim().isNotEmpty) ...[
                    _PaymentMethodImage(imageUrl: method.imageUrl),
                    SizedBox(width: style.spacing),
                  ],
                  if (constraints.hasBoundedWidth)
                    Expanded(child: label)
                  else
                    label,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _PaymentMethodImage extends StatelessWidget {
  const _PaymentMethodImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Image.network(
        imageUrl,
        width: 40,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _ImageFallback(colorScheme: colorScheme);
        },
      ),
    );
  }
}

final class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Icon(
          Icons.payment,
          size: 18,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
