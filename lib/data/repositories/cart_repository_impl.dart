import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/core/database/app_database.dart';
import 'package:e_commerce_client/data/sources/local/cart_local_data.dart';
import 'package:e_commerce_client/domain/entity/cart/cart_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/exception.dart';
import '../../domain/repositories/cart_repository.dart';
import '../sources/remote/cart_remote_data.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteData cartRemoteData;
  final CartLocalData? cartLocalData;
  Future<CartLocalData>? _resolvedCartLocalData;

  CartRepositoryImpl({required this.cartRemoteData, this.cartLocalData});

  Future<CartLocalData> get _cartLocalData async {
    if (cartLocalData != null) {
      return cartLocalData!;
    }

    _resolvedCartLocalData ??= AppDatabase.database.then(
      (database) => CartLocalDataImpl(database: database),
    );

    return _resolvedCartLocalData!;
  }

  Future<void> _syncCartCache() async {
    try {
      final localData = await _cartLocalData;
      final cart = await cartRemoteData.getCart();
      await localData.cacheCart(cart);
    } catch (_) {
      // Cache sync is best-effort and must not break the primary repository flow.
    }
  }

  @override
  Future<Either<Failure, Unit>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      await cartRemoteData.addToCart(productId: productId, quantity: quantity);
      await _syncCartCache();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await cartRemoteData.getCart();
      try {
        final localData = await _cartLocalData;
        await localData.cacheCart(cart);
      } catch (_) {
        // Keep the remote result even if the cache write fails.
      }
      return right(cart.toEntity());
    } on ServerException catch (e) {
      try {
        final localData = await _cartLocalData;
        final cachedCart = await localData.getLastCart();
        return right(cachedCart.toEntity());
      } on CacheException catch (cacheError) {
        if (cacheError.message.contains('No cached cart found')) {
          return left(Failure(e.message));
        }
        return left(
          Failure(
            cacheError.message.isNotEmpty ? cacheError.message : e.message,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCartItem(String productId) async {
    try {
      await cartRemoteData.removeCartItem(productId);
      await _syncCartCache();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      await cartRemoteData.clearCart();
      try {
        final localData = await _cartLocalData;
        await localData.clearCartCache();
      } catch (_) {
        // Keep the remote success even if the local cache cannot be cleared.
      }
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      await cartRemoteData.updateCart(productId: productId, quantity: quantity);
      await _syncCartCache();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
