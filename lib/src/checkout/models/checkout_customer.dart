/// Optional customer information for high-level checkout flows.
///
/// The current Hosted Payment v3 request model in this SDK does not send these
/// fields to MyFatoorah. They are validated here so application-level checkout
/// code can keep a single typed request object.
final class CheckoutCustomer {
  /// Creates checkout customer information.
  const CheckoutCustomer({this.name, this.email, this.mobile});

  /// Customer display name, when collected by the app.
  final String? name;

  /// Customer email, when collected by the app.
  final String? email;

  /// Customer mobile number, when collected by the app.
  final String? mobile;

  /// Returns validation messages for provided customer fields.
  List<String> validate() {
    final emailValue = email?.trim();
    return [
      if (name != null && name!.trim().isEmpty)
        'Customer name must not be empty when provided.',
      if (emailValue != null &&
          emailValue.isNotEmpty &&
          !emailValue.contains('@'))
        'Customer email must be valid when provided.',
      if (mobile != null && mobile!.trim().isEmpty)
        'Customer mobile must not be empty when provided.',
    ];
  }
}
