/// Documented MyFatoorah Webhook V2 event types.
enum MyFatoorahWebhookType {
  /// PAYMENT_STATUS_CHANGED, code 1.
  paymentStatusChanged(1, 'PAYMENT_STATUS_CHANGED'),

  /// REFUND_STATUS_CHANGED, code 2.
  refundStatusChanged(2, 'REFUND_STATUS_CHANGED'),

  /// BALANCE_TRANSFERRED, code 3.
  balanceTransferred(3, 'BALANCE_TRANSFERRED'),

  /// SUPPLIER_STATUS_CHANGED, code 4.
  supplierStatusChanged(4, 'SUPPLIER_STATUS_CHANGED'),

  /// RECURRING_UPDATES, code 5.
  recurringUpdates(5, 'RECURRING_UPDATES'),

  /// DISPUTE_STATUS_CHANGED, code 6.
  disputeStatusChanged(6, 'DISPUTE_STATUS_CHANGED'),

  /// SUPPLIER_UPDATE_REQUEST_CHANGED, code 7.
  supplierUpdateRequestChanged(7, 'SUPPLIER_UPDATE_REQUEST_CHANGED');

  const MyFatoorahWebhookType(this.code, this.eventName);

  /// Documented event code.
  final int code;

  /// Documented event name.
  final String eventName;

  /// Finds a webhook type from documented code/name values.
  static MyFatoorahWebhookType? from({int? code, String? name}) {
    for (final type in values) {
      final matchesCode = code == null || type.code == code;
      final matchesName = name == null || type.eventName == name;
      if (matchesCode && matchesName) {
        return type;
      }
    }
    return null;
  }
}
