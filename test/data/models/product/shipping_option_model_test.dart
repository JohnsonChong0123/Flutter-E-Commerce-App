import 'package:e_commerce_client/data/models/product/shipping_option_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

import '../../../fixtures/product/product_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/shipping_option.json'));
  });

  test('fromJson should return valid ShippingOptionModel', () {
    // act
    final result = ShippingOptionModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tShippingOptionModel[0]));
  });

  test('ShippingOptionModel.toEntity should convert correctly', () {
    // act
    final result = tShippingOptionModel[0].toEntity();

    // assert
    expect(result, equals(tShippingOptionEntity[0]));
  });
}
