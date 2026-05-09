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
    final result = tCartModel.toEntity();

    // assert
    expect (result, tCartEntity);

    expect(result.id, tCartModel.id);
    expect(result.cartTotal, tCartModel.cartTotal);

    expect(result.items.length, tCartModel.items.length);

    expect(result.items.first.productId, tCartModel.items.first.productId);
    expect(result.items.first.name, tCartModel.items.first.name);
    expect(result.items.first.price, tCartModel.items.first.price);
    expect(result.items.first.quantity, tCartModel.items.first.quantity);
    expect(result.items.first.imageUrl, tCartModel.items.first.imageUrl);
  });
}
