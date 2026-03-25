import 'package:e_commerce_client/domain/entity/wishlist/wishlist_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';

abstract interface class WishlistRepository {
  Future<Either<Failure, Unit>> addWishlist(
    String productId,
  );
  Future<Either<Failure, List<WishlistEntity>>> getWishlist();

  Future<Either<Failure, Unit>> removeWishlist(
    String productId,
  );

  Future<Either<Failure, Unit>> clearWishlist();
}
