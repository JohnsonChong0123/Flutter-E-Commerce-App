import 'package:e_commerce_client/data/models/product/product_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

import '../../../fixtures/product/product_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/product_summary.json'));
  });

  test('fromJson should return valid ProductSummaryModel', () {
    // act
    final result = ProductSummaryModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tProductSummaryModel));
  });

  test('ProductSummaryModel.toEntity should convert correctly', () {
    // act
    final tProductDetailsModeltoEntity = tProductSummaryModel.toEntity();

    // assert
    expect(tProductDetailsModeltoEntity, equals(tProductSummaryEntity));
  });
}
