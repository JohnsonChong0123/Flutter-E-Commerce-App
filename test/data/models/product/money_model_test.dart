import 'package:e_commerce_client/data/models/shipping/money_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

import '../../../fixtures/product/product_fixtures.dart';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('product/money.json'));
  });

  test('fromJson should return valid MoneyModel', () {
    // act
    final result = MoneyModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tMoneyModel));
  });

  test('MoneyModel.toEntity should convert correctly', () {
    // act
    final result = tMoneyModel.toEntity();

    // assert
    expect(result, equals(tMoneyEntity));
  });
}
