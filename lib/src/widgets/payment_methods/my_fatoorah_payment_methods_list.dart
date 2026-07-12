import 'package:flutter/widgets.dart';

import '../../payments/methods/models/payment_method.dart';
import 'my_fatoorah_payment_method_tile.dart';
import 'my_fatoorah_payment_methods_style.dart';

/// Displays a selectable list of MyFatoorah payment methods.
///
/// This widget is intentionally lightweight. Fetch payment methods with
/// `myFatoorah.payments.methods.get(...)`, then pass the returned list here.
final class MyFatoorahPaymentMethodsList extends StatelessWidget {
  /// Creates a payment methods list.
  const MyFatoorahPaymentMethodsList({
    required this.methods,
    this.selectedPaymentMethodId,
    this.onSelected,
    this.style = const MyFatoorahPaymentMethodsStyle(),
    this.scrollDirection = Axis.vertical,
    super.key,
  });

  /// Payment methods to display.
  final List<PaymentMethod> methods;

  /// Currently selected MyFatoorah payment method ID.
  final int? selectedPaymentMethodId;

  /// Called when a payment method is selected.
  final ValueChanged<PaymentMethod>? onSelected;

  /// Visual styling for tiles and spacing.
  final MyFatoorahPaymentMethodsStyle style;

  /// List scroll direction.
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: scrollDirection,
      shrinkWrap: true,
      itemCount: methods.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          width: scrollDirection == Axis.horizontal ? style.spacing : 0,
          height: scrollDirection == Axis.vertical ? style.spacing : 0,
        );
      },
      itemBuilder: (context, index) {
        final method = methods[index];
        return MyFatoorahPaymentMethodTile(
          method: method,
          selected: method.paymentMethodId == selectedPaymentMethodId,
          onSelected: onSelected,
          style: style,
        );
      },
    );
  }
}
