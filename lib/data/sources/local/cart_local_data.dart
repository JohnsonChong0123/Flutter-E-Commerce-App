import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../core/errors/exception.dart';
import '../../models/cart/cart_model.dart';

abstract interface class CartLocalData {
  Future<CartModel> getLastCart();
  Future<void> cacheCart(CartModel cart);
  Future<void> clearCartCache();
}

class CartLocalDataImpl implements CartLocalData {
  final Database database;

  CartLocalDataImpl({required this.database});

  @override
  Future<void> cacheCart(CartModel cart) async {
    try {
      await database.insert('cart_cache', {
        'id': cart.id,
        'cart_json': jsonEncode(cart.toJson()),
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<CartModel> getLastCart() async {
    try {
      final rows = await database.query(
        'cart_cache',
        orderBy: 'cached_at DESC',
        limit: 1,
      );

      if (rows.isEmpty) {
        throw const CacheException('No cached cart found');
      }

      final cartJson = rows.first['cart_json'] as String?;
      if (cartJson == null || cartJson.isEmpty) {
        throw const CacheException('Cached cart is empty');
      }

      final decoded = jsonDecode(cartJson);
      if (decoded is! Map) {
        throw const CacheException('Cached cart is invalid');
      }

      return CartModel.fromJson(Map<String, dynamic>.from(decoded));
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearCartCache() async {
    try {
      await database.delete('cart_cache');
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
