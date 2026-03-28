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
    final tCartItemEntity = tCartItemModel.toEntity();

    // assert
    expect(tCartItemEntity.productId, tCartItemModel.productId);
    expect(tCartItemEntity.name, tCartItemModel.name);
    expect(tCartItemEntity.price, tCartItemModel.price);
    expect(tCartItemEntity.quantity, tCartItemModel.quantity);
    expect(tCartItemEntity.imageUrl, tCartItemModel.imageUrl);
  });
}
