import 'package:dio/dio.dart';
import '../../../core/errors/exception.dart';
import '../../models/wishlist/wishlist_model.dart';

abstract interface class WishlistRemoteData {
  Future<void> addWishlist(String productId);
  Future<List<WishlistModel>> getWishlist();
  Future<void> removeWishlist(String productId);
  Future<void> clearWishlist();
}

class WishlistRemoteDataImpl implements WishlistRemoteData {
  final Dio dio;

  WishlistRemoteDataImpl({required this.dio});
  @override
  Future<void> addWishlist(String productId) async {
    try {
      await dio.post(
        '/wishlist/add',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
        data: {'product_id': productId},
      );
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<WishlistModel>> getWishlist() async {
    try {
      final response = await dio.get('/wishlist');
      return (response.data as List)
          .map((json) => WishlistModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeWishlist(String productId) async {
    try {
      await dio.delete(
        '/wishlist/remove/$productId',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
      );
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> clearWishlist() async {
    try {
      await dio.delete(
        '/wishlist/clear',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'requiredAuth': true},
        ),
      );
    } on DioException catch (e) {
      final error = e.error;
      if (error is ServerException) {
        throw error;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
