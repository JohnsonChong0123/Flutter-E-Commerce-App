import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/data/models/cart/cart_model.dart';
import 'package:e_commerce_client/data/sources/local/cart_local_data.dart';

class MockCartLocalData implements CartLocalData {
  CartModel? _cachedCart;

  MockCartLocalData({CartModel? cachedCart}) : _cachedCart = cachedCart;

  @override
  Future<void> cacheCart(CartModel cart) async {
    _cachedCart = cart;
  }

  @override
  Future<CartModel> getLastCart() async {
    final cart = _cachedCart;
    if (cart == null) {
      throw const CacheException('No cached cart found');
    }
    return cart;
  }

  @override
  Future<void> clearCartCache() async {
    _cachedCart = null;
  }
}
