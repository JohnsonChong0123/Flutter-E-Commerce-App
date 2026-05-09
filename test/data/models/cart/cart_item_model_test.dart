import 'package:e_commerce_client/data/models/cart/cart_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/cart/cart_fixtures.dart';
import '../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  late Map<String, dynamic> tJsonMap;

  setUp(() {
    tJsonMap = jsonDecode(fixture('cart/cart_item.json'));
  });

  test('fromJson should return valid CartItemModel', () {
    // act
    final result = CartItemModel.fromJson(tJsonMap);

    // assert
    expect(result, equals(tCartItemModel));
  });

  test('CartItemModel.toEntity should convert correctly', () {
    // act
    final result = tCartItemModel.toEntity();

    // assert
    expect(result, tCartItemEntity);

    expect(result.productId, tCartItemModel.productId);
    expect(result.name, tCartItemModel.name);
    expect(result.price, tCartItemModel.price);
    expect(result.quantity, tCartItemModel.quantity);
    expect(result.imageUrl, tCartItemModel.imageUrl);
  });
}
