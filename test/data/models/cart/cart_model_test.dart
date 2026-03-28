import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/cart/cart_fixtures.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('cart/cart.json'));
  });

  test('fromJson should return valid CartModel', () {
    // act
    final result = CartModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tCartModel));
  });

  test('CartModel.toEntity should convert correctly', () {
    // act
    final tCartEntity = tCartModel.toEntity();

    // assert
    expect(tCartEntity.id, tCartModel.id);
    expect(tCartEntity.items, tCartModel.items.map((item) => item.toEntity()).toList());
    expect(tCartEntity.cartTotal, tCartModel.cartTotal);
  });
}
