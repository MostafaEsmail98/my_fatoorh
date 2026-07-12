import 'package:flutter_test/flutter_test.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_address.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_api_response.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_customer.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_invoice_item.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_metadata.dart';
import 'package:my_fatoorah/src/models/my_fatoorah_money.dart';
import 'package:my_fatoorah/src/serialization/my_fatoorah_date_converter.dart';

void main() {
  test('parses common API response with endpoint data', () {
    final response = MyFatoorahApiResponse<MyFatoorahCustomer>.fromJson({
      'IsSuccess': true,
      'Message': '',
      'ValidationErrors': null,
      'Data': {
        'Reference': 'customer-1',
        'Name': 'Anonymous',
        'Mobile': '+965',
        'Email': 'customer@example.com',
      },
    }, (json) => MyFatoorahCustomer.fromJson(json! as Map<String, Object?>));

    expect(response.isSuccess, isTrue);
    expect(response.data?.reference, 'customer-1');
    expect(response.data?.name, 'Anonymous');

    expect(response.toJson((customer) => customer.toJson()), {
      'IsSuccess': true,
      'Message': '',
      'Data': {
        'Name': 'Anonymous',
        'Mobile': '+965',
        'Email': 'customer@example.com',
        'Reference': 'customer-1',
      },
    });
  });

  test('parses common API response boolean strings and validation errors', () {
    final response = MyFatoorahApiResponse<Object?>.fromJson({
      'IsSuccess': 'false',
      'Message': 'Validation failed',
      'ValidationErrors': [
        {'Name': 'InvoiceValue', 'Error': 'Required'},
      ],
      'Data': null,
    }, (json) => json);

    expect(response.isSuccess, isFalse);
    expect(response.validationErrors, hasLength(1));
    expect(response.validationErrors?.single.name, 'InvoiceValue');
    expect(response.validationErrors?.single.error, 'Required');
  });

  test('serializes address using documented CustomerAddressModel fields', () {
    const address = MyFatoorahAddress(
      block: 'Block 1',
      street: 'Main Street',
      houseBuildingNo: '12',
      address: 'Full address',
      addressInstructions: 'Near entrance',
    );

    expect(address.toJson(), {
      'Block': 'Block 1',
      'Street': 'Main Street',
      'HouseBuildingNo': '12',
      'Address': 'Full address',
      'AddressInstructions': 'Near entrance',
    });
  });

  test('parses invoice item decimal values from strings and numbers', () {
    final item = MyFatoorahInvoiceItem.fromJson({
      'ItemName': 'Item Name',
      'Quantity': 2,
      'UnitPrice': 25,
      'Weight': '1.5',
      'Width': 10,
      'Height': '15',
      'Depth': 20,
    });

    expect(item.unitPrice, '25');
    expect(item.weight, '1.5');
    expect(item.width, '10');
    expect(item.height, '15');
    expect(item.depth, '20');
    expect(item.toJson(), {
      'ItemName': 'Item Name',
      'Quantity': 2,
      'UnitPrice': '25',
      'Weight': '1.5',
      'Width': '10',
      'Height': '15',
      'Depth': '20',
    });
  });

  test('serializes money and metadata wrappers', () {
    final money = MyFatoorahMoney.fromJson({'Amount': 20, 'Currency': 'KWD'});
    const metadata = MyFatoorahMetadata(
      values: {'orderId': 'ORD-1', 'attempt': 1},
    );

    expect(money.amount, '20');
    expect(money.toJson(), {'Amount': '20', 'Currency': 'KWD'});
    expect(metadata.toJson(), {
      'values': {'orderId': 'ORD-1', 'attempt': 1},
    });
  });

  test('converts ISO-8601 date values', () {
    const converter = MyFatoorahDateConverter();
    final date = converter.fromJson('2025-12-24T16:23:49.5900000Z');

    expect(date?.isUtc, isTrue);
    expect(converter.toJson(date), '2025-12-24T16:23:49.590Z');
  });
}
