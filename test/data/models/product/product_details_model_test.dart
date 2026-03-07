import 'package:e_commerce_client/data/models/product/product_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

import '../../../fixtures/product/product_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/product_details.json'));
  });

  test('fromJson should return valid ProductDetailsModel', () {
    // act
    final result = ProductDetailsModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tProductDetailsModel));
  });

  test('ProductDetailsModel.toEntity should convert correctly', () {
    // act
    final tProductDetailsModeltoEntity = tProductDetailsModel.toEntity();

    // assert
    expect(tProductDetailsModeltoEntity, equals(tProductDetailsEntity));
  });
}
