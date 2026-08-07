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

  test('CartItemModel.toJson should serialize correctly', () {
    // act
    final result = tCartItemModel.toJson();

    // assert
    expect(result['product_id'], equals(tCartItemModel.productId));
    expect(result['name'], equals(tCartItemModel.name));
    expect(result['price'], equals(tCartItemModel.price));
    expect(result['quantity'], equals(tCartItemModel.quantity));
    expect(result['image_url'], equals(tCartItemModel.imageUrl));
    expect(result['shipping_options'], isA<List<dynamic>>());
  });
}
