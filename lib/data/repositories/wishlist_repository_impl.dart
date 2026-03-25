import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:e_commerce_client/domain/entity/wishlist/wishlist_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/exception.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../sources/remote/wishlist_remote_data.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteData wishlistRemoteData;
  WishlistRepositoryImpl({required this.wishlistRemoteData});

  @override
  Future<Either<Failure, Unit>> addWishlist(String productId) async {
    try {
      await wishlistRemoteData.addWishlist(productId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<WishlistEntity>>> getWishlist() async {
    try {
      final wishlist = await wishlistRemoteData.getWishlist();
      return right(wishlist.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> removeWishlist(String productId) async {
    try {
      await wishlistRemoteData.removeWishlist(productId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> clearWishlist() async {
    try {
      await wishlistRemoteData.clearWishlist();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
