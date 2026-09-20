import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:e_commerce_client/data/sources/remote/cart_remote_data.dart';

import '../../../test/fixtures/cart/cart_fixtures.dart';

class MockCartRemoteData implements CartRemoteData {
  @override
  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {}

  @override
  Future<void> clearCart() async {}

  @override
  Future<CartModel> getCart() async => tCartModel;

  @override
  Future<void> removeCartItem(String productId) async {}

  @override
  Future<void> updateCart({
    required String productId,
    required int quantity,
  }) async {}
}
