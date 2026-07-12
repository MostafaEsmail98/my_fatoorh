// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_payment_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPaymentDetailsResponse _$GetPaymentDetailsResponseFromJson(
  Map<String, dynamic> json,
) => GetPaymentDetailsResponse(
  invoice: PaymentInvoice.fromJson(json['Invoice'] as Map<String, dynamic>),
  transaction: PaymentTransaction.fromJson(
    json['Transaction'] as Map<String, dynamic>,
  ),
  customer: PaymentCustomer.fromJson(json['Customer'] as Map<String, dynamic>),
  amount: PaymentAmount.fromJson(json['Amount'] as Map<String, dynamic>),
  suppliers: json['Suppliers'] as List<dynamic>? ?? const [],
);

Map<String, dynamic> _$GetPaymentDetailsResponseToJson(
  GetPaymentDetailsResponse instance,
) => <String, dynamic>{
  'Invoice': instance.invoice.toJson(),
  'Transaction': instance.transaction.toJson(),
  'Customer': instance.customer.toJson(),
  'Amount': instance.amount.toJson(),
  'Suppliers': instance.suppliers,
};
